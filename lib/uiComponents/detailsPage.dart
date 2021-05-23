import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/uiComponents/postItem.dart';
import 'package:colco_assignment/uiComponents/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String postId;
  final String url;
  final String username;

  const DetailsPage({Key key, this.postId, this.url, this.username})
      : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: BackButton(
          color: Colors.cyan,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: context
                .read<FirestoreHandler>()
                .queryListener('Posts/${widget.postId}/comments'),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return ListView(
                  children: [
                    PostItem(
                      postId: widget.postId,
                      url: widget.url,
                      username: widget.username,
                      showDetailsButton: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Comments",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ...snapshot.data.docs
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'lib/assets/profilePic.jpg'),
                                          radius: 10,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: 300,
                                            child: Text(
                                          e.data()['body'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          
                                        )),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                );
              return Container();
            }),
      ),
    );
  }
}
