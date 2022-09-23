import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/media_resource_controller.dart';
import 'package:uakino/oops_page.dart';

class MediaPage extends GetWidget<MediaResourceController> {
  const MediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.mediaPreviewItem == null) {
      return const OopsPage();
    }
    final item = controller.mediaPreviewItem!;

    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.mediaItem.value?.title ?? "...")),
      // ),
      // body: Obx(() => MediaContentView()),
      body: Center(
        child: Column(
          children: [
            const Text("Hello from second"),
            Text(item.title),
          ],
        ),
      ),
    );
  }
}
