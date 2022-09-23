import 'package:flutter/material.dart';

class OopsPage extends StatelessWidget {
  const OopsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Add beautiful BG
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.amber.shade800,
                size: 64.0,
              ),
            ),
            Text(
              "Oops, something went wrong",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.amber.shade800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
