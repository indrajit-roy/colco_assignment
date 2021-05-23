import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Widget child;
  const Box({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // border: Border.all(width: .1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.55),
                offset: const Offset(2, 2),
                blurRadius: 8,
              ),
              BoxShadow(
                color: Colors.white,
                offset: const Offset(-1, -1),
                blurRadius: 8,
              ),
            ],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xffDAE4EE),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: this.child,
          ),
        )
      ],
    );
  }
}
