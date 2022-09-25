import 'package:flutter/material.dart';

class PosterView extends StatelessWidget {
  final String src;

  const PosterView({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: SizedBox(width: 220, height: 330, child: Image.network(src, fit: BoxFit.cover)),
    );
  }
}
