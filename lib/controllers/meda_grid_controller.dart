import 'package:get/get.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaGridController extends GetxController with StateMixin<MediaPreviewItem> {
  final UaKinoService _service = Get.find();
  late final String? _path;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
    _path = Get.parameters["path"];
  }
}
