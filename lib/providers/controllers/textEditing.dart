import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class TextEditing extends ChangeNotifier {
  Stream<TaskSnapshot> uploadTask;
  StreamController<TaskSnapshot> controller;

  final _editingController = StreamController<String>();

  Stream<String> get activeText => _editingController.stream;

  TextEditingController _textEditingController;

  TextEditingController get editor => _textEditingController;

  TextEditing() {
    controller = StreamController<TaskSnapshot>();
    uploadTask = controller.stream;
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_listener);
  }

  _listener() {
    _editingController.add(_textEditingController.text);
    print(_textEditingController.text);
  }
}
