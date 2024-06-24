import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSnackBarError(BuildContext context, String message) {
  showSnackBar(context, message, Colors.red);
}

void showSnackBarSuccess(BuildContext context, String message) {
  showSnackBar(context, message, Colors.green);
}

void showSnackBarInfo(BuildContext context, String message) {
  showSnackBar(context, message, Colors.blue);
}

void showSnackBarWarning(BuildContext context, String message) {
  showSnackBar(context, message, Colors.orange);
}
