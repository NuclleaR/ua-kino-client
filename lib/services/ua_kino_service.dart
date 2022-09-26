import 'dart:async';
import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/models/media/media_item_resource.dart';
import 'package:uakino/parsers/parse_media_data.dart';

class UaKinoService extends GetxService {
  final http = Dio(BaseOptions(baseUrl: "https://uakino.club"));
  final AppState _state = Get.find();
  final LibraryController _c = Get.find();
  late final StreamSubscription<bool> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _state.$isConnected.listen((val) {
      logger.i("Connected state: $val");
      if (val) {
        getHomepageData();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }

  Future<void> getHomepageData() async {
    try {
      var response = await http.get<String>("/");

      // TODO implement parsing n a separate thread
      // var res = await compute(parse, response.body)
      var document = parse(response.data);

      var menuItems = MediaDataParser.parseMenu(document: document);
      _state.updateMenuItems(menuItems);
      var carousels = MediaDataParser.parseHomePageData(document: document);
      _c.updateCarousels(carousels);
    } on DioError catch (e) {
      Get.defaultDialog(
        onConfirm: () => {Get.back()},
        title: "Error",
        middleText: e.message,
      );
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
        mediaItem.rawPlaylist = await _getAjaxPlaylist(ajaxPlaylist);
      } else {
        mediaItem.rawSource = _parseFilmSource(document);
      }

      return mediaItem;
    } on DioError catch (e) {
      loggerRaw.e(e.message, e, e.stackTrace);
      rethrow;
    }
  }

  Future<MediaItemResource> getMediaSource(MediaItem mediaItem) async {
    if (mediaItem.rawSource != null) {
      var sourceUrl = await _getMediaSourceUrl(mediaItem.rawSource!);
      return MediaItemResource(source: sourceUrl);
    } else if (mediaItem.rawPlaylist != null) {
      var srcMap = <Voice, Map<String, Source>>{};

      var entries = await Future.wait(mediaItem.rawPlaylist!.entries.map((entry) async {
        var src = await _getMediaSourceUrl(entry.key);
        return [...entry.value.split("|"), src ?? ""];
      }));

      for (var entry in entries) {
        var voice = entry[0];
        var title = entry[1];
        if (srcMap.containsKey(voice)) {
          srcMap[voice]?.putIfAbsent(title, () => entry[2]);
        } else {
          srcMap[voice] = {title: entry[2]};
        }
      }

      return MediaItemResource(playlists: srcMap);
    }
    return MediaItemResource();
  }

  Future<Map<Source, Voice>> _getAjaxPlaylist(Element ajaxPlaylist) async {
    try {
      var response = await http.get<String>(MediaDataParser.getAjaxPlaylist(ajaxPlaylist));
      if (response.data == null) {
        throw "Empty response";
      }
      var decoded = json.decode(response.data!);
      var document = parse(decoded["response"]);

      return MediaDataParser.parseAjaxPlaylist(document: document);
    } on DioError catch (e) {
      loggerRaw.e(e, e, e.stackTrace);
      rethrow;
    }
  }

  String? _parseFilmSource(Document document) {
    var iframes = document.getElementsByTagName("iframe");

    var src =
        iframes.firstWhereOrNull((element) => element.attributes["src"] != null)?.attributes["src"];

    if (src == null) {
      logger.e("No media source");
      return null;
    }

    return src;
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
