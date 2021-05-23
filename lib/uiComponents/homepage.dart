import 'dart:io';

import 'package:colco_assignment/providers/FirebaseHadlers/Firestorage.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/newPostHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/postsProvider.dart';
import 'package:colco_assignment/models/postModel.dart';
import 'package:colco_assignment/providers/controllers/textEditing.dart';
import 'package:colco_assignment/uiComponents/newPostStage.dart';
import 'package:colco_assignment/uiComponents/postItem.dart';
import 'package:colco_assignment/uiComponents/text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  bool isInit;
  // PostsProvider posts;

  scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      print('scroll listener true');
      context.read<PostsProvider>().loadMore(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(scrollListener);
    isInit = true;
    // posts = PostsProvider();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(context);
    if (isInit) {
      context.read<PostsProvider>().loadMore(context);
      isInit = false;
    }
    return Scaffold(
      // backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      // appBar:
      // AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   title: StreamBuilder<TaskSnapshot>(
      //     stream: context.read<TextEditing>().controller.stream,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         print("UPLOADING!!!${snapshot.data.bytesTransferred}");
      //         return Container(
      //           color: Colors.amber,
      //           height: 20,
      //           width: (MediaQuery.of(context).size.width /
      //                   snapshot.data.totalBytes) *
      //               snapshot.data.bytesTransferred,
      //         );
      //       }
      //       return Container();
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xfff21130).withAlpha(200),
          onPressed: () async {
            //ADDING NEW POST

            try {
              final croppedImageFile = await NewPostHandler.prepareNewPost();

              if (croppedImageFile != null) {
                final newPost = await Navigator.of(context)
                    .push<LocalPostModel>(MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      body: NewPostStage(
                        image: croppedImageFile,
                      ),
                    );
                  },
                ));

                if (newPost != null) {
                  final response = await NewPostHandler.addNewPost(
                      post: newPost, context: context);

                  // print(response);
                }

                //   Scaffold.of(context).showSnackBar(SnackBar(
                //     content: Text("Post Added. Pull to Refresh"),
                //   ));
                // });
              }
            } on Exception catch (e) {
              print("Exception with adding new post $e");
            }
          }),
      body: StreamBuilder<List<PostModel>>(
          stream: context.read<PostsProvider>().postsList(),
          builder: (context, snapshot) {
            print("Streaming....");
            if (snapshot.connectionState != ConnectionState.waiting) {
              return RefreshIndicator(
                onRefresh: () {
                  context.read<PostsProvider>().reset();

                  return context.read<PostsProvider>().loadMore(context);
                },
                child: snapshot.data.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) {
                          // print("ListView rebulids");
                          if (index < snapshot.data.length) {
                            return PostItem(
                                postId: snapshot.data[index].postId,
                                url: snapshot.data[index].imageUrl,
                                username: snapshot.data[index].username,
                                timestamp: snapshot.data[index].timestamp);
                          } else {
                            return context.read<PostsProvider>().hasMore
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: CircularProgressIndicator(),
                                  ))
                                : SizedBox(
                                    height: 60,
                                  );
                          }
                        },
                      )
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Center(
                                child: MyText(
                              text: "No Posts Added Yet",
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            )),
                          ),
                        ],
                      ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
