import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/my_models/create_user_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';
import 'email_page.dart';

String? userName = "";

class UserName extends StatefulWidget {
  final CreateUserModel userInfo;

  const UserName({super.key, required this.userInfo});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final userNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var inController = TextEditingController();
  CreateUserModel? newUserModel;

  // Function to check the username availability through an API
  // Future<bool> checkUsernameAvailability(String username) async {
  //   final apiUrl = Uri.parse("http://menaaii.com/api/v1/checkusername");
  //   final response = await http.post(apiUrl, body: {"username": username});
  //
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     // Check the response and return true or false based on availability
  //     return responseData["available"];
  //   } else {
  //     // Handle API request errors
  //     throw Exception('Failed to check username availability');
  //   }
  // }

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
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox(15.h),
                      Text(
                        'Create a username',
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
                        "Add a username of your choice, or you can opt for our suggested username. You have the flexibility to change it whenever you like",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                            fontWeight: FontWeight.w500),
                      ),
                      heightBox(30.h),
                      DefaultInputField29(
                        onFieldChanged: (text) {
                          userName = text;
                        },
                        fillColor: Color(0xffF2F2F2),
                        focusedBorderColor: Color(0xff0077FF),
                        unFocusedBorderColor: Color(0xffC9CBCD),
                        label: 'Username',
                        controller: userNameController,
                        validate: userNameValidateSignUp1(context),
                        // asyncValidator: userNameValidateSignUp,
                        autoValidateMode: AuthCubit.get(context).autoValidateMode,
                        labelTextStyle: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PNfont',
                            color: Color(0xff999B9D)),
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            "assets/new_icons/close.svg",
                            fit: BoxFit.contain,
                            width: 20.w,
                            height: 20.h,
                            color: Color(0xff999B9D),
                          ),
                          onPressed: () {
                            userNameController.clear();
                          },
                        ),
                      ),
                      heightBox(15.h),
                      DefaultButtonUserName(
                          text: "Next",
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              newUserModel = widget.userInfo;
                              newUserModel!.userName = userNameController.text;
                              navigateTo(
                                  context,
                                  EmailVer(
                                    userInfo: newUserModel!,
                                  ));
                            }
                          },
                        validator: () async {
                          bool isValid = await userNameValidateSignUp(userNameController.text);
                          if (!isValid) {
                            // Display an error message or handle the validation failure.
                            return false;
                          }
                          return true; // Validation passed
                        },
                          ),
                      heightBox(400.h),
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
            ),
          );
        },
      ),
    );
  }
}