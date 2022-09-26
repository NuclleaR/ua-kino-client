import 'package:get/get.dart';
import 'package:uakino/models/media/media_carousel.dart';
import 'package:uakino/models/media/media_preview_item.dart';

/// This is controller to manage library resources
class LibraryController extends GetxController {
  final _carousels = <MediaCarousel>[].obs;
  final _grid = <MediaPreviewItem>[].obs;

  RxList<MediaCarousel> get carousels => _carousels;

  RxList<MediaPreviewItem> get grid => _grid;

  void updateCarousels(Iterable<MediaCarousel> newCarousels) {
    _carousels.clear();
    _carousels.addAll(newCarousels);
  }

  void setGridData(Iterable<MediaPreviewItem> newGrid) {
    _grid.clear();
    _grid.addAll(newGrid);
  }
}
