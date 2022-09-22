import 'package:get/get.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/services/ua_kino_service.dart';

class ScaffoldGetx {
  static init() {
    Get.put(AppState());
    Get.put(LibraryController());

    var uaKnoService = Get.put(UaKinoService());
    // Get.lazyPut(() => UaKinoService());

    uaKnoService.getHomepageData();

    // var mediaCtrl = Get.put(MediaController());
    // Get.put(ActiveMediaItemController());
    // mediaCtrl.getHomePageData();
  }
}
