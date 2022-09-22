import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/models/sidebar/submenu_item.dart';

class MediaController extends GetxController {
  final host = "https://uakino.club";

  var categories = <MenuItem>[].obs;
  var mainTitle = "".obs;
  var mainCarousel = <MediaPreviewItem>[].obs;

  getHomePageData() async {
    var url = Uri.https("uakino.club");
    categories.clear();

    var response = await http.get(url);

    var document = parse(response.body);

    _parseMenu(document: document);

    _parseHomePageData(document: document);
  }

  _parseMenu({required Document document}) {
    document.querySelectorAll("nav .main-menu > li").forEach((Element el) {
      var link = el.querySelector("a");
      var item = MenuItem(title: link?.text.trim() ?? "[DEBUG ME]");
      item.path = link?.attributes["href"];

      el.querySelectorAll(".hidden-menu ul li a").forEach((element) {
        item.submenus.add(SubmenuItem(
            title: element.text.trim(), path: element.attributes["href"] ?? "[DEBUG ME]"));
      });
      categories.add(item);
    });
  }

  _parseHomePageData({required Document document}) {
    mainTitle.value = document.querySelector(".msi-title")?.text ?? "";

    mainCarousel.clear();
    var movieNodes = document.querySelectorAll(".msi-content .movie-item");

    for (var element in movieNodes) {
      var a = element.querySelector(".movie-title");
      mainCarousel.add(MediaPreviewItem(
          image: host + (element.querySelector("img")?.attributes["src"] ?? ""),
          title: a?.text.trim() ?? "[EMPTY]",
          url: a?.attributes["href"] ?? "",
          seasonDescription: element.querySelector(".full-season")?.text));
    }
  }
}
