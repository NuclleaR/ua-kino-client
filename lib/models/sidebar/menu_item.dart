import 'package:uakino/models/sidebar/submenu_item.dart';

class MenuItem {
  final String title;
  final String? localeTitle;
  String? path;
  List<SubmenuItem> submenus = <SubmenuItem>[];

  MenuItem({this.title = "", this.localeTitle});

  @override
  String toString() {
    return "MenuItem: $title";
  }
}
