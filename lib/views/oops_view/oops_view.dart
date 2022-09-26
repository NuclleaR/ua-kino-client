import 'package:flutter/material.dart';

class OopsView extends StatelessWidget {
  final String message;

  const OopsView({Key? key, String? message})
      : message = message ?? "Oops, something went wrong",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).errorColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Icon(
              Icons.error_outline,
              color: color,
              size: 64.0,
            ),
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
