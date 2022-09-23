import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/sidebar/submenu_item.dart';
import 'package:uakino/utils/keyboard.dart';

class SidebarSubItemView extends StatefulWidget {
  final SubmenuItem submenuItem;

  const SidebarSubItemView({Key? key, required this.submenuItem}) : super(key: key);

  @override
  State<SidebarSubItemView> createState() => _SidebarSubItemViewState();
}

class _SidebarSubItemViewState extends State<SidebarSubItemView> {
  var _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: _handleKey,
      onFocusChange: _setFocused,
      child: Container(
        width: K.sidebarWidth,
        padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
        child: Text(
          widget.submenuItem.title,
          style: TextStyle(
              color: _isFocused ? Colors.orange.shade800 : Colors.white,
              fontSize: _isFocused ? 18.0 : 16.0),
        ),
      ),
    );
  }

  void _setFocused(bool value) {
    setState(() {
      _isFocused = value;
    });
  }

  KeyEventResult _handleKey(FocusNode node, RawKeyEvent event) {
    if (isSelect(event)) {
      logger.w("Go to ${widget.submenuItem.path}");
      Get.toNamed(gridRoute, parameters: {"path": widget.submenuItem.path});
    }
    return KeyEventResult.ignored;
  }
}
