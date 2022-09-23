import 'package:get/get.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/services/ua_kino_service.dart';

class ScaffoldGetx {
  static init() {
    // Get.lazyPut(() => UaKinoService());

    // var mediaCtrl = Get.put(MediaController());
    // Get.put(ActiveMediaItemController());
    // mediaCtrl.getHomePageData();
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppState());
    Get.put(LibraryController());
    Get.put(UaKinoService());
  }
}
