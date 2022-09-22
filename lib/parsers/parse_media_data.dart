import 'package:html/dom.dart';
import 'package:uakino/logger/logger.dart';

const String titleSelector = ".alltitle h1";
const String playlistVideos = ".playlists-videos li";

const String posterSelector = ".film-poster > a";

const String filmInfoSelector = ".film-info .fi-item";
const String seriesInfoSelector = ".film-info .fi-item-s";
const String filmInfoLabel = ".fi-label";
const String filmInfoDescription = ".fi-desc";

class MediaDataParser {
  static String? parseTitle({required Document document}) {
    return document.querySelector(titleSelector)?.text.trim();
  }

  static void parsePlaylistData({required Document document}) {
    var listNodes = document.querySelectorAll(playlistVideos);

    for (var element in listNodes) {
      element.attributes["data-file"];
      element.attributes["data-id"];
      element.attributes["data-voice"];
    }
  }

  static String? parsePosterUrl({required Document document}) {
    var posterNode = document.querySelector(posterSelector);
    return posterNode?.attributes["href"];
  }

  static Map<String, String> parseSeriesInfo({required Document document}) {
    var map = <String, String>{};

    var infoListNodes = document.querySelectorAll(seriesInfoSelector);

    for (var element in infoListNodes) {
      var key = element.querySelector(filmInfoLabel)?.text;
      var value = element.querySelector(filmInfoDescription)?.text;

      logger.d("key $key");
      logger.d("key $value");

      if (key != null && value != null) {
        map[key] = value;
      }
    }
    return map;
  }

  static Map<String, String> parseFilmInfo({required Document document}) {
    var map = <String, String>{};

    var infoListNodes = document.querySelectorAll(filmInfoSelector);

    infoListNodes.removeLast();

    for (var element in infoListNodes) {
      var labelNode = element.querySelector(filmInfoLabel);
      var key = labelNode?.text.trim();
      var value = element.querySelector(filmInfoDescription)?.text.trim();

      if (labelNode != null && labelNode.getElementsByTagName("img").isNotEmpty) {
        key = "IMDb";
      }
      if (key != null && key.contains("Списки")) {
        continue;
        // TODO add in future
        value = labelNode?.parent?.text;
      }

      if (key != null && value != null) {
        map[key] = value.replaceAll(" , ", ", ");
      }
    }

    return map;
  }
}
