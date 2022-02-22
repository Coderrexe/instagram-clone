import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Function for allowing users to upload a profile picture.
Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  return null;
}

// Function for showing snack bar animation.
void showSnackBar({
  required BuildContext context,
  required String content,
  required String label,
  Color? backgroundColor,
  Color? textColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: textColor,
        ),
      ),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        onPressed: () {},
        label: label,
      ),
    ),
  );
}
