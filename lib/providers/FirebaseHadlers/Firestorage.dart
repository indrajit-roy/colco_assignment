import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Firestorage extends ChangeNotifier {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<dynamic> uploadFile(
      String path, File image, void Function(TaskSnapshot) onData) async {
    UploadTask task = _firebaseStorage.ref(path).putFile(image);

    task.snapshotEvents.listen(onData);

    try {
      final taskRespone = await task;
      final downloadUrl = await _firebaseStorage.ref(path).getDownloadURL();
      print("UPLOAD COMPLETE! TASK -> $taskRespone");
      print("DOWNLOAD URL -> $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("UPLOAD EXCEPTIONNNN!!! $e");
    }
  }
}
