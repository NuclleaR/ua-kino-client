import 'package:flutter/material.dart';
import 'package:uakino/models/media/media_preview_item.dart';

const Duration _kScale = Duration(milliseconds: 200);

class MediaItemView extends StatefulWidget {
  final MediaPreviewItem mediaItem;
  final int index;
  final FocusOnKeyCallback? onKey;

  const MediaItemView({Key? key, required this.mediaItem, required this.index, this.onKey})
      : super(key: key);

  @override
  State<MediaItemView> createState() => _MediaItemViewState();
}

class _MediaItemViewState extends State<MediaItemView> with TickerProviderStateMixin {
  var _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Focus(
        onKey: widget.onKey,
        onFocusChange: _setFocused,
        child: AnimatedScale(
          curve: Curves.easeIn,
          duration: _kScale,
          scale: _isFocused ? 1.2 : 1,
          child: Container(
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(widget.mediaItem.image), fit: BoxFit.cover),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(5),
                    color: Colors.black,
                    child:
                        Text(widget.mediaItem.title, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setFocused(bool value) {
    setState(() {
      _isFocused = value;
    });
  }
}
