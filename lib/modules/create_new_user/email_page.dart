import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/models/api_model/register_model.dart';
import 'package:mena/models/api_model/user_info_model.dart';
import 'package:mena/modules/create_new_user/phone_page.dart';
import 'package:mena/modules/home_screen/cubit/home_screen_cubit.dart';
import 'package:mena/modules/splash_screen/route_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mena/core/main_cubit/main_cubit.dart' as mainCubit;
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/network/dio_helper.dart';
import '../../core/network/network_constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/my_models/create_user_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';
import 'confirmation_email_page.dart';

class EmailVer extends StatefulWidget {
  final CreateUserModel userInfo;

  const EmailVer({super.key, required this.userInfo});

 static EmailVer get(context) => BlocProvider.of(context);
  @override
  State<EmailVer> createState() => _EmailVerState();
}

class _EmailVerState extends State<EmailVer> {
  final emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  CreateUserModel? newUserModel;
  RegisterModel? registerModel;
  UserInfoModel? userinfoModel;
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
Future<void> userCacheProcessAndNavigate(BuildContext context) async {
    final TextEditingController smsCodeEditingController =
        TextEditingController();
    mainCubit.MainCubit.get(context).getUserInfo();
    if (registerModel != null) {
      saveCacheToken(registerModel!.data.token);
      print('the token isssssssssssss : ${registerModel!.data.token}');
      if (registerModel!.data.user.phoneVerifiedAt == null) {
        ///show otp alert dialog

        

      } else {
        navigateToAndFinishUntil(context, const RouteEngine());
      }
    }
  }


  Future<void> userRegister({
    required String fullName,
    required String email,
    required String userName,
    required String phone,
    required String? dateOfBirth,
    required String pass,
    required int? platformId,
    required List<int>? specialitiesList,
    // required int countryId,
    required BuildContext context,
  }) async {
    bool result = false;

    await MainDioHelper.postData(url: registerEnd, data: {
      'full_name': fullName,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'password': pass,
      'password_confirmation': pass,
      'specialities': specialitiesList.toString(),
      'platform_id': platformId,
      'date_of_birth': dateOfBirth,
      // 'country_id': countryId,
    }).then((value) async {
      logg('#### sign up response: $value');
      registerModel = RegisterModel.fromJson(value.data);
      userinfoModel = UserInfoModel.fromJson(value.data);
      mainCubit.MainCubit.get(context).userInfoModel = userinfoModel;
      print('userinfoModallllllll : ${userinfoModel}');
      
      await HomeScreenCubit.get(context)
        ..changeSelectedHomePlatform(
            registerModel?.data.user.platform?.id ??
                mainCubit.MainCubit.get(context).configModel!.data.platforms[0].id!
        );      userCacheProcessAndNavigate(context);
      // emit(SignUpSuccessState());
      // logg('#### sssssssssssssssssssssss: ${registerModel!.token}');
      // if (registerModel != null) {
      //   final prefs = await SharedPreferences.getInstance();
      //   print('token : ${registerModel!.data.token}');
      //   prefs.setString(Keys.keyToken, registerModel!.data.token);
      //   prefs.setString(
      //       Keys.keyUser, registerModel!.data.user.toJson().toString());
      // }
      // mainCubit.MainCubit.get(context).getUserInfo();
      // saveCacheToken(registerModel!.data.token);
      // if (value.statusCode.toString() == "200") {
      //   result = true;
      // } else {
      //   result = false;
      // }
      // if (value.statusCode.toString() == "200") {
      //   result = true;
      // } else {
      //   result = false;
      // }
      // if (userSignUpModel != null) {
      //   userCacheProcess(userSignUpModel!).then((value) => checkUserAuth().then(
      //           (value) =>
      //           navigateToAndFinishUntil(context, const MainAppMaterialApp())));
      //   // navigateToAndFinishUntil(context, MainAppMaterialApp());
      //
      // }
      ///
      /// cache process and navigate due to status
      ///
      // await HomeScreenCubit.get(context)
      //   ..changeSelectedHomePlatform(registerModel?.data.user.platform?.id ??
      //       mainCubit.MainCubit.get(context)
      //           .configModel!
      //           .data
      //           .platforms[0]
      //           .id!);
      // userCacheProcessAndNavigate(context);
      //
      // userCacheProcessAndNavigate(context);
      // emit(SignUpSuccessState());
    }).catchError((error) {
      logg(error.toString());
      // emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
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
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox(15.h),
                      Text(
                        'What\'s your email?',
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
                        "enter the email address where you can be contacted. This information will not be visible on your profile",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                            fontWeight: FontWeight.w500),
                      ),
                      heightBox(30.h),
                      DefaultInputField(
                        onFieldChanged: (text) {
                          emailConfirmation = text;
                        },
                        fillColor: Color(0xffF2F2F2),
                        focusedBorderColor: Color(0xff0077FF),
                        unFocusedBorderColor: Color(0xffC9CBCD),
                        label: 'Email',
                        controller: emailController,
                        validate: emailValidateSignUp(context),
                        labelTextStyle: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PNfont',
                            color: Color(0xff999B9D)),
                      ),
                      heightBox(15.h),
                      Text(
                        textAlign: TextAlign.start,
                        "We may send you Email notifications for security and login-related purposes",
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
                            if (formKey.currentState!.validate()) {
                              newUserModel = widget.userInfo;
                              newUserModel!.email = emailController.text;

                              CreateUserModel userModel = newUserModel!;
                              userRegister(
                                email: userModel.email!,
                                pass: userModel.password!,
                                dateOfBirth: userModel.dateOfBirth!,
                                fullName: userModel.fullName!,
                                userName: userModel.userName!,
                                specialitiesList: userModel.specialitList!,
                                phone: userModel.phone ?? "",
                                platformId: userModel.platformId!,
                                // countryId: userModel.countryId!,
                                context: context,
                              ).then((value) {
                                  resetPassRequest(emailController.text)
                                      .then((value) {

                                    if(value!){
                                      log("#value of reset :$value");
                                      newUserModel = widget.userInfo;
                                      newUserModel!.email = emailController.text;
                                      navigateTo(
                                          context,
                                          ConfirmationCodeEmail(
                                            userInfo: newUserModel!,
                                          ));
                                    }else{

                                    }

                                  });
                                
                              });
                            }
                          }),
                      heightBox(15.h),
                      DefaultButton1(
                          backColor: Colors.white,
                          borderColor: Color(0xff999B9D),
                          text: "Sign up with mobile number",
                          titleColor: Color(0xff303840),
                          onClick: () {
                            navigateTo(context, PhoneNumberVer());
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
            ),
          );
        },
      ),
    );
  }
}