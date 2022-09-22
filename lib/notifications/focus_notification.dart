import 'package:flutter/material.dart';

class FocusNotification extends Notification {
  const FocusNotification(this.childKey);

  final Key? childKey;
}
