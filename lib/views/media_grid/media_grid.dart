import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/media/media_preview_item.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/media_item_view/media_item_view.dart';

const _aspectRatio = 140 / 207;

class MediaGrid extends StatelessWidget {
  final ScrollController? controller;
  final List<MediaPreviewItem>? list;
  final Clip clipBehavior;

  const MediaGrid({Key? key, this.controller, this.list, this.clipBehavior = Clip.hardEdge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GridView.count(
          childAspectRatio: _aspectRatio,
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 4,
          clipBehavior: clipBehavior,
          controller: controller,
          children: list
                  ?.map((mediaItem) => MediaItemView(
                        mediaItem: mediaItem,
                        onKey: (node, event) {
                          if (isSelect(event)) {
                            logger.i("Select $mediaItem");
                            Get.toNamed(mediaItemRoute, arguments: mediaItem);
                          }
                          return KeyEventResult.ignored;
                        },
                      ))
                  .toList(growable: false) ??
              [],
        ),
      ),
    );
  }
}
