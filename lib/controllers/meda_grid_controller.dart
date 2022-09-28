import 'package:get/get.dart';
import 'package:uakino/dto/filters.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaGridController extends GetxController with StateMixin<MediaPreviewItem> {
  final UaKinoService _service = Get.find();
  late final String? _path;

  final _grid = <MediaPreviewItem>[].obs;
  final _page = 1.obs;
  final _totalPages = 1.obs;
  final _filters = Filters().obs;

  RxList<MediaPreviewItem> get grid => _grid;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
    _path = Get.parameters["path"];
    if (_path != null) {
      _service.getGridData(_path!, _filters.value).then((response) {
        _grid.clear();
        _grid.value = response.mediaItems;
        _totalPages.value = response.totalPages;
      });

      _page.listen((page) {
        _filters.value = _filters.value.copyWith(page: page);
      });
    }
  }

  void updateFilters(Filters filters) {
    _page.value = 1;
    _filters.value = filters;
  }
}
