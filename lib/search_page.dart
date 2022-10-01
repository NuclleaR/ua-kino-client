import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/controllers/search_controller.dart';
import 'package:uakino/views/media_grid/media_grid.dart';
import 'package:uakino/views/oops_view/oops_view.dart';

class SearchPage extends GetWidget<SearchController> {
  const SearchPage({super.key});

  // TODO: Add voice search
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600.0,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) {
                      // Press down to move focus to grid
                      if (event.runtimeType == RawKeyUpEvent &&
                          LogicalKeyboardKey.arrowDown == event.logicalKey) {
                        FocusScope.of(context).nextFocus();
                        // TODO: Put search string to history here
                        return;
                      }
                      // When RawKeyboardListener got focus move focus to text field
                      if (LogicalKeyboardKey.arrowUp == event.logicalKey) {
                        controller.searchNode;
                        return;
                      }
                    },
                    child: TextField(
                      focusNode: controller.searchNode,
                      onChanged: controller.onSearchChange,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        labelText: "Search",
                        // fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Wrap(
          //   spacing: 10.0,
          //   children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
          //       .map((e) => Chip(label: Text("Search $e")))
          //       .toList(),
          // ),
          controller.obx((state) {
            return Expanded(
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                  child: SizedBox(
                    width: gridWidth,
                    child: MediaGrid(
                      controller: controller.scrollController,
                      list: state,
                      clipBehavior: Clip.none,
                    ),
                  ),
                ),
              ),
            );
          },
              onError: (error) => OopsView(message: error),
              onEmpty: const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text("No media found"),
              ),
              onLoading: const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: CircularProgressIndicator(),
              )),
        ],
      ),
    );
  }
}
