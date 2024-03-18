import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
