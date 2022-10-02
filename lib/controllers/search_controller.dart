import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/services/ua_kino_service.dart';

class SearchController extends GetxController with StateMixin<List<MediaPreviewItem>> {
  final ScrollController scrollController = ScrollController();
  final searchNode = FocusNode();

  final UaKinoService _service = Get.find();
  Timer? _timer;
  int _totalPages = 1;

  final _page = 1.obs;
  final _search = "".obs;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());

    scrollController.addListener(_scrollListener);

    _search.listen((value) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        change(null, status: RxStatus.loading());
        _doSearch(value, _page.value);
      });
    });

    _page.listen((page) {
      _doSearch(_search.value, page);
    });

    searchNode.onKey = (focusNode, event) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        focusNode.nextFocus();
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    searchNode.dispose();
    _timer?.cancel();
  }

  Future<void> _doSearch(String search, int page) async {
    try {
      var response = await _service.search(search, page);
      _totalPages = response.totalPages;
      if (page > 1 && state != null) {
        var newState = List<MediaPreviewItem>.from(state!)..addAll(response.mediaItems);
        change(newState);
      } else {
        logger.w(response);
        if (response.mediaItems.isEmpty) {
          change([], status: RxStatus.empty());
          return;
        }
        change(response.mediaItems, status: RxStatus.success());
      }
    } catch (e) {
      // TODO handle error
      loggerRaw.e("Error... Search $search", e);
      change(null, status: RxStatus.error("Something went wrong during the search"));
    }
  }

  void onSearchChange(String search) {
    _search(search);
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
