import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/notifications/focus_notification.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/sidebar_view/sidebar_item_view.dart';

class SidebarView extends GetView<AppState> {
  const SidebarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FocusNotification>(
      onNotification: (notification) {
        logger.d("notification ${notification.childKey}");
        return true;
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: K.sidebarWidth,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Image(image: AssetImage('assets/img/logo.png')),
              ),
              Expanded(
                child: FocusScope(
                  onKey: (node, event) {
                    if (isChangeScopeToMedia(event)) {
                      // Focus media items scope
                      node.parent?.children.last.requestFocus();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Obx(
                    () => ListView.builder(
                        padding: const EdgeInsets.only(top: 32.0),
                        itemCount: controller.menuItems.length,
                        itemBuilder: (context, index) {
                          return SidebarItemView(
                            key: Key(controller.menuItems[index].title),
                            menuItem: controller.menuItems[index],
                            autofocus: controller.menuItems[index] == controller.menuItems.first,
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
