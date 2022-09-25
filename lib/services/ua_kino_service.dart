import 'package:darq/darq.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/parsers/parse_media_data.dart';

class UaKinoService extends GetxService {
  final http = Dio(BaseOptions(baseUrl: "https://uakino.club"));
  final AppState _state = Get.find();
  final LibraryController _c = Get.find();

  @override
  void onInit() {
    super.onInit();
    getHomepageData();
  }

  Future<void> getHomepageData() async {
    try {
      var response = await http.get<String>("/");

      // TODO implement parsing n a separate thread
      // var res = await compute(parse, response.body)
      var document = parse(response.data);

      logger.i("Home page data loaded");

      var menuItems = MediaDataParser.parseMenu(document: document);
      _state.updateMenuItems(menuItems);
      var carousels = MediaDataParser.parseHomePageData(document: document);
      _c.updateCarousels(carousels);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<MediaItem> getMediaData(String url) async {
    try {
      var response = await http.get<String>(url);
      var document = parse(response.data);

      var title = MediaDataParser.parseTitle(document: document);
      var poster = MediaDataParser.parsePosterUrl(document: document) ?? "";
      var mediaInfo = MediaItemInfo.fromHTML(document);

      var mediaItem = MediaItem(title ?? "", poster, mediaInfo);

      var ajaxPlaylist =
          document.getElementsByClassName("playlists-ajax").firstOrDefault(defaultValue: null);
      if (ajaxPlaylist != null) {
        mediaItem.playlists = await _getAjaxPlaylist(ajaxPlaylist);
      } else {
        mediaItem.source = await _parseFilmSource(document);
      }

      logger.i("Info loaded, $mediaItem");
      return mediaItem;
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<Map<String, List<String>>> _getAjaxPlaylist(Element ajaxPlaylist) async {
    var response = await http.get<String>(MediaDataParser.getAjaxPlaylist(ajaxPlaylist));
    var document = parse(response.data?.replaceAll("\\\"", "\"").replaceAll("\\/", "/"));

    return MediaDataParser.parseAjaxPlaylist(document: document);
  }

  Future<String?> _parseFilmSource(Document document) async {
    var iframes = document.getElementsByTagName("iframe");

    var src =
        iframes.firstWhereOrNull((element) => element.attributes["src"] != null)?.attributes["src"];

    logger.d("src: $src");

    if (src == null) {
      logger.i("No media source");
      return null;
    }

    logger.i("Source loaded");
    return await _getMediaSourceUrl(src);
  }

  Future<String?> _getMediaSourceUrl(String src) async {
    var iframeResponse = await http.get<String>(src);

    RegExp exp = RegExp(r'https?:\/\/.+(?=\")');
    var iframeDocument = parse(iframeResponse.data);
    var scripNode = iframeDocument.querySelector("body script");

    if (scripNode == null) {
      return null;
    }

    RegExpMatch? match = exp.firstMatch(scripNode.text);

    return match?[0];
  }
}
