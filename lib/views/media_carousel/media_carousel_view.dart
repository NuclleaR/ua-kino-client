import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uakino/models/media/media_carousel.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/media_item_view/media_item_view.dart';

class MediaCarouselView extends StatelessWidget {
  final MediaCarousel data;

  MediaCarouselView({Key? key, required this.data}) : super(key: key);

  var _focusMenuOnNext = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
          child: Row(
            children: [
              Text(
                data.title,
                style: const TextStyle(color: Colors.white, fontSize: 24.0),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SizedBox(
            height: 248,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.mediaItems.length,
              clipBehavior: Clip.none,
              itemBuilder: _buildMediaItemView,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaItemView(BuildContext context, int index) {
    final isLast = data.mediaItems.last == data.mediaItems[index];
    final isFirst = data.mediaItems.first == data.mediaItems[index];

    return MediaItemView(
      mediaItem: data.mediaItems[index],
      index: index,
      onKey: (node, event) {
        if (isFirst && event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_focusMenuOnNext && isChangeScopeToMenu(event)) {
            node.enclosingScope?.parent?.children.first.requestFocus();
          }
          _focusMenuOnNext = true;
          return KeyEventResult.handled;
        }
        _focusMenuOnNext = false;
        return event.logicalKey == LogicalKeyboardKey.arrowRight && isLast
            ? KeyEventResult.handled
            : KeyEventResult.ignored;
      },
    );
  }
}
