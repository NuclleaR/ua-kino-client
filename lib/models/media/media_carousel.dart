import 'package:uakino/models/media/media_preview_item.dart';

class MediaCarousel {
  final String title;
  String? actionPath;
  final List<MediaPreviewItem> mediaItems;

  MediaCarousel(this.title, this.mediaItems, {this.actionPath});
}
