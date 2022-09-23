import 'package:get/get.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_preview_item.dart';

class MediaResourceController extends GetxController {
  late final MediaPreviewItem? mediaPreviewItem;

  @override
  void onInit() {
    super.onInit();
    logger.i("MediaResourceController onInit");
    mediaPreviewItem = Get.arguments is MediaPreviewItem ? Get.arguments : null;
  }

  @override
  void onClose() {
    super.onClose();
    logger.i("MediaResourceController onClose");
  }

  @override
  void onReady() {
    super.onReady();
    logger.i("MediaResourceController onReady");
  }
}
