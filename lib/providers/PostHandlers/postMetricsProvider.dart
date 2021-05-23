import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/models/postModel.dart';

class PostMetricsProvider {
  PostMetricsProvider() {}

  static Future<void> addLikeToPost(String postId,
      Future<void> Function(String, String, String, [int]) update) async {
    await update('Posts', postId, 'likes', 1);
  }

  static Future<void> addCommentToPost(String postId,
      Future<void> Function(String, String, String, [int]) update) async {
    await update('Posts', postId, 'comments', 1);
  }

  static Future<void> addShareToPost(String postId,
      Future<void> Function(String, String, String, [int]) update) async {
    await update('Posts', postId, 'shares', 1);
  }
}
