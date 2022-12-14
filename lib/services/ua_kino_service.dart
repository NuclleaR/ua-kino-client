import 'dart:async';
import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uakino/dto/filters.dart';
import 'package:uakino/dto/grid_response.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/models/media/media_item_resource.dart';
import 'package:uakino/parsers/parse_media_data.dart';

class UaKinoService extends GetxService {
  final http = Dio(BaseOptions(baseUrl: "https://uakino.club"));
  CancelToken _cancelToken = CancelToken();

  Future<Document> getHomepageData() async {
    logger.i("Get initial data");
    try {
      var response = await http.get<String>("/");

      var document = await compute(parse, response.data);

      return document;
    } on DioError catch (e) {
      Get.defaultDialog(
        onConfirm: () => {Get.back()},
        title: "Error",
        middleText: e.message,
      );
      rethrow;
    }
  }

  Future<GridResponse> getGridData(String path, [Filters? filters]) async {
    logger.i("Get Grid Data");
    try {
      var formData = FormData.fromMap({
        "data": (filters ?? Filters()).toString(),
        "url": path,
      });
      var response = await http.post<String>("/engine/lazydev/dle_filter/ajax.php", data: formData);
      if (response.data == null) {
        throw "Empty response";
      }

      return compute(MediaDataParser.parseGridData, response.data!);
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
        mediaItem.rawSource = MediaDataParser.parseFilmSource(document);
      }

      return mediaItem;
    } on DioError catch (e) {
      loggerRaw.e(e.message, e, e.stackTrace);
      rethrow;
    }
  }

  Future<GridResponse> search(String search, [int page = 1]) async {
    logger.i("Search $search");
    try {
      _cancelToken.cancel();
      _cancelToken = CancelToken();

      var response = await http.get<String>(
        "?do=search&subaction=search&from_page=$page&story=$search",
        cancelToken: _cancelToken,
      );
      return compute(MediaDataParser.parseSearchData, response.data!);
    } on DioError catch (e) {
      loggerRaw.e(e.message, e, e.stackTrace);
      if (e.type == DioErrorType.cancel) {
        return GridResponse([], 0);
      }
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
