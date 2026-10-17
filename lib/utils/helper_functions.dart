import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showMsg(BuildContext context, String message) => showMessage(context, message);

String formatDate(DateTime dateTime) {
  return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
}

String formatDateOnly(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

Color getAlertColor(String? alert, double magnitude) {
  if (alert != null) {
    switch (alert.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.amber.shade700;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
    }
  }

  if (magnitude >= 6.0) return Colors.red;
  if (magnitude >= 4.5) return Colors.orange;
  if (magnitude >= 2.5) return Colors.amber.shade700;
  return Colors.green;
}
