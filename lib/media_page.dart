import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/views/media_content_view/media_content_view.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.mediaItem.value?.title ?? "...")),
      // ),
      body: Obx(() => MediaContentView()),
    );
  }
}
