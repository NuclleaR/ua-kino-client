import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String title;

  const TitleView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 8.0),
      child: Text(
        title,
        textAlign: TextAlign.end,
        style: const TextStyle(color: Colors.white, fontSize: 32.0),
      ),
    );
  }
}
