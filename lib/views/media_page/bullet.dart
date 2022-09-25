import 'package:flutter/material.dart';

class Bullet extends StatelessWidget {
  final Color color;

  const Bullet({Key? key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "  ●  ",
      style: TextStyle(color: color),
    );
  }
}
