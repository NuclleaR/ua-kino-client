import 'package:uakino/models/media/media_item.dart';

class MediaItemResource {
  late final String? source;
  late final Map<Voice, Map<String, Source>>? playlists;

  MediaItemResource({this.source, this.playlists});
}
