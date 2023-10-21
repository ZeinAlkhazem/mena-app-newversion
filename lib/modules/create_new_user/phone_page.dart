import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';
import 'confirmation_phone_page.dart';
import 'email_page.dart';

class PhoneNumberVer extends StatefulWidget {
  const PhoneNumberVer({super.key});

  @override
  State<PhoneNumberVer> createState() => _PhoneNumberVerState();
}

class _PhoneNumberVerState extends State<PhoneNumberVer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/back.png', // Replace with your image path
            scale: 3,
            alignment: Alignment.centerRight, // Adjust the height as needed
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 5, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox(15.h),
                    Text(
                      'What\'s your mobile number?',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PNfont',
                        color: Color(0xff303840),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                    heightBox(25.h),
                    Text(
                      textAlign: TextAlign.start,
                      "Enter the mobile number where you can be reached. This information will not be visible in your profile",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                          fontWeight: FontWeight.w500),
                    ),
                    heightBox(30.h),
                    DefaultInputField(
                      onFieldChanged: (text) {
                        // phoneConfirmation = text;
                      },
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Mobile Number',
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(15.h),
                    Text(
                      textAlign: TextAlign.start,
                      "We may send you SMS notifications for security and login-related purposes",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                          fontWeight: FontWeight.w500),
                    ),
                    heightBox(15.h),
                    DefaultButton(
                        text: "Next",
                        onClick: () {
                          navigateTo(context, ConfirmationCodePhone());
                        }),
                    heightBox(15.h),
                    DefaultButton(
                        backColor: Colors.white,
                        borderColor: Color(0xff999B9D),
                        text: "Sign up with email",
                        titleColor: Color(0xff303840),
                        onClick: () {
                          Navigator.pop(context);
                          // navigateTo(context, EmailVer(userInfo: null,));
                        }),
                    heightBox(320.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: TextButton(
                        onPressed: () {
                          navigateTo(context, SignInScreen());
                        },
                        child: Text(
                          textAlign: TextAlign.start,
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'PNfont',
                              color: Color(0xff0077FF),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}