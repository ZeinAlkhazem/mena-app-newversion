import 'dart:developer';

import 'package:flutter/material.dart';

Future<void> logInAlertDialog(BuildContext newContext) async {

  return showDialog(
    context: newContext,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30), // Customize the border radius
          // You can also use other ShapeBorder classes like OutlineInputBorder, StadiumBorder, etc.
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Enter credentials",
        ),
        titleTextStyle: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            fontFamily: 'PNfont',
            color: Color(0xff303840)),
        content: Text(
            "To proceed, please input your mobile number, email,or username"),
        contentTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'PNfont',
            color: Color(0xff303840)),
        actions: <Widget>[
          TextButton(
              style: ButtonStyle(
                alignment: Alignment.centerRight,
              ),
              onPressed: () {
                log("====== Clicked =====");
                Navigator.of(newContext).pop();
              },
              child: Text(
                "TRY AGAIN",
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'PNfont',
                    color: Color(0xff303840)),
              ))
        ],
      );
    },
  );
}


Future<void> showConfirmationDialog(BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: const Duration(seconds: 5),
    content: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 0),
        decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(5)),
        child: const Text(
          'An email has been dispatched to (Email) containing a link to access your account',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14
          ),
        )),
  ));
}


/**
  * dialogs for enter pin code
  *
  *
 */

Future<void> pinCodeAlertDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Customize the border radius
          // You can also use other ShapeBorder classes like OutlineInputBorder, StadiumBorder, etc.
        ),
        backgroundColor: Colors.white,
        title: Text("That code didn’t work",),
        titleTextStyle: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            fontFamily: 'PNfont',
            color: Color(0xff303840)
        ),
        content: Text("Please re-enter your code or request a new one"),
        contentTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'PNfont',
            color: Color(0xff303840)
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                alignment: Alignment.centerRight,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                "TRY AGAIN",
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'PNfont',
                    color: Color(0xff303840)
                ),))],
      );
    },
  );
}