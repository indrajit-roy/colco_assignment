import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class IOHandler{
  Future<File> pickImage() async {
    try {

      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);
      if (pickedFile!=null) {
        return File(pickedFile.path);
      }
      
      return null;

    } on Exception catch (e) {
      print("IO HANDLER PICK IMAGE EXCEPTION!!! : $e");
    }
  }

  Future<File> cropImage(imageFile) async {
    try {

      final croppedImage = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square]);

      if (croppedImage!=null) return croppedImage;

      return null;

    } catch (e) {
      print("IO HANDLER CROPPING EXCEPTION!!! : $e");
    }
  }
}
