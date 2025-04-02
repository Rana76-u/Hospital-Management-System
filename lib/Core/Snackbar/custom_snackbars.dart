
import 'package:flutter/material.dart';

class CustomSnackBar {

  openPrimarySnackBar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: Color(0xff4338CA),
      content: Text(text),
      duration: Duration(milliseconds: 2500),
    ));
  }

  openIconSnackBar(context, String text, Widget icon) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: Colors.green,
      content: Row(
        children: [
          icon,
          SizedBox(width: 5,),
          Text(text)
        ],
      ),
      duration: const Duration(milliseconds: 2500),
    ));
  }

  openErrorSnackBar(context, String text ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text('Error: $text'),
      duration: Duration(milliseconds: 2500),
    ));
  }

  openWarningSnackBar(context, String text ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.yellow,
      content: Row(
        children: [
          Icon(Icons.warning,color: Colors.black,),
          SizedBox(width: 5,),
          Text(text,style: TextStyle(fontSize: 16,color: Colors.black),),

        ],
      ),
      duration: Duration(milliseconds: 12500),
    ));
  }
}