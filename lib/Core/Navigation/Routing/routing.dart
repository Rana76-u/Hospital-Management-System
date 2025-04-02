import 'package:flutter/material.dart';

class Routing {
  void goto(BuildContext context, Widget page){
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return page;
          },
        )
    );
  }
}