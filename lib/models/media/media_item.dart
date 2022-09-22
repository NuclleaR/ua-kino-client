class MediaItem {
  // TODO for future history
  //final String ID;
  final String title;
  final String poster;
  final String url;
  final Map<String, List<String>>? playlists;
  final Map<String, String> mediaInfo;

  MediaItem(this.title, this.poster, this.mediaInfo, {this.playlists, this.url = ""});
}
