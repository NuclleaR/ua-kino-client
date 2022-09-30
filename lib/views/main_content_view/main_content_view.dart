import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/controllers/library_controller.dart';
import 'package:uakino/views/media_carousel/media_carousel_view.dart';

class MainContentView extends GetView<LibraryController> {
  final PageController pageController = PageController(viewportFraction: 0.7);
  final AppState appState = Get.find();

  MainContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: const [Spacer(), Image(image: AssetImage('assets/img/logo.png'))],
              ),
            ),
            Expanded(
              child: FocusScope(
                child: Obx(() => PageView(
                      controller: pageController,
                      scrollDirection: Axis.vertical,
                      clipBehavior: Clip.none,
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
