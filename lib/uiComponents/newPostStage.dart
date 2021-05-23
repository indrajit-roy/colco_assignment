import 'dart:io';
import 'dart:ui';

import 'package:colco_assignment/models/postModel.dart';
import 'package:colco_assignment/providers/PostHandlers/newPostHandler.dart';
import 'package:colco_assignment/providers/controllers/textEditing.dart';
import 'package:colco_assignment/uiComponents/components/box.dart';
import 'package:colco_assignment/uiComponents/text.dart';
import 'package:colco_assignment/uiComponents/textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPostStage extends StatefulWidget {
  final File image;
  NewPostStage({Key key, this.image}) : super(key: key);

  @override
  _NewPostStageState createState() => _NewPostStageState();
}

class _NewPostStageState extends State<NewPostStage> {
  String description;
  TextEditingController _descriptionController;
  bool isInit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptionController = TextEditingController();
    _descriptionController.addListener(() {
      print(_descriptionController.text);
    });
    isInit = true;
  }

  @override
  void deactivate() {
    print("DEACTIVATE");
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    print("DISOSING");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("I am rebuilding");
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.cyan,
          onPressed: () => Navigator.of(context).pop(null),
        ),
        actions: [
          TextButton.icon(
            onPressed: widget.image != null
                ? () {
                    //Sending back the final post details
                    Navigator.pop<LocalPostModel>(
                      context,
                      LocalPostModel(_descriptionController.text,
                          DateTime.now(), widget.image, 0, 0, 0),
                    );
                  }
                : null,
            icon: Icon(Icons.add),
            label: MyText(
              text: "POST",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body:
          //POST EDITING SECTION

          //IMAGE
          SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.file(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),

            //TEXT FIELD
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Box(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    selectionHeightStyle: BoxHeightStyle.max,
                    controller:
                        Provider.of<TextEditing>(context,listen: true).editor,
                        // _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Write something about your Post...",
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),
            //END TEXT FIELD
          ],
        ),
      ),
    );
  }
}
