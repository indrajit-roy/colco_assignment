import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/postMetricsProvider.dart';
import 'package:colco_assignment/uiComponents/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'detailsPage.dart';
import 'metrics.dart';

class ReactionsSection extends StatelessWidget {
  const ReactionsSection({
    Key key,
    @required this.postId,
    @required this.url,
    @required this.username,
    this.showDetailsButton = true,
  }) : super(key: key);

  final String postId;
  final String url;
  final String username;
  final bool showDetailsButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: showDetailsButton ? const EdgeInsets.only(top:0.0) : const EdgeInsets.only(top : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: showDetailsButton? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Metrics(
                        choice: 'likes',
                        postId: postId,
                      ),
                      GestureDetector(
                        onTap: () {
                          PostMetricsProvider.addLikeToPost(postId,
                              context.read<FirestoreHandler>().updateDocById);
                        },
                        child: SvgPicture.asset(
                          'lib/assets/heart.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Metrics(
                        choice: 'comments',
                        postId: postId,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'lib/assets/comment.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Metrics(
                        choice: 'shares',
                        postId: postId,
                      ),
                      GestureDetector(
                        onTap: () {
                          PostMetricsProvider.addShareToPost(postId,
                              context.read<FirestoreHandler>().updateDocById);
                        },
                        child: SvgPicture.asset(
                          'lib/assets/share.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (showDetailsButton)
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          postId: postId,
                          url: url,
                          username: username,
                        ),
                      ));
                    },
                    child: MyText(
                      text: "Details Page",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  StreamBuilder<DocumentSnapshot>(
                      stream: context
                          .read<FirestoreHandler>()
                          .documentListener('Posts', postId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return MyText(
                            text: "Shared by ${snapshot.data.data()['shares']} people",
                            fontSize: 12,
                          );
                        return Container();
                      }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
