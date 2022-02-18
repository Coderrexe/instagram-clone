import 'package:flutter/material.dart';

// Text field input widget UI, to be reused in the codebase.
class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPassword = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  final TextEditingController textEditingController;

  // If text field is for password, we have to obscure the text.
  final bool isPassword;
  final String hintText;

  // If the user is on mobile with a virtual keyboard, we change the keyboard
  // type depending on which field the user is entering (email, username, etc.).
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
