import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(this.width, this.text);
  final double width;
  final String text;
  @override
  Widget build(BuildContext context) {
    print(width);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      //constraints: BoxConstraints(maxWidth: width / 2),
      width: width/2,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(76),
        color: Color(0xccb22626),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: "Prompt",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
