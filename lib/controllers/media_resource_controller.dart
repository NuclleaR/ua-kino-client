import 'package:get/get.dart';
import 'package:uakino/ext/map_ext.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/models/media/media_item_resource.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaResourceController extends GetxController with StateMixin<MediaItem> {
  final UaKinoService _service = Get.find();
  late final MediaPreviewItem? mediaPreviewItem;

  final _resources = Rxn<MediaItemResource>();
  final _playlist = Rxn<Map<String, Source>>();

  MediaItemResource? get resources => _resources.value;

  Map<String, Source>? get playlist => _playlist.value;

  // List<Source> get resources => _resources.value;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    mediaPreviewItem = Get.arguments is MediaPreviewItem ? Get.arguments : null;
    if (mediaPreviewItem == null) {
      change(null, status: RxStatus.error("Media Preview Item can't be null"));
    }

    if (mediaPreviewItem != null) {
      _service.getMediaData(mediaPreviewItem!.url).then((value) {
        change(value, status: RxStatus.success());
        return _service.getMediaSource(value);
      }).then((value) {
        _resources.value = value;
      }).catchError((e) {
        loggerRaw.e(e, e, (e as Error).stackTrace);
        change(value, status: RxStatus.error(e.toString()));
      });
    }
  }

  void setActivePlaylist(Voice voice) {
    _playlist.value = _resources.value?.playlists?.get(voice);
  }
}
