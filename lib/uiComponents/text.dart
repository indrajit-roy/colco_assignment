import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const MyText({Key key, this.text, this.fontSize, this.fontWeight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xff8aa1aa),
        fontSize: fontSize,
        fontFamily: "Prompt",
        fontWeight: fontWeight,
      ),
    );
  }
}
