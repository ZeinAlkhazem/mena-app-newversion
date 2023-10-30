import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/create_new_user/phone_page.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/dialogs/dialogs_page.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/network/dio_helper.dart';
import '../../core/network/network_constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/my_models/create_user_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';
import 'mena_terms_page.dart';
import 'resend_page.dart';

class ConfirmationCodeEmail extends StatefulWidget {
  final CreateUserModel userInfo;

  const ConfirmationCodeEmail({super.key, required this.userInfo});

  @override
  State<ConfirmationCodeEmail> createState() => _ConfirmationCodeEmailState();
}

class _ConfirmationCodeEmailState extends State<ConfirmationCodeEmail> {
  final codeController = TextEditingController();

  CreateUserModel? newUserModel;

  Future<bool?> resetPassRequest(String input) async {
    log("# input is : $input");
    // Map<String, dynamic> body = {
    //   'phone': input,
    // };
    bool resultState = false;
    log("# Url : ${sendCodeNewUser + input}");
    await MainDioHelper.getData(
      url: sendCodeNewUser + "$input",
      query: {},
    ).then((value) {
      logg('Verify num response Reset Password: $value');
      resultState = true;
      return true;
    }).catchError((error) {
      logg("# Error  : ${error.response.toString()}");
      resultState = false;
      return false;
    });
    return resultState;
  }


  //// check if code is correct
  Future<bool?> checkCodeValidateRequest(String email, String code) async {
    log("# code is : $code");
    log("# email is : $email");
    Map<String, dynamic> body = {
      'email': email,
      'code': code,
    };
    bool resultState = false;
    await MainDioHelper.postData(url: verifyCodeEnd, data: body)
        .then((value) {
      logg('Verify num response Reset Password: $value');
      resultState = true;
      return true;
    }).catchError((error) {
      logg("# Error  : ${error.response.toString()}");

      resultState = false;
      return false;
    });
    return resultState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultOnlyLogoAppbar1(
          withBack: true,
          // title: 'Back',
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
                      'Enter the confirmation code',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PNfont',
                        color: Color(0xff303840),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                    heightBox(25.h),
                    // Text(
                    //   textAlign: TextAlign.start,
                    //   "To confirm your account, please enter the 8-digit code we sent to $emailConfirmation",
                    //   style: TextStyle(
                    //       fontSize: 13,
                    //       fontFamily: 'PNfont',
                    //       color: Color(0xff303840),
                    //       fontWeight: FontWeight.w500),
                    // ),
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
                                'To confirm your account, please enter the 8-digit code we sent to ',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: '$emailConfirmation',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff303840),
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),

                    heightBox(30.h),
                    DefaultInputField(
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Confirmation code',
                      controller: codeController,
                      validate: codeValidate(context),
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(15.h),
                    DefaultButton(
                        text: "Next",
                        onClick: () {
                          checkCodeValidateRequest(
                                  widget.userInfo.email!, codeController.text)
                              .then((value) {
                            log("# code :$value");
                            if (value == false) {
                              pinCodeAlertDialog(context);
                            } else {
                              newUserModel = widget.userInfo;
                              navigateTo(
                                  context,
                                  MenaTerms(
                                    userInfo: newUserModel!,
                                  ));
                            }
                          });
                        }),
                    heightBox(15.h),
                    DefaultButton1(
                        backColor: Colors.white,
                        borderColor: Color(0xff999B9D),
                        text: "I haven't received the code",
                        titleColor: Color(0xff303840),
                        onClick: () {
                          resendAlertDialog(context, () {


                            resetPassRequest(widget.userInfo.email!)
                                .then((value) {
                              if (value!) {
                                log("#value of reset :$value");
                                newUserModel = widget.userInfo;

                                navigateTo(
                                    context,
                                    ConfirmationCodeEmail(
                                      userInfo: newUserModel!,
                                    ));
                              } else {}
                            });
                            Navigator.of(context);
                          });
                        }),
                    heightBox(365.h),
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
            'We\'ve sent the confirmation code',
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
    ));
  }
}
