import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/meda_grid_controller.dart';
import 'package:uakino/views/media_item_view/media_item_view.dart';
import 'package:uakino/views/oops_view/oops_view.dart';

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
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
                child: GridView.count(
                  crossAxisCount: 5,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: state
                          ?.map((mediaItem) => MediaItemView(mediaItem: mediaItem))
                          .toList(growable: false) ??
                      [],
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
