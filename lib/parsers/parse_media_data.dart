import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:uakino/dto/grid_response.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_carousel.dart';
import 'package:uakino/models/media/media_info_key.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/models/sidebar/submenu_item.dart';

const String _titleSelector = "h1 .solototle";
const String _playlistVideos = ".playlists-videos li";

const String _posterSelector = ".film-poster > a";

const String _filmInfoSelector = ".film-info .fi-item";
const String _seriesInfoSelector = ".film-info .fi-item-s";
const String _filmInfoLabel = ".fi-label";
const String _filmInfoDescription = ".fi-desc";
const String _filmDescription = "div[itemprop=\"description\"]";

const String _titlesSelector = ".main-section-inner > .msi-title > .sidebar-title";
const String _movieItemSelector = ".movie-item";

const String _paginationSelector = ".pagi-nav .navigation";

const String _skipPath = "top.html";

class MediaDataParser {
  static bool isSeries({required Document document}) {
    return document.querySelector(".movie-right .film-top-info") != null;
  }

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
    var link = posterNode?.attributes["href"];
    if (link != null) {
      if (link.contains("http")) {
        return link;
      }
      return "https://uakino.club$link";
    }
    return null;
  }

  static Map<MediaInfoKey, String> parseMediaInfo({required Document document}) {
    var map = <MediaInfoKey, String>{};
    List<Element> infoListNodes;
    if (isSeries(document: document)) {
      infoListNodes = document.querySelectorAll(_seriesInfoSelector);
    } else {
      infoListNodes = document.querySelectorAll(_filmInfoSelector);
    }

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
          case "Озвучення:":
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

  static Iterable<MenuItem> parseMenu(Document document) {
    var menuItems = <MenuItem>[];
    document.querySelectorAll("nav .main-menu > li").forEach((Element el) {
      var link = el.querySelector("a");

      assert(link != null, "Menu item should have link");

      if (link!.classes.contains("nolink-menu")) {
        return;
      }

      var item = MenuItem(title: link.text.trim());
      item.path = link.attributes["href"];

      // TODO: Implement in future
      if (item.path != null &&
          (item.path!.contains("anonsi") ||
              item.path!.contains("colections") ||
              item.path!.contains("top"))) {
        return;
      }

      el.querySelectorAll(".hidden-menu ul li a").forEach((element) {
        var subMenuPath = element.attributes["href"];

        assert(subMenuPath != null, "Submenu item should have path");

        if (subMenuPath!.contains(_skipPath)) {
          return;
        }
        item.submenus.add(SubmenuItem(title: element.text.trim(), path: subMenuPath));
      });

      menuItems.add(item);
    });

    return menuItems;
  }

  static List<MediaCarousel> parseHomePageData(Document document) {
    var titleNodes = document.querySelectorAll(_titlesSelector);

    return titleNodes.map((e) => _buildCarouselData(e)).toList(growable: false);
  }

  static MediaCarousel _buildCarouselData(Element titleElement) {
    var title = titleElement.text;

    var movieElements = titleElement.parent!.parent!.querySelectorAll(_movieItemSelector);
    var movies = movieElements.map(MediaPreviewItem.fromHTML).toList(growable: false);

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
  }

  static Map<Source, Voice> parseAjaxPlaylist({required Document document}) {
    var list = document.querySelectorAll("li[data-file]");
    var map = <String, String>{};

    for (var element in list) {
      var voice = element.attributes["data-voice"];
      var src = element.attributes["data-file"];

      if (voice != null && src != null) {
        var link = element.attributes["data-file"]!;
        if (!link.contains("http")) {
          link = "https:$link";
        }
        map[link] = "$voice|${element.text}";
      }
    }
    return map;
  }

  static String? parseFilmSource(Document document) {
    var iframes = document.getElementsByTagName("iframe");

    var src =
        iframes.firstWhereOrNull((element) => element.attributes["src"] != null)?.attributes["src"];

    if (src == null) {
      logger.e("No media source");
      return null;
    }

    return src;
  }

  static GridResponse parseGridData(String response) {
    try {
      var jsonData = json.decode(response);
      var document = parse(jsonData["content"]);
      var movieElements = document.querySelectorAll(_movieItemSelector);

      var movies = movieElements.map(MediaPreviewItem.fromHTML).toList(growable: false);

      var total = document
          .querySelector(_paginationSelector)
          ?.children
          .lastOrDefault(defaultValue: null)
          ?.text
          .trim();

      var pages = total != null ? int.parse(total) : 1;

      return GridResponse(movies, pages);
    } catch (e) {
      loggerRaw.e("Error while parse resources", e);
      return GridResponse([], 0);
    }
  }

  static GridResponse parseSearchData(String response) {
    var document = parse(response);

    var movieElements = document.querySelectorAll(_movieItemSelector);

    var movies = movieElements.map(MediaPreviewItem.fromHTML).toList(growable: false);

    var total = document
        .querySelector(_paginationSelector)
        ?.children
        .lastOrDefault(defaultValue: null)
        ?.text
        .trim();

    var pages = total != null ? int.parse(total) : 1;

    return GridResponse(movies, pages);
  }
}
