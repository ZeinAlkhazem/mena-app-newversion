import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/main_cubit/main_cubit.dart' as mainCubit;
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/config_model.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/home_screen/sections_widgets/sections_widgets.dart';
import 'package:mena/modules/main_layout/main_layout.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/validators.dart';
import '../../../core/dialogs/dialogs_page.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/categories_model.dart';
import '../../../models/api_model/plans_model.dart';
import '../../../models/api_model/provider_types.dart';
import '../../../models/api_model/register_model.dart';
import '../../home_screen/cubit/home_screen_cubit.dart';
import '../../splash_screen/route_engine.dart';
import '../sign_in_screen.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  TextEditingController newPassCont = TextEditingController();
  CategoriesModel? platformCategory;
  MenaPlatform? selectedPlatform;
  String? emailConfirmation;

  List<MenaCategory>? selectedSpecialities;
  MenaCategory selectedMenaCategory = MenaCategory(id: -1);
  MenaCategory selectedSubMenaCategory = MenaCategory(id: -1);
  ProviderTypeItem selectedProviderType = ProviderTypeItem(id: -1);
  String selectedSignupUserType = 'provider';

  String? phone;
  String? resetPassPhone;
  String otpText = '';
  String passOtpText = '';
  RegisterModel? registerModel;
  AutovalidateMode? autoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode? resetPassAutoValidateMode = AutovalidateMode.disabled;

  bool confirmPassVisible = false;
  bool passVisible = false;

  ///
  /// filters functions
  ///
  void resetCategoriesFilters() {
    updateSelectedSpecialities([]);
    updateSelectedMenaCategory(MenaCategory(id: -1));
    updateSelectedSubMenaCategory(MenaCategory(id: -1));
  }

  void updateOtpVal(String val){
    otpText=val;
  }



  void logout(BuildContext context) {
    removeToken();
    mainCubit.MainCubit.get(context).removeUserModel();
    navigateToAndFinishUntil(context, SignInScreen());
  }

  void updateSelectedUserType(String val) {
    selectedSignupUserType = val;
    emit(SignupUserTypeUpdated());
  }

  void updateSelectedPlatform(MenaPlatform platform, bool updateProviderTypes) {
    selectedPlatform = platform;

    /// when platform changed reset all
    resetCategoriesFilters();

    ///
    if (updateProviderTypes) {
      getPlatformCategories(selectedPlatform!.id.toString());
    }
    emit(SelectedPlatformUpdated());
  }

  void updateSelectedMenaCategory(MenaCategory menaCategory) {
    selectedMenaCategory = menaCategory;

    ///
    ///
    /// when category changed reset sub and specialists
    ///
    ///
    ///
    updateSelectedSubMenaCategory(MenaCategory(id: -1));
    // updateSelectedSpecialities([]);
    if (selectedMenaCategory.childs != null) {
      updateSelectedSubMenaCategory(selectedMenaCategory.childs![0]!);
    }
    emit(SelectedPlatformUpdated());
  }

  void updateSelectedSubMenaCategory(MenaCategory menaCategory) {
    selectedSubMenaCategory = menaCategory;

    ///
    ///
    /// when sub category changed reset  specialists
    ///
    ///
    ///
    emit(SelectedPlatformUpdated());
  }

  void updateSelectedSpecialities(List<MenaCategory> values) {
    // selectedSpecialities?.clear();
    // emit(SelectedPlatformUpdated());
    selectedSpecialities = values;
    // if (updateProviderTypes) {
    //   getPlatformCategories(selectedPlatform!.id.toString());
    // }
    emit(SelectedPlatformUpdated());
  }

  /// end filters functions
  ///
  void updatePhoneNum(String? val) {
    if (val != null) {
      phone = val;
    }
  }

  void updateResetPassPhoneNum(String? val) {
    if (val != null) {
      resetPassPhone = val;
    }
  }

  void togglePassVisibilityFalse() {
    passVisible = false;
    confirmPassVisible = false;
    emit(PassVisibilityChanged());
  }

  void toggleVisibility(String val) {
    if (val == 'pass') {
      passVisible = !passVisible;
    } else if (val == 'confirmPass') {
      confirmPassVisible = !confirmPassVisible;
    }
    emit(PassVisibilityChanged());
  }

  void toggleResetPassAutoValidate(bool val) {
    if (val == true) {
      resetPassAutoValidateMode = AutovalidateMode.always;
    } else {
      resetPassAutoValidateMode = AutovalidateMode.disabled;
    }
    emit(ChangeAutoValidateModeState());
  }

  void toggleAutoValidate(bool val) {

    if (val == true) {
      autoValidateMode = AutovalidateMode.always;
    } else {
      autoValidateMode = AutovalidateMode.disabled;
    }
    emit(ChangeAutoValidateModeState());
  }

  void changeSelectedProviderType(ProviderTypeItem val) {
    selectedProviderType = val;
    emit(ChangeAutoValidateModeState());
  }

  Future<void> userRegister({
    required String fullName,
    required String email,
    required String userName,
    required String? registrationNumCont,
    required String pass,
    required String? providerType,
    required BuildContext context,
  }) async {
    emit(AuthLoadingState());
    MainDioHelper.postData(url: registerEnd, data: {
      'full_name': fullName,
      'email': email,
      'user_name': userName,
      'password': pass,
      'password_confirmation': pass,
      'user_type': providerType ?? '-1',
      'phone': phone,
      'specialities': selectedSpecialities!.map((e) => e.id).toList().toString(),
      'platform_id': selectedPlatform!.id.toString(),
      'registration_number': registrationNumCont.toString(),
    }).then((value) async {
      logg('sign up response: $value');
      registerModel = RegisterModel.fromJson(value.data);
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
      await HomeScreenCubit.get(context)
        ..changeSelectedHomePlatform(
            registerModel?.data.user.platform?.id ??
                mainCubit.MainCubit.get(context).configModel!.data.platforms[0].id!
        );      userCacheProcessAndNavigate(context);

      userCacheProcessAndNavigate(context);
      emit(SignUpSuccessState());
    }).catchError((error) {
      logg(error.response.toString());
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
  }

  Future<void> getPlatformCategories(String platformId) async {
    platformCategory = null;
    emit(AuthGetPlatformCategoriesLoadingState());
    await MainDioHelper.getData(url: '${platformCategoriesEnd}/${platformId.toString()}', query: {})
        .then((value) async {
      logg('getProviderTypes response: $value');
      platformCategory = CategoriesModel.fromJson(value.data);

      if (platformCategory!.data.isNotEmpty) {
        updateSelectedMenaCategory(platformCategory!.data[0]);
      } else {
        updateSelectedMenaCategory(MenaCategory(id: -1));
      }
      // if (platformCategory!.childs!.isNotEmpty) {
      //   changeSelectedProviderType(platformCategory!.data[0]);
      // }

      emit(SignUpSuccessState());
    }).catchError((error) {
      logg(error.response.toString());
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
  }

  Future<void> userLogin({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    emit(AuthLoadingState());
    MainDioHelper.postData(url: loginEnd, data: {
      'email': email,
      'password': pass,
    }).then((value) async {
      logg('sign up response: $value');
      registerModel = RegisterModel.fromJson(value.data);
      // if (userSignUpModel != null) {
      //   userCacheProcess(userSignUpModel!).then((value) => checkUserAuth().then(
      //           (value) =>
      //           navigateToAndFinishUntil(context, const MainAppMaterialApp())));
        // navigateToAndFinishUntil(context, MainAppMaterialApp());

      // }
      /// cache process and navigate due to status
      ///
      ///
      await HomeScreenCubit.get(context)
        ..changeSelectedHomePlatform(
            registerModel?.data.user.platform?.id ??
                mainCubit.MainCubit.get(context).configModel!.data.platforms[0].id!
        );
      userCacheProcessAndNavigate(context);
      emit(SignUpSuccessState());
    }).catchError((error, stack) {
      logg("${error.toString()}");

      hasError = true;
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
    DefaultInputField();
  }

  Future<bool> submitResetPass({
    required String pass,
    required String phone,
    required String code,
    required BuildContext context,
  }) async {
    log("# password : $pass");
    log("# phone : $phone");
    log("# code : $code");

    emit(SubmittingResetPass());

    bool finalStatue = false;

    await MainDioHelper.postData(url: submitResetPassEnd, data: {
      'phone': phone,
      'code': code,
      'password': pass,
      'password_confirmation': pass,
    }).then((value) {
      logg('Password reset successfully: ${value}');
      logg('Password status code: ${value.statusCode}');

      /// cache process and navigate due to status
      ///
      ///
      if (value.statusCode.toString() == '200') {
        finalStatue = true;
      } else {
        finalStatue = false;
      }
      emit(SignUpSuccessState());
    }).catchError((error) {
      logg(error.response.toString());
      emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
      finalStatue = false;
    });
    return finalStatue;
  }

  Future<void> resetPasswordRequestOtp({
    required BuildContext context,
  }) async {
    var formKey = GlobalKey<FormState>();
    var inController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.0.h),
              child: const DefaultOnlyLogoAppbar1(
                withBack: true,
                title: "Forget Password",
                // title: 'Back',
              ),
            ),
            body: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                // TODO: implement listener
                log("# new state : $state");
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
                          Divider(),
                          heightBox(15.h),
                          Text(
                            'Enter phone number or email or username',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PNfont',
                              color: Color(0xff303840),
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          heightBox(5.h),
                          Text(
                            textAlign: TextAlign.start,
                            "Can't reset your password?",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff0077FF),
                                fontWeight: FontWeight.w900),
                          ),
                          heightBox(10.h),
                          DefaultInputField(
                            fillColor: Color(0xffF2F2F2),
                            focusedBorderColor:  Color(0xff0077FF),
                            unFocusedBorderColor: Color(0xffC9CBCD),
                            label: 'Username, email or mobile number',
                            onFieldChanged: (text) {
                               emailConfirmation = text;
                            },
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                'assets/grayX.svg',
                                color: Color(0xff999B9D),
                                width: 30.w,
                                height: 30.h,
                                alignment: Alignment.centerRight,
                              ),
                              onPressed: () {
                                inController.clear();
                              },
                            ),
                            labelTextStyle: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PNfont',
                                color: Color(0xff999B9D)),
                            controller: inController,
                            validate: normalInputValidate1,
                          ),
                          heightBox(10.h),
                          // Text(
                          //   hasError
                          //       ? "Check your username, mobile or email address  and try again"
                          //       : "",
                          //   style: TextStyle(
                          //       fontSize: 13.0,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'PNfont',
                          //       color: Color(0xffE72B1C)),
                          // ),
                          heightBox(480.h),
                          state is ProceedingToResetPass
                              ? const DefaultLoaderGrey()
                              : Row(
                            children: [
                              Expanded(
                                child: DefaultButton(
                                  text: "Find Account",
                                  onClick: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (formKey.currentState!
                                        .validate()) {
                                      resetPassRequest(inController.text)
                                          .then((value) {
                                        log("#value of reset :$value");
                                        if (value == false) {
                                          showUserNameErrorDialog(
                                              context);
                                        } else {
                                          showConfirmationDialog(context);
                                          pinCode(
                                              context: context,
                                              phone: inController.text);
                                        }
                                      });
                                    } else {}
                                  },
                                ),
                              )

                            ],
                          ),
                          state is VerifyingNumErrorState
                              ? Text(
                            "Check your username, mobile or email address  and try again",
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PNfont',
                                color: Color(0xffE72B1C)),
                            textAlign: TextAlign.center,
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> userCacheProcessAndNavigate(BuildContext context) async {
    mainCubit.MainCubit.get(context).getUserInfo();
    if (registerModel != null) {
      print('token in userCacheProcess : ${registerModel!.data.token}');
      saveCacheToken(registerModel!.data.token);
      print('the token isssssssssssss : ${registerModel!.data.user.fullName}');
      if (registerModel!.data.user.phoneVerifiedAt == null) {
        ///show otp alert dialog
        // showConfirmationDialog(context);



      } else {
        navigateToAndFinishUntil(context, const RouteEngine());
      }
    }
  }

  Future<bool> verifyPhoneNumber(String currentPhone) async {
    emit(VerifyingNumState());
    await MainDioHelper.postData(url: verifyCodeEnd, data: {
      'phone': currentPhone,
      'code': otpText,
    }).then((value) {
      logg('Verify num response: $value');
      return true;
    }).catchError((error) {
      logg(error.response.toString());
      emit(VerifyingNumErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
    return false;
  }

  ///
  ///
  ///
  ///
  Future<bool> resetPassRequest(String input) async {
    emit(ProceedingToResetPass());
    bool result = false;
    await MainDioHelper.postData(url: requestResetPassOtpEnd, data: {
      'phone': input,
    }).then((value) {
      logg('Verify num response: $value');
      result =  true;
      emit(VerifyingNumState());
    }).catchError((error) {
      logg(error.response.toString());
      emit(VerifyingNumErrorState(getErrorMessageFromErrorJsonResponse(error)));
      result =  false;
    });
    return result;
  }

  Future showResetPassPopUp(
      BuildContext context, String phone, String identity) {
    final TextEditingController smsPassCodeEditingController =
    TextEditingController();
    var formKey = GlobalKey<FormState>();
    var newPassCont = TextEditingController();
    var newPassConfirmCont = TextEditingController();
    toggleResetPassAutoValidate(false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.0.h),
              child: const DefaultOnlyLogoAppbar1(
                withBack: true,
                title: "Create a new password",
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
                          Divider(),
                          heightBox(15.h),
                          Text(
                            'Please set a password that includes at least 8 letters and numbers. You will use this password to sign into your account',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PNfont',
                              color: Color(0xff303840),
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          heightBox(5.h),
                          heightBox(10.h),
                          DefaultInputField(
                            fillColor: Color(0xffF2F2F2),
                            focusedBorderColor: Color(0xff0077FF),
                            unFocusedBorderColor: Color(0xffC9CBCD),
                            label: 'New password',
                            controller: newPassCont,
                            labelTextStyle: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PNfont',
                                color: Color(0xff999B9D)),
                            validate: passwordValidateSignUp(context),
                          ),
                          heightBox(10.h),
                          DefaultInputField(
                            fillColor: Color(0xffF2F2F2),
                            focusedBorderColor: Color(0xff0077FF),
                            unFocusedBorderColor: Color(0xffC9CBCD),
                            controller: newPassConfirmCont,
                            label: 'Confirm new password',
                            labelTextStyle: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PNfont',
                                color: Color(0xff999B9D)),
                            validate: (value) {
                              return passwordMatchValidator(newPassCont.text, value!);
                            },
                          ),
                          heightBox(410.h),
                          state is ProceedingToResetPass
                              ? const DefaultLoaderGrey()
                              : Row(
                            children: [
                              Expanded(
                                child: DefaultButton(
                                    text: "Done",
                                    onClick: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      toggleResetPassAutoValidate(true);

                                      toggleResetPassAutoValidate(true);
                                      log("# password : ${newPassCont.text}");
                                      log("# password confirm : ${newPassConfirmCont.text}");
                                      if (newPassCont.text !=
                                          newPassConfirmCont.text) {
                                        showMessageDialog(
                                            context: context,
                                            message:
                                            "The two passwords do not match");
                                      } else if (newPassCont.text.length <
                                          6) {
                                        logg('password must be 6 digits');
                                        showMessageDialog(
                                            context: context,
                                            message:
                                            "password must be 6 digits");
                                      } else {
                                        if (formKey.currentState!
                                            .validate()) {
                                          log("# code : $identity");
                                          var result =
                                          await submitResetPass(
                                              pass: newPassCont.text,
                                              context: context,
                                              phone: phone,
                                              code: identity,);

                                          if (result) {
                                            showMessageDialog(
                                                context: context,
                                                message:
                                                "Password reset Successfully");
                                            navigateTo(
                                                context, SignInScreen());
                                          } else {
                                            pinCodeAlertDialog(context);
                                          }
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> pinCode(
      {required BuildContext context, required String phone}) async {
    var formKey = GlobalKey<FormState>();
    var inController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar:PreferredSize(
              preferredSize: Size.fromHeight(56.0.h),
              child: const DefaultOnlyLogoAppbar1(
                withBack: true,
                title: "Confirm your account",
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
                          Divider(),
                          heightBox(15.h),
                          Text(
                            'We sent a code to your email. Enter that code to confirm your account',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PNfont',
                              color: Color(0xff303840),
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          heightBox(5.h),
                          heightBox(10.h),
                          DefaultInputField(
                            fillColor: Color(0xffF2F2F2),
                            focusedBorderColor: Color(0xff0077FF),
                            unFocusedBorderColor: Color(0xffC9CBCD),
                            label: 'Enter code',
                            labelTextStyle: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'PNfont',
                                color: Color(0xff999B9D)),
                            controller: inController,
                            validate: normalInputValidate1,
                          ),
                          heightBox(10.h),
                          heightBox(470.h),
                          state is ProceedingToResetPass
                              ? const DefaultLoaderGrey()
                              : Row(
                            children: [
                              Expanded(
                                child: DefaultButton(
                                  text: "Continue",
                                  onClick: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    toggleResetPassAutoValidate(true);

                                    if (inController.text.length < 6) {
                                      logg('otp must be 6 digits');
                                    } else {
                                      if (formKey.currentState!
                                          .validate()) {
                                        checkCodeValidateRequest(
                                            phone, inController.text)
                                            .then((value) {
                                          log("# code :$value");
                                          if (value == false) {
                                            pinCodeAlertDialog(context);
                                          } else {
                                            showResetPassPopUp(
                                              context,
                                              phone,
                                              inController.text,
                                            );
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          // state is VerifyingNumErrorState
                          //     ? Text(
                          //   "Check your username, mobile or email address  and try again",
                          //   style: TextStyle(
                          //       fontSize: 13.0,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'PNfont',
                          //       color: Color(0xffE72B1C)),
                          //   textAlign: TextAlign.center,
                          // )
                          //     : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  Future<bool?> checkCodeValidateRequest(String email, String code) async {
    log("# code is : $code");
    log("# email is : $email");
    Map<String, dynamic> body = {
      'email': email,
      'code': code,
    };
    bool resultState = false;
    await MainDioHelper.postData(url: verifyCodeResetPassword, data: body)
        .then((value) {
      logg('Verify num response Reset Password: $value');
      resultState = true;
      return true;
    }).catchError((error) {
      logg("# Error  : ${error.response.toString()}");
      emit(VerifyingNumErrorState(getErrorMessageFromErrorJsonResponse(error)));
      resultState = false;
      return false;
    });
    return resultState;
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
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
            'Code was sent',
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
    ));
  }
}
