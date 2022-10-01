import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uakino/dto/filters.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class MediaGridController extends GetxController with StateMixin<List<MediaPreviewItem>> {
  final ScrollController scrollController = ScrollController();
  final UaKinoService _service = Get.find();
  late final String? _path;
  int _totalPages = 1;

  final _page = 1.obs;
  final _filters = Filters().obs;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    _path = Get.parameters["path"];
    if (_path != null) {
      _initData();
      scrollController.addListener(_scrollListener);

      _page.listen((page) {
        _filters.value = _filters.value.copyWith(page: page);
        _fetchMoreData();
      });
    } else {
      change(null, status: RxStatus.error("Path is empty"));
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  void updateFilters(Filters filters) {
    _page.value = 1;
    _filters.value = filters;
  }

  void _initData() {
    _service.getGridData(_path!, _filters.value).then((response) {
      _totalPages = response.totalPages;
      if (response.mediaItems.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }
      change(response.mediaItems, status: RxStatus.success());
    }).catchError((error) {
      change(null, status: RxStatus.error("Something went wrong during load media"));
    });
  }

  void _fetchMoreData() {
    _service.getGridData(_path!, _filters.value).then((response) {
      var newState = List<MediaPreviewItem>.from(state!)..addAll(response.mediaItems);
      change(newState);
    }).catchError((error) {
      // TODO Handle Error
    });
  }

  void _scrollListener() {
    final shouldLoadMore =
        scrollController.position.maxScrollExtent - 253 < scrollController.offset;
    final canLoadMore = _page < _totalPages;
    if (shouldLoadMore && canLoadMore) {
      logger.i("Load more films");
      _page.value++;
    }
  }
}
