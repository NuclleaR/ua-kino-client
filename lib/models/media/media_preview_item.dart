import 'package:html/dom.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/logger/logger.dart';

const String _movieTitleSelector = ".movie-title";
const String _seasonSelector = ".full-season";

class MediaPreviewItem {
  final String title;
  final String url;
  final String? image;
  final String? seasonDescription;

  MediaPreviewItem({this.image, required this.title, required this.url, this.seasonDescription});

  @override
  String toString() {
    return "MediaPreviewItem: $title";
  }

  factory MediaPreviewItem.fromHTML(Element movieElement) {
    var a = movieElement.querySelector(_movieTitleSelector);
    var src = movieElement.querySelector("img")?.attributes["src"];
    logger.d(src);
    if (src != null && !src.contains("http")) {
      src = host + src;
    }
    return MediaPreviewItem(
        image: src, //host + (movieElement.querySelector("img")?.attributes["src"] ?? ""),
        title: a?.text.trim() ?? "[EMPTY]",
        url: a?.attributes["href"] ?? "",
        seasonDescription: movieElement.querySelector(_seasonSelector)?.text.trim());
  }
}
