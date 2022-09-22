import 'package:get/get.dart';
import 'package:uakino/models/sidebar/menu_item.dart';

/// Global App UI state
class AppState extends GetxService {
  var menuItems = <MenuItem>[].obs;

  void updateMenuItems(Iterable<MenuItem> newMenuItems) {
    menuItems.clear();
    menuItems.addAll(newMenuItems);
  }
}
