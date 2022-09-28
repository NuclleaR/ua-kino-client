import 'package:html/dom.dart';
import 'package:uakino/constants.dart';

const String _movieTitleSelector = ".movie-title";
const String _seasonSelector = ".full-season";

class MediaPreviewItem {
  final String image;
  final String title;
  final String url;
  final String? seasonDescription;

  MediaPreviewItem(
      {required this.image, required this.title, required this.url, this.seasonDescription});

  @override
  String toString() {
    return "MediaPreviewItem: $title";
  }

  factory MediaPreviewItem.fromHTML(Element movieElement) {
    var a = movieElement.querySelector(_movieTitleSelector);
    return MediaPreviewItem(
        image: host + (movieElement.querySelector("img")?.attributes["src"] ?? ""),
        title: a?.text.trim() ?? "[EMPTY]",
        url: a?.attributes["href"] ?? "",
        seasonDescription: movieElement.querySelector(_seasonSelector)?.text.trim());
  }
}
