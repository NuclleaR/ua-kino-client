import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

bool isSelect(RawKeyEvent event) {
  return event.runtimeType == RawKeyUpEvent &&
      (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.select);
}

bool isFirstNode(FocusNode node) {
  return node.parent?.children.first == node;
}

bool isLastNode(FocusNode node) {
  return node.parent?.children.last == node;
}

bool isChangeScopeToMedia(RawKeyEvent event) {
  return event.runtimeType == RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.arrowRight;
}

bool isChangeScopeToMenu(RawKeyEvent event) {
  return event.runtimeType == RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.arrowLeft;
}
