import 'package:get/get.dart';
import 'package:uakino/models/media/media_carousel.dart';

/// This is controller to manage library resources
class LibraryController extends GetxController {
  var carousels = <MediaCarousel>[].obs;

  void updateCarousels(Iterable<MediaCarousel> newCarousels) {
    carousels.clear();
    carousels.addAll(newCarousels);
  }
}
