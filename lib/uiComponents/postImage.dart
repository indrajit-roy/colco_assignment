import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  const PostImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
      image: NetworkImage(url),
    );
  }
}