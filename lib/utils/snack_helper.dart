import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  _showCustomMessage(context, Colors.red, message: message);
}

void showSuccessMessage(BuildContext context, {required String message}) {
  _showCustomMessage(context, Colors.green, message: message);
}

void _showCustomMessage(BuildContext context, Color color,
    {required String message}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
