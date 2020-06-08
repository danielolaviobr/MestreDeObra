import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String text;

  Button({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FlatButton(
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.6,
        height: size.height * 0.05,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          this.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
