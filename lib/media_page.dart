import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/models/media/media_preview_item.dart';

class MediaPage extends StatelessWidget {
  final MediaPreviewItem? _mediaPreviewItem;

  MediaPage({Key? key})
      : _mediaPreviewItem = (Get.arguments is MediaPreviewItem) ? Get.arguments : null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.mediaItem.value?.title ?? "...")),
      // ),
      // body: Obx(() => MediaContentView()),
      body: Center(
        child: Column(
          children: [
            const Text("Hello from second"),
            Text(_mediaPreviewItem?.title ?? "WTF?"),
          ],
        ),
      ),
    );
  }
}
