import 'package:html/dom.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_carousel.dart';
import 'package:uakino/models/media/media_info_key.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/models/sidebar/submenu_item.dart';

const String _titleSelector = ".alltitle h1";
const String _playlistVideos = ".playlists-videos li";

const String _posterSelector = ".film-poster > a";

const String _filmInfoSelector = ".film-info .fi-item";
const String _seriesInfoSelector = ".film-info .fi-item-s";
const String _filmInfoLabel = ".fi-label";
const String _filmInfoDescription = ".fi-desc";
const String _filmDescription = "div[itemprop=\"description\"]";

const String _titlesSelector = ".main-section-inner > .msi-title > .sidebar-title";
const String _movieTitleSelector = ".movie-title";
const String _movieItemSelector = ".movie-item";
const String _seasonSelector = ".full-season";

const _host = "https://uakino.club";

class MediaDataParser {
  static String? parseTitle({required Document document}) {
    return document.querySelector(_titleSelector)?.text.trim();
  }

  static void parsePlaylistData({required Document document}) {
    var listNodes = document.querySelectorAll(_playlistVideos);

    for (var element in listNodes) {
      element.attributes["data-file"];
      element.attributes["data-id"];
      element.attributes["data-voice"];
    }
  }

  static String? parsePosterUrl({required Document document}) {
    var posterNode = document.querySelector(_posterSelector);
    return posterNode?.attributes["href"];
  }

  static Map<String, String> parseSeriesInfo({required Document document}) {
    var map = <String, String>{};

    var infoListNodes = document.querySelectorAll(_seriesInfoSelector);

    for (var element in infoListNodes) {
      var key = element.querySelector(_filmInfoLabel)?.text;
      var value = element.querySelector(_filmInfoDescription)?.text;

      logger.d("key $key");
      logger.d("key $value");

      if (key != null && value != null) {
        map[key] = value;
      }
    }
    return map;
  }

  static Map<MediaInfoKey, String> parseFilmInfo({required Document document}) {
    var map = <MediaInfoKey, String>{};

    var infoListNodes = document.querySelectorAll(_filmInfoSelector);

    infoListNodes.removeLast();

    for (var element in infoListNodes) {
      var labelNode = element.querySelector(_filmInfoLabel);
      var key = labelNode?.text.trim();
      var value = element.querySelector(_filmInfoDescription)?.text.trim();

      if (labelNode != null && labelNode.getElementsByTagName("img").isNotEmpty) {
        key = "imdb";
      }
      if (key != null && key.contains("Списки")) {
        continue;
        // TODO add in future
        value = labelNode?.parent?.text;
      }

      if (key != null && value != null) {
        switch (key) {
          case "Якість:":
            map[MediaInfoKey.quality] = value;
            break;
          case "Рік виходу:":
            map[MediaInfoKey.year] = value;
            break;
          case "Країна:":
            map[MediaInfoKey.country] = value;
            break;
          case "Жанр:":
            map[MediaInfoKey.genres] = value.replaceAll(RegExp(r'\s*,\s+'), ", ");
            break;
          case "Режисер:":
            map[MediaInfoKey.producer] = value;
            break;
          case "Актори:":
            map[MediaInfoKey.actors] = value.replaceAll(RegExp(r'\s*,\s+'), ", ");
            break;
          case "Тривалість:":
            map[MediaInfoKey.duration] = value;
            break;
          case "Мова озвучення:":
            map[MediaInfoKey.lang] = value;
            break;
          case "imdb":
            map[MediaInfoKey.imdbScore] = value;
            break;
          default:
            break;
        }
      }
    }
    var description = document.querySelector(_filmDescription)?.text.trim();
    if (description != null) {
      map[MediaInfoKey.description] = description;
    }

    return map;
  }

  static Iterable<MenuItem> parseMenu({required Document document}) {
    return document.querySelectorAll("nav .main-menu > li").map((Element el) {
      var link = el.querySelector("a");
      var item = MenuItem(title: link?.text.trim() ?? "[DEBUG ME]");
      item.path = link?.attributes["href"];

      el.querySelectorAll(".hidden-menu ul li a").forEach((element) {
        item.submenus.add(SubmenuItem(
            title: element.text.trim(), path: element.attributes["href"] ?? "[DEBUG ME]"));
      });
      return item;
    });
  }

  static List<MediaCarousel> parseHomePageData({required Document document}) {
    var titleNodes = document.querySelectorAll(_titlesSelector);

    return titleNodes.map((e) => _buildCarouselData(e)).toList(growable: false);
  }

  static MediaCarousel _buildCarouselData(Element titleElement) {
    var title = titleElement.text;

    var movieElements = titleElement.parent!.parent!.querySelectorAll(_movieItemSelector);
    var movies = movieElements.map((movieElement) {
      var a = movieElement.querySelector(_movieTitleSelector);
      return MediaPreviewItem(
          image: _host + (movieElement.querySelector("img")?.attributes["src"] ?? ""),
          title: a?.text.trim() ?? "[EMPTY]",
          url: a?.attributes["href"] ?? "",
          seasonDescription: movieElement.querySelector(_seasonSelector)?.text.trim());
    }).toList(growable: false);

    var mediaCarousel = MediaCarousel(title, movies);

    if (titleElement.nextElementSibling?.localName == "a") {
      mediaCarousel.actionPath = titleElement.nextElementSibling!.attributes["href"];
    }
    return mediaCarousel;
  }

  static String getAjaxPlaylist(Element ajaxPlaylist) {
    var xfname = ajaxPlaylist.attributes["data-xfname"] ?? "";
    var newsId = ajaxPlaylist.attributes["data-news_id"] ?? "";
    return "/engine/ajax/playlists.php?news_id=$newsId}&xfield=$xfname";
    // return Uri(
    //     scheme: "https",
    //     host: "uakino.club",
    //     path: "engine/ajax/playlists.php",
    //     queryParameters: <String, String>{"news_id": newsId, "xfield": xfname});
  }

  static Map<String, List<String>> parseAjaxPlaylist({required Document document}) {
    var list = document.querySelectorAll("li[data-file]");
    var map = <String, List<String>>{};
    for (var element in list) {
      if (element.attributes["data-voice"] != null && element.attributes["data-file"] != null) {
        map[element.attributes["data-voice"]!] = [element.attributes["data-file"]!];
      }
    }
    return map;
  }
}
