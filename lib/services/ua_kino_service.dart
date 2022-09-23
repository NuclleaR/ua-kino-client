import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_carousel.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/models/sidebar/submenu_item.dart';

const _host = "https://uakino.club";
const _titlesSelector = ".main-section-inner > .msi-title > .sidebar-title";
const _movieTitleSelector = ".movie-title";
const _movieItemSelector = ".movie-item";
const _seasonSelector = ".full-season";

class UaKinoService extends GetxService {
  final AppState _state = Get.find();
  final LibraryController _c = Get.find();

  @override
  void onInit() {
    super.onInit();
    getHomepageData();
  }

  Future<void> getHomepageData() async {
    var response = await http.get(_getUrl());

    // TODO implement parsing n a separate thread
    // var res = await compute(parse, response.body)
    var document = parse(response.body);

    logger.i("Home page data loaded");

    var menuItems = _parseMenu(document: document);
    _state.updateMenuItems(menuItems);
    var carousels = _parseHomePageData(document: document);
    _c.updateCarousels(carousels);
  }

  Iterable<MenuItem> _parseMenu({required Document document}) {
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

  List<MediaCarousel> _parseHomePageData({required Document document}) {
    var titleNodes = document.querySelectorAll(_titlesSelector);

    return titleNodes.map((e) => _buildCarouselData(e)).toList(growable: false);
  }

  MediaCarousel _buildCarouselData(Element titleElement) {
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

  Uri _getUrl({String path = "/", Map<String, dynamic>? queryParameters}) {
    return Uri.https("uakino.club", path, queryParameters);
  }
}
