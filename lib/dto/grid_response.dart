import 'package:uakino/models/media/media_preview_item.dart';

class GridResponse {
  final List<MediaPreviewItem> mediaItems;
  final int totalPages;

  GridResponse(this.mediaItems, this.totalPages);

  @override
  String toString() {
    return 'GridResponse{mediaItems count: ${mediaItems.length}, totalPages: $totalPages}';
  }
}
