import 'package:flutter/material.dart';

class MyBuilders { 

   Widget streamBuilderFunction(Widget activeChild,Widget passiveChild, AsyncSnapshot snapshot) {
    
      if (snapshot.hasData) return activeChild;
      return CircularProgressIndicator();
    
  }

  
}
