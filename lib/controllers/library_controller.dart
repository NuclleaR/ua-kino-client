import 'package:get/get.dart';
import 'package:uakino/models/media/media_carousel.dart';

/// This is controller to manage library resources
class LibraryController extends GetxController {
  final _carousels = <MediaCarousel>[].obs;

  RxList<MediaCarousel> get carousels => _carousels;

  void updateCarousels(Iterable<MediaCarousel> newCarousels) {
    _carousels.clear();
    _carousels.addAll(newCarousels);
  }
}
