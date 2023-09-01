import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final TextInputType textInputType;
  final String hintText;

  const TextFieldInput({super.key,required this.textEditingController,this.isPass=false,required this .hintText, required this.textInputType});

  @override
  Widget build(BuildContext context) {

    final inputBorder = OutlineInputBorder(
      // borderSide: Devider
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText:hintText,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
