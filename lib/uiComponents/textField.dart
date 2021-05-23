import 'package:colco_assignment/uiComponents/text.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const MyTextField({Key key, this.text, this.fontSize, this.fontWeight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
    width: 246,
    height: 50,
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
            Container(
                width: 246,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xc1c4c4c4), Color(0x7fc4c4c4), Color(0x00c4c4c4)], ),
                ),
                padding: const EdgeInsets.only(left: 54, right: 51, top: 11, bottom: 12, ),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                        MyText(text: text,fontSize: fontSize,fontWeight: fontWeight,)
                    ],
                ),
            ),
        ],
    ),
);
  }
}