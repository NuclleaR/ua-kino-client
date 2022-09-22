import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/active_media_item_controller.dart';

class MediaContentView extends GetView<ActiveMediaItemController> {
  MediaContentView({Key? key}) : super(key: key) {
    controller.getMediaData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.mediaItem.value != null) {
        var item = controller.mediaItem.value!;

        // TODO Create MediaInfoView
        final children = item.mediaInfo.entries
            .select((element, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(element.key),
                      ),
                      Flexible(child: Text(element.value))
                    ],
                  ),
                ))
            .toList(growable: false);

        return Row(
          children: [
            Image.network(item.poster),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    child: Text(item.title),
                  ),
                  //---> Media info
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                  if (controller.activeMediaSrc.value != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            final intent = AndroidIntent(
                              type: "video/*",
                              action: 'action_view',
                              data: Uri.parse(controller.activeMediaSrc.value!).toString(),
                            );
                            intent.launch();
                          }
                        },
                        child: const Text('Watch'),
                      ),
                    ),
                  // TODO render playlist
                ],
              ),
            )
          ],
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
