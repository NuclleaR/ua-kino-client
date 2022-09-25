import 'package:get/get.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaResourceController extends GetxController with StateMixin<MediaItem> {
  final UaKinoService _service = Get.find();
  late final MediaPreviewItem? mediaPreviewItem;

  @override
  void onInit() {
    super.onInit();
    logger.i("MediaResourceController onInit");
    change(null, status: RxStatus.loading());
    mediaPreviewItem = Get.arguments is MediaPreviewItem ? Get.arguments : null;
    if (mediaPreviewItem == null) {
      change(null, status: RxStatus.error("Media Preview Item can't be null"));
    }

    if (mediaPreviewItem != null) {
      _service.getMediaData(mediaPreviewItem!.url).then((value) {
        change(value, status: RxStatus.success());
      }).catchError((e) {
        change(value, status: RxStatus.error(e.toString()));
      });
    }
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
