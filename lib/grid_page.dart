import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/meda_grid_controller.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/media_item_view/media_item_view.dart';
import 'package:uakino/views/oops_view/oops_view.dart';

const _aspectRatio = 140 / 207;

class GridPage extends GetWidget<MediaGridController> {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) {
          return Column(
            children: [
              Row(
                children: const [
                  Text("Toolbar with filters"),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: SizedBox(
                  width: 786,
                  child: GridView.count(
                    childAspectRatio: _aspectRatio,
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 4,
                    clipBehavior: Clip.none,
                    controller: controller.scrollController,
                    children: state
                            ?.map((mediaItem) => MediaItemView(
                                  mediaItem: mediaItem,
                                  onKey: (node, event) {
                                    if (isSelect(event)) {
                                      logger.i("Select $mediaItem");
                                      Get.toNamed(mediaItemRoute, arguments: mediaItem);
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                ))
                            .toList(growable: false) ??
                        [],
                  ),
                ),
              )),
            ],
          );
        },
        onEmpty: const Center(
          child: Text("Empty"),
        ),
        onError: (error) => OopsView(message: error),
      ),
    );
  }
}
