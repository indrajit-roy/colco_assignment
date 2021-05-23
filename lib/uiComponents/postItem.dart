import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/postMetricsProvider.dart';
import 'package:colco_assignment/providers/PostHandlers/postsProvider.dart';
import 'package:colco_assignment/uiComponents/DiscussionRoom.dart';
import 'package:colco_assignment/uiComponents/components/myBuilders.dart';
import 'package:colco_assignment/uiComponents/detailsPage.dart';
import 'package:colco_assignment/uiComponents/metrics.dart';
import 'package:colco_assignment/uiComponents/postImage.dart';

import 'package:colco_assignment/uiComponents/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'reactionsSection.dart';

class PostItem extends StatefulWidget {
  final String postId;
  final String url;
  final String username;
  final DateTime timestamp;
  final bool showDetailsButton;

  PostItem(
      {Key key,
      this.postId,
      this.url,
      this.username,
      this.timestamp,
      this.showDetailsButton = true})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  String comment = "";
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 26),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
                  width: 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage("lib/assets/profilePic.jpg")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: widget.username,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      MyText(
                        text: widget.timestamp.toString(),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          PostImage(url: widget.url),
          ReactionsSection(
            postId: widget.postId,
            url: widget.url,
            username: widget.username,
            showDetailsButton: widget.showDetailsButton,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Comment Something Here..",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        )),
                    maxLines: null,
                    onChanged: (value) {
                      if (comment.isEmpty || value.isEmpty) {
                        setState(() {});
                      }
                      comment = value;
                    },
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        onPressed: comment.isEmpty
                            ? null
                            : () async {
                                if (comment.isNotEmpty) {
                                  _controller.clear();
                                  await context
                                      .read<FirestoreHandler>()
                                      .addDocumentToCollection(
                                    'Posts/${widget.postId}/comments',
                                    {
                                      "body": comment,
                                    },
                                  );
                                  await PostMetricsProvider.addCommentToPost(
                                      widget.postId,
                                      context
                                          .read<FirestoreHandler>()
                                          .updateDocById);
                                }
                              },
                        child: MyText(
                          text: "ADD",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )))
              ],
            ),
          ),
          MyText(text: "Long Description"),
          StreamBuilder<QuerySnapshot>(
            stream: context
                .read<FirestoreHandler>()
                .queryListener('Posts/${widget.postId}/comments'),
            builder: (context, snapshot) {
              return MyBuilders().streamBuilderFunction(
                  CommentsList(
                    snapshot: snapshot,
                  ),
                  Container(),
                  snapshot);
            },
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              "Enter Discussion",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            color: Colors.pink.withAlpha(160),
            onPressed: () {
              //Navigate to Discussion Room
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DiscussionRoom(
                    postId: widget.postId, username: widget.username),
              ));
            },
          )
        ],
      ),
    );
  }
}

class CommentsList extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  CommentsList({Key key, this.snapshot}) : super(key: key);

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.snapshot.data.docs.map((e) => Text(e.data()['body'])).toList()
      ],
    );
  }
}
