import 'package:flutter/material.dart';
import 'package:uakino/views/main_content_view/main_content_view.dart';
import 'package:uakino/views/sidebar_view/sidebar_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
      body: Row(
        children: [const SidebarView(), MainContentView()],
      ),
    );
  }
}
