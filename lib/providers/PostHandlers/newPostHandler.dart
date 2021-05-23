import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_assignment/models/postModel.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/Firestorage.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/providers/controllers/textEditing.dart';
import 'package:colco_assignment/providers/ioHandler.dart';
import 'package:colco_assignment/uiComponents/newPostStage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPostHandler extends ChangeNotifier {
  
  
  static Future<File> prepareNewPost() async {
    IOHandler ioHandler = IOHandler();
    try {
      final pickedImage = await ioHandler.pickImage();

      if (pickedImage != null) {
        final croppedImage = await ioHandler.cropImage(pickedImage);
        if (croppedImage != null) {
          return croppedImage;
        }
      }

      return null;
    } catch (e) {
      print("NEW POST HANDLER PREPARE POST EXCEPTION!!! : $e");
    }
  }



  static Future<dynamic> addNewPost(
      {LocalPostModel post, BuildContext context}) async {
    bool uploadSuccess;
    try {


      final numberOfPosts = await context.read<FirestoreHandler>().getMeta();
      

      //UPLOAD TO FIREBASE STORAGE
      final uploadTask = await context
          .read<Firestorage>()
          .uploadFile("/postImages/image${numberOfPosts + 1}", post.image,
              (TaskSnapshot event) {
        print("UPLOAD TASKKKK ON DATA!!!");
        context.read<TextEditing>().controller.add(event);
        if (event.bytesTransferred == event.totalBytes) uploadSuccess = true;
      },);

      print("UPLOAD TASKKKK @@@@!!! ${uploadTask.taskRespone}");


      
      //CHECK IF UPLOAD IS SUCCESSFUL AND UPDATE FIRESTORE
      if (uploadSuccess = true) {}
      final response = await context
          .read<FirestoreHandler>()
          .addDocumentToCollection('Posts', {
        'username': 'user',
        'imageUrl': uploadTask,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'timestamp': DateTime.now(),
      });
      await context.read<FirestoreHandler>().addDocumentToCollectionById(
          'postDetails', response.id, {"likes": 0, "comments": 0, "shares": 0});

      await context.read<FirestoreHandler>().setMeta();

      
    } on Exception catch (e) {
      // TODO
    }
  }
}
