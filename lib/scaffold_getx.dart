import 'package:get/get.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/controllers/meda_grid_controller.dart';
import 'package:uakino/controllers/media_resource_controller.dart';
import 'package:uakino/controllers/search_controller.dart';
import 'package:uakino/services/ua_kino_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UaKinoService());

    Get.put(AppState());
    Get.put(LibraryController());
  }
}

class MediaResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => MediaResourceController());
  }
}

class MediaGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => MediaGridController());
  }
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => SearchController());
  }
}
