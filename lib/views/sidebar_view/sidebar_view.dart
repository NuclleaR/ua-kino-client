import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/sidebar_view/sidebar_item_view.dart';

class SidebarView extends GetView<AppState> {
  const SidebarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: K.sidebarWidth,
      color: Colors.blueGrey.shade900,
      child: FocusScope(
        onKey: (node, event) {
          if (isChangeScopeToMedia(event)) {
            // Focus media items scope
            node.parent?.children.last.requestFocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 0, 0),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(searchRoute);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) =>
                      states.contains(MaterialState.focused) ? Colors.deepOrange : Colors.white),
                  overlayColor: const MaterialStatePropertyAll<Color?>(Colors.transparent),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    Text("Search"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                    padding: const EdgeInsets.only(top: 16.0),
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
          ],
        ),
      ),
    );
  }
}
