import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Hello Grid"),
            Text(Get.parameters["path"] ?? "WTF?"),
          ],
        ),
      ),
    );
  }
}
