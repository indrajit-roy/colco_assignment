import 'dart:async';

import 'package:colco_assignment/models/postModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PostsProvider extends ChangeNotifier {
  bool hasMore = true;

  bool _isLoading;
  List<QueryDocumentSnapshot> _data;
  StreamController<List<PostModel>> _controller;

  PostsProvider() {
    _data = [];
    _controller = StreamController<List<PostModel>>.broadcast();
    _isLoading = false;
  }

  reset() {
    _data = [];
    _controller.add([]);
    hasMore = true;
  }

  Stream<List<PostModel>> postsList() {
    return _controller.stream;
  }

  Future<void> loadMore(BuildContext context) async {
    if (_isLoading || !hasMore) return Future.value();

    _isLoading = true;

    // final value = await _firestore.collection('Posts').get();

    final value = await context
        .read<FirestoreHandler>()
        .getDocumentsListSnapshot('Posts', _data.isEmpty ? null : _data.last);

    _isLoading = false;

    final list = value.docs;
    _data.addAll(list);

    _controller.add(
      _data.map((QueryDocumentSnapshot postData) {
        // print('mapping');
        return PostModel(
            postId: postData.id,
            username: postData.data()['username'],
            imageUrl: postData.data()['imageUrl'],
            likes: postData.data()['likes'],
            comments: postData.data()['comments'],
            shares: postData.data()['shares'],
            timestamp: postData.data()['timestamp'].toDate());
      }).toList(),
    );

    final postLength = await context.read<FirestoreHandler>().getMeta();
    hasMore = (_data.length < postLength);
  }
}
