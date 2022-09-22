import 'package:darq/darq.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/parsers/parse_media_data.dart';

class ActiveMediaItemController extends GetxController {
  var activeMediaUrl = RxnString();
  var activeMediaSrc = RxnString();
  var playlist = Rxn<List<String>>();
  var mediaItem = Rxn<MediaItem>();

  setActiveMedia({String? withUrl}) {
    activeMediaUrl.value = withUrl;
  }

  resetCtrl() {
    // activeMediaUrl.value = null;
    activeMediaSrc.value = null;
    playlist.value = null;
    mediaItem.value = null;
  }

  getMediaData() async {
    resetCtrl();
    if (activeMediaUrl.value == null) {
      return;
    }

    var url = Uri.parse(activeMediaUrl.value!);
    var response = await http.get(url);
    var document = parse(response.body);

    Map<String, List<String>>? playlists;
    var title = MediaDataParser.parseTitle(document: document);
    var poster = MediaDataParser.parsePosterUrl(document: document) ?? "";
    var mediaInfo = MediaDataParser.parseFilmInfo(document: document);

    var ajaxPlaylist =
        document.getElementsByClassName("playlists-ajax").firstOrDefault(defaultValue: null);
    if (ajaxPlaylist != null) {
      playlists = await _getAjaxPlaylist(ajaxPlaylist);
    } else {
      _parseFilmSource(document);
    }

    mediaItem.value = MediaItem(title ?? "", poster, mediaInfo, playlists: playlists);
    logger.i("Info loaded");
  }

  Future<Map<String, List<String>>> _getAjaxPlaylist(Element ajaxPlaylist) async {
    var xfname = ajaxPlaylist.attributes["data-xfname"] ?? "";
    var newsId = ajaxPlaylist.attributes["data-news_id"] ?? "";
    var url = Uri(
        scheme: "https",
        host: "uakino.club",
        path: "engine/ajax/playlists.php",
        queryParameters: <String, String>{"news_id": newsId, "xfield": xfname});
    var response = await http.get(url);
    var document = parse(response.body.replaceAll("\\\"", "\"").replaceAll("\\/", "/"));
    var list = document.querySelectorAll("li[data-file]");
    var map = <String, List<String>>{};
    for (var element in list) {
      if (element.attributes["data-voice"] != null && element.attributes["data-file"] != null) {
        map[element.attributes["data-voice"]!] = [element.attributes["data-file"]!];
      }
    }
    return map;
  }

  void _parseFilmSource(Document document) async {
    var iframes = document.getElementsByTagName("iframe");

    var src =
        iframes.firstWhereOrNull((element) => element.attributes["src"] != null)?.attributes["src"];

    logger.d("src: $src");

    if (src == null) {
      return;
    }

    activeMediaSrc.value = await _getMediaSourceUrl(src);
    logger.i("Source loaded");
  }

  Future<String?> _getMediaSourceUrl(String src) async {
    var iframeUrl = Uri.parse(src);
    var iframeResponse = await http.get(iframeUrl);

    RegExp exp = RegExp(r'https?:\/\/.+(?=\")');
    var iframeDocument = parse(iframeResponse.body);
    var scripNode = iframeDocument.querySelector("body script");

    if (scripNode == null) {
      return null;
    }

    RegExpMatch? match = exp.firstMatch(scripNode.text);

    return match?[0];
  }
}
