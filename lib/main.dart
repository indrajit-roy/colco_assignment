import 'package:colco_assignment/providers/FirebaseHadlers/Firestorage.dart';
import 'package:colco_assignment/providers/FirebaseHadlers/FirestoreHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/newPostHandler.dart';
import 'package:colco_assignment/providers/PostHandlers/postsProvider.dart';
import 'package:colco_assignment/providers/controllers/textEditing.dart';
import 'package:colco_assignment/providers/ioHandler.dart';
import 'package:colco_assignment/uiComponents/newPostStage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'uiComponents/homepage.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FirestoreHandler(),
        ),
        ChangeNotifierProvider(
          create: (_) => Firestorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewPostHandler(),
        ),
        ChangeNotifierProvider(
          create: (_) => TextEditing(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(),
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: const Color(0xffDAE4EE),
                body: SafeArea(
                  child: HomePage(),

                  // NewPostStage(),
                ),
              ),
            );
          return CircularProgressIndicator();
        });
  }
}
