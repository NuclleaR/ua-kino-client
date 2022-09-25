import 'package:html/dom.dart';
import 'package:uakino/ext/map_ext.dart';
import 'package:uakino/models/media/media_info_key.dart';
import 'package:uakino/parsers/parse_media_data.dart';

class MediaItem {
  // TODO for future history
  //final String ID;
  final String title;
  final String poster;
  final String url;
  final MediaItemInfo mediaInfo;
  late String? source;
  late final Map<String, List<String>>? playlists;

  MediaItem(this.title, this.poster, this.mediaInfo, {this.playlists, this.source, this.url = ""});

  @override
  String toString() {
    return 'MediaItem{title: $title, poster: $poster, url: $url, mediaInfo: $mediaInfo, source: $source, playlists: $playlists}';
  }
}

class MediaItemInfo {
  final String quality;
  final String year;
  final String genres;
  final String country;
  final String producer;
  final String actors;
  final String duration;
  final String lang;
  final String imdbScore;
  final String description;

  MediaItemInfo(this.quality, this.year, this.genres, this.producer, this.actors, this.duration,
      this.lang, this.imdbScore, this.country, this.description);

  static MediaItemInfo fromHTML(Document document) {
    Map<MediaInfoKey, String> filmInfo = MediaDataParser.parseFilmInfo(document: document);

    return MediaItemInfo(
        filmInfo.getString(MediaInfoKey.quality),
        filmInfo.getString(MediaInfoKey.year),
        filmInfo.getString(MediaInfoKey.genres),
        filmInfo.getString(MediaInfoKey.producer),
        filmInfo.getString(MediaInfoKey.actors),
        filmInfo.getString(MediaInfoKey.duration),
        filmInfo.getString(MediaInfoKey.lang),
        filmInfo.getString(MediaInfoKey.imdbScore),
        filmInfo.getString(MediaInfoKey.country),
        filmInfo.getString(MediaInfoKey.description));
  }
}
