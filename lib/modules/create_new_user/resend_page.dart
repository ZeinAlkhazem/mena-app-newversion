import 'package:flutter/material.dart';

import '../../core/functions/main_funcs.dart';
import '../auth_screens/sign_in_screen.dart';

Future<void> resendAlertDialog(BuildContext newContext,VoidCallback btnResendCode) {
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
            "I haven't received the code",
          ),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextButton(
                  onPressed: btnResendCode,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                        "Request a new confirmation code",
                        style: TextStyle(color: Color(0xff303840),)
                      ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    navigateTo(context, SignInScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Sign in to your existing account",
                      style: TextStyle(color: Color(0xff303840),)
                    ),
                  ),
                ),
              ],
            ),
          ),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)),
                  )),
            )
          ],
        );
      });
}
