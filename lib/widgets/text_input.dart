import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final Function onChanged;
  final String fieldLabel;
  final bool isPassword;

  TextInput({this.onChanged, this.fieldLabel, this.isPassword});
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      textAlign: TextAlign.center,
      onChanged: this.onChanged,
      decoration: InputDecoration(
        labelText: this.fieldLabel,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }
}
