import 'package:flutter/material.dart';

// Text field input widget UI, to be reused in the codebase.
class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPassword = false,
    required this.hintText,
    required this.textInputType,
    this.validator,
  }) : super(key: key);

  // TextEditingController class helps us handle changes to a text field.
  final TextEditingController textEditingController;

  // If text field is for password, we have to obscure the text.
  final bool isPassword;
  final String hintText;

  // If the user is on mobile with a virtual keyboard, we change the keyboard
  // type depending on which field the user is entering (email, username, etc.).
  final TextInputType textInputType;

  // Function to check if the user input is acceptable.
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
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
      validator: validator,
    );
  }
}
