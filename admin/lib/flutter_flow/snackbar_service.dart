
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      showCloseIcon: true,
      width: 500,
      behavior: SnackBarBehavior.floating,
    ));
  }
}