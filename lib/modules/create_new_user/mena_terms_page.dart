import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/my_models/create_user_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/sign_in_screen.dart';
import '../home_screen/home_screen.dart';

class MenaTerms extends StatefulWidget {
  final CreateUserModel userInfo;

  const MenaTerms({super.key, required this.userInfo});

  @override
  State<MenaTerms> createState() => _MenaTermsState();
}

class _MenaTermsState extends State<MenaTerms> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("# create user info : ${widget.userInfo}");
    log("# create user info : ${widget.userInfo.email}");
    log("# create user info : ${widget.userInfo.phone}");
    log("# create user info : ${widget.userInfo.userName}");
    log("# create user info : ${widget.userInfo.dateOfBirth}");
    log("# create user info : ${widget.userInfo.password}");
    log("# create user info : ${widget.userInfo.platformId}");
    log("# create user info : ${widget.userInfo.specialitList}");
  }

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context)
      ..toggleAutoValidate(false)
      ..togglePassVisibilityFalse();
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
                      'Agree to Mena\’s terms and policies',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PNfont',
                        color: Color(0xff303840),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                    heightBox(25.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                            'By tapping I agree,\' you consent to creating an account and accepting Mena\'s ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: 'Terms, Privacy Policy ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff0077FF),
                                fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text: 'and ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: 'Cookies Policy.',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff0077FF),
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    heightBox(15.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'The ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: 'privacy policy ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff0077FF),
                                fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text:
                            'describes how we utilize the information we gather when you create an account. For instance, we use this data to enhance our products and deliver personalized experiences, which may include advertisements.',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    heightBox(30.h),
                    DefaultButton(
                        text: "I agree",
                        onClick: () {
                          navigateTo(context, HomeScreen());
                        }),
                    heightBox(360.h),
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