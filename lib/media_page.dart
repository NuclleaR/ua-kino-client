import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/media_resource_controller.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/views/media_page/layout.dart';
import 'package:uakino/views/media_page/title_view.dart';
import 'package:uakino/views/oops_view/oops_view.dart';

class MediaPage extends GetWidget<MediaResourceController> {
  const MediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: controller.obx(
          (state) {
            final MediaItem item = state!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleView(title: item.title),
                MediaInfoLayout(item: item),
              ],
            );
          },
          onError: (error) => OopsView(
            message: error,
          ),
        ),
      ),
    );
  }
}
