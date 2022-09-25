import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_item.dart';

class ControlsView extends StatelessWidget {
  final MediaItem item;

  const ControlsView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Buttons
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 20,
          children: [
            TextButton(
                onPressed: () {
                  if (item.source != null && item.source!.isNotEmpty) {
                    final intent = AndroidIntent(
                        type: "video/*",
                        action: 'action_view',
                        data: Uri.parse(item.source!).toString(),
                        arguments: <String, dynamic>{
                          "android.intent.extra.title": item.title,
                          "android.intent.extra.from_start": true,
                          "android.intent.extra.position": 0,
                        });
                    intent.launch();
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Wrap(
                  spacing: 4.0,
                  children: const [
                    Icon(Icons.ondemand_video, size: 18.0),
                    Text("Watch"),
                  ],
                )),
            TextButton(
                onPressed: () {
                  logger.e("Implement");
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Wrap(
                  spacing: 4.0,
                  children: const [
                    Icon(Icons.bookmark_add_outlined, size: 18.0),
                    Text("Add to bookmark"),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
