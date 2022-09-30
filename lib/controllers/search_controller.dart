import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class SearchController extends GetxController with StateMixin<List<MediaPreviewItem>> {
  final ScrollController scrollController = ScrollController();
  final UaKinoService _service = Get.find();
  int totalPages = 1;

  final _page = 1.obs;
  final _search = "".obs;

  @override
  void onInit() {
    // change(null, status: RxStatus.success());
    super.onInit();
    _search.listen((value) {
      change(null, status: RxStatus.loading());
      _doSearch(value, _page.value);
    });

    _page.listen((page) {
      change(null, status: RxStatus.loading());
      _doSearch(_search.value, page);
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _doSearch(String search, int page) async {
    try {
      var response = await _service.search(search, page);
      totalPages = response.totalPages;
      if (response.mediaItems.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }
      change(response.mediaItems, status: RxStatus.success());
    } catch (e) {
      // TODO handle error
      loggerRaw.e("Error... Search $search", e);
      change(null, status: RxStatus.error("Something went wrong during the search"));
    }
  }
}
