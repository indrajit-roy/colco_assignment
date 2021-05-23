import 'dart:io';

class PostModel {
  final String postId;
  final String username;
  final DateTime timestamp;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;

  PostModel(
      {this.postId,
      this.username,
      this.timestamp,
      this.imageUrl,
      this.likes,
      this.comments,
      this.shares});
  
}

class LocalPostModel{
  
  final String username;
  final DateTime timestamp;
  final File image;
  final int likes;
  final int comments;
  final int shares;

  LocalPostModel(this.username, this.timestamp, this.image, this.likes, this.comments, this.shares);
  
}
