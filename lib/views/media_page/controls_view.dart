import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/media_resource_controller.dart';
import 'package:uakino/logger/logger.dart';

class ControlsView extends StatelessWidget {
  final MediaResourceController controller;

  const ControlsView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Buttons
      child: SizedBox(
        width: double.infinity,
        child: Obx(() => Wrap(
              spacing: 20,
              children: _buildButtons(),
            )),
      ),
    );
  }

  List<Widget> _buildButtons() {
    var buttons = <Widget>[];
    if (controller.resources == null) {
      buttons.add(const CircularProgressIndicator());
    }

    if (controller.resources?.source != null) {
      final source = controller.resources!.source!;

      buttons.add(
        TextButton(
          onPressed: () {
            if (source.isNotEmpty) {
              final intent = AndroidIntent(
                  type: "video/*",
                  action: 'action_view',
                  data: Uri.parse(source).toString(),
                  arguments: <String, dynamic>{
                    "title": controller.state?.title,
                    // "position": Duration(minutes: 35).inMilliseconds,
                  });
              intent.launch();
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: Wrap(
            spacing: 4.0,
            children: [
              const Icon(Icons.ondemand_video, size: 18.0),
              Text("watch".tr),
            ],
          ),
        ),
      );
    }

    controller.resources?.playlists?.keys.forEach((voice) {
      buttons.add(
        TextButton(
          onPressed: () {
            controller.setActivePlaylist(voice);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: Wrap(
            spacing: 4.0,
            children: [
              const Icon(Icons.video_collection_outlined, size: 18.0),
              Text(voice),
            ],
          ),
        ),
      );
    });

    buttons.add(
      TextButton(
        onPressed: () {
          logger.e("Implement");
        },
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: Wrap(
          spacing: 4.0,
          children: [
            const Icon(Icons.bookmark_add_outlined, size: 18.0),
            Text("to-bookmark".tr),
          ],
        ),
      ),
    );

    return buttons;
  }
}
