import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/parsers/parse_media_data.dart';
import 'package:uakino/services/ua_kino_service.dart';

/// Global App UI state
class AppState extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final UaKinoService _service = Get.find();

  final _menuItems = <MenuItem>[].obs;
  final _isConnected = false.obs;
  final _isCheckConnect = true.obs;
  final _isLoading = true.obs;

  RxList<MenuItem> get menuItems => _menuItems;

  bool get isConnected => _isConnected.value;

  RxBool get $isConnected => _isConnected;

  bool get isCheckConnect => _isCheckConnect.value;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }

  void updateMenuItems(Iterable<MenuItem> newMenuItems) {
    menuItems.clear();
    menuItems.addAll(newMenuItems);
    _isLoading.value = false;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      logger.e("Couldn't check connectivity status: ${e.message}", e);
      return;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    var isConnected = result == ConnectivityResult.wifi;
    _isCheckConnect.value = false;
    _isConnected.value = isConnected;
    if (isConnected) {
      var document = await _service.getHomepageData();
      var menuItems = await compute(MediaDataParser.parseMenu, document);
      updateMenuItems(menuItems);
      var carousels = await compute(MediaDataParser.parseHomePageData, document);
      final LibraryController c = Get.find();
      c.updateCarousels(carousels);
    }
  }
}
