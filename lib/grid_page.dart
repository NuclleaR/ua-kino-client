import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/meda_grid_controller.dart';
import 'package:uakino/views/oops_view/oops_view.dart';

import 'views/media_grid/media_grid.dart';

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
                  width: gridWidth,
                  child: MediaGrid(
                    controller: controller.scrollController,
                    list: state,
                    clipBehavior: Clip.none,
                  ),
                ),
              )),
            ],
          );
        },
        onEmpty: Center(
          child: Text("no-result".tr),
        ),
        onError: (error) => OopsView(message: error),
      ),
    );
  }
}
