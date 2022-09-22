import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/views/media_carousel/media_carousel_view.dart';

class MainContentView extends GetView<LibraryController> {
  const MainContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade700,
      width: MediaQuery.of(context).size.width - K.sidebarWidth,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: const [Text("Hello")],
            ),
            FocusScope(
              // onKey: (node, event) {
              //   if (isChangeScopeToMenu(event)) {
              //     print(node.children.length);
              //     // Focus media items scope
              //     // node.parent?.children.last.nextFocus();
              //     // return KeyEventResult.handled;
              //   }
              //   return KeyEventResult.ignored;
              // },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Obx(() => Column(
                      children: controller.carousels
                          .map((element) => MediaCarouselView(data: element))
                          .toList(growable: false),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
