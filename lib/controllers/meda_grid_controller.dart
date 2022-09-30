import 'package:get/get.dart';
import 'package:uakino/dto/filters.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaGridController extends GetxController with StateMixin<List<MediaPreviewItem>> {
  final UaKinoService _service = Get.find();
  late final String? _path;

  // final _grid = <MediaPreviewItem>[].obs;
  final _page = 1.obs;
  final _totalPages = 1.obs;
  final _filters = Filters().obs;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    _path = Get.parameters["path"];
    if (_path != null) {
      _service.getGridData(_path!, _filters.value).then((response) {
        if (response.mediaItems.isEmpty) {
          change([], status: RxStatus.empty());
          _totalPages.value = response.totalPages;
          return;
        }
        change(response.mediaItems, status: RxStatus.success());
      }).catchError((error) {
        change(null, status: RxStatus.error("Something went wrong while loading media"));
      });

      _page.listen((page) {
        _filters.value = _filters.value.copyWith(page: page);
      });
    } else {
      change(null, status: RxStatus.error("Path is empty"));
    }
  }

  void updateFilters(Filters filters) {
    _page.value = 1;
    _filters.value = filters;
  }
}
