import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uakino/controllers/app_state.dart';
import 'package:uakino/views/main_content_view/main_content_view.dart';
import 'package:uakino/views/oops_view/oops_view.dart';
import 'package:uakino/views/sidebar_view/sidebar_view.dart';

class HomePage extends GetView<AppState> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isCheckConnect || controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.isConnected) {
          return const OopsView(message: "No connection");
        }
        return Row(
          children: [const SidebarView(), MainContentView()],
        );
      }),
    );
  }
}
