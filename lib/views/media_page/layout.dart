import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/media_resource_controller.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/views/media_page/controls_view.dart';
import 'package:uakino/views/media_page/media_info.dart';
import 'package:uakino/views/media_page/poster_view.dart';

class MediaInfoLayout extends StatelessWidget {
  final MediaResourceController controller;

  const MediaInfoLayout({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaItem item = controller.state!;

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PosterView(src: item.poster),
          Expanded(
            child: Column(
              children: [
                ControlsView(controller),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRect(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Obx(
                              () => SizedBox(
                                height: controller.playlist != null ? 84 : 0,
                                child: _buildList(),
                              ),
                            ),
                          ),
                        ),
                        MediaInfoView(item: item),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget? _buildList() {
    if (controller.playlist == null) {
      return null;
    }

    var entries = controller.playlist!.entries;

    return ListView.builder(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        var source = entries.elementAt(index);

        return TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              if (source.key.isNotEmpty) {
                final intent = AndroidIntent(
                    type: "video/*",
                    action: 'action_view',
                    data: Uri.parse(source.value).toString(),
                    arguments: <String, dynamic>{
                      "title": "${controller.state?.title} - ${source.key}",
                      // "position": Duration(minutes: 35).inMilliseconds,
                    });
                intent.launch();
              }
            },
            child: Column(
              children: [
                const Icon(Icons.ondemand_video, size: 48.0),
                Text(source.key),
              ],
            ));
      },
    );
  }
}
