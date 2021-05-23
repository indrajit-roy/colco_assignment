import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:provider/provider.dart';
import 'package:colco_assignment/uiComponents/text.dart';
import 'package:flutter/material.dart';

class Metrics extends StatefulWidget {
  final String choice;
  final String postId;

  const Metrics({Key key, this.choice, this.postId}) : super(key: key);
  @override
  _MetricsState createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: context.read<FirestoreHandler>().documentListener('Posts', widget.postId),
      builder: (context, snapshot) {
        // print(widget.postId);
        if (snapshot.connectionState == ConnectionState.active) {
          
          if (snapshot.hasData) {
            return MyText(
              text: snapshot.data.data()[widget.choice].toString(),
              fontSize: 9,
              fontWeight: FontWeight.normal,
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }
}
