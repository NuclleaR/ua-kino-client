import 'package:flutter/material.dart';

import 'views/oops_view/oops_view.dart';

class OopsPage extends StatelessWidget {
  final String? message;

  const OopsPage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Add beautiful BG
    return Scaffold(
      body: OopsView(message: message),
    );
  }
}
