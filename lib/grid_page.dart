import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/meda_grid_controller.dart';

class GridPage extends GetWidget<MediaGridController> {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: controller.obx((state) {
      return Column(
        children: [
          const Text("Hello Grid"),
          Text(Get.parameters["path"] ?? "WTF?"),
        ],
      );
    }));
  }
}
