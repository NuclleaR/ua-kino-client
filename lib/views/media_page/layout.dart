import 'package:flutter/material.dart';
import 'package:uakino/models/media/media_item.dart';
import 'package:uakino/views/media_page/bullet.dart';
import 'package:uakino/views/media_page/controls_view.dart';
import 'package:uakino/views/media_page/poster_view.dart';

class MediaInfoLayout extends StatelessWidget {
  final MediaItem item;

  const MediaInfoLayout({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          PosterView(src: item.poster),
          Expanded(
            child: Column(
              children: [
                ControlsView(item: item),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Text(
                                item.mediaInfo.year,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              const Bullet(),
                              Text(
                                item.mediaInfo.genres,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              const Bullet(),
                              Text(
                                item.mediaInfo.country,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Text(
                                item.mediaInfo.lang,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              const Bullet(),
                              Text(
                                item.mediaInfo.quality,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              const Bullet(),
                              Text(
                                item.mediaInfo.imdbScore,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          child: Text(
                            item.mediaInfo.actors,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        if (item.mediaInfo.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              item.mediaInfo.description,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
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
}
