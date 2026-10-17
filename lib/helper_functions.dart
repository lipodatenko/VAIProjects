import 'package:flutter/material.dart';

void showMsg(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showResult(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onPlayAgain,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onPlayAgain();
          },
          child: const Text('PLAY AGAIN'),
        ),
      ],
    ),
  );
}
