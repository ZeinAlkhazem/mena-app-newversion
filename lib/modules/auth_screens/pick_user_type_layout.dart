import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/dialogs/dialogs_page.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_state.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:mena/modules/auth_screens/sign_up_screen.dart';
import 'package:mena/modules/create_new_user/select_country.dart';
import 'package:mena/modules/home_screen/home_screen.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/network/dio_helper.dart';
import '../../core/network/network_constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/config_model.dart';
import '../../models/my_models/create_user_model.dart';
import '../../models/my_models/user_type_info_model.dart';
import '../create_new_user/select_expertise.dart';
import '../create_new_user/select_platform.dart';
import 'package:http/http.dart' as http;

import '../create_new_user/username_page.dart';

String? emailConfirmation = "";
String? phoneConfirmation = '';

class PickUserTypeLayout extends StatefulWidget {
  const PickUserTypeLayout({Key? key}) : super(key: key);

  @override
  State<PickUserTypeLayout> createState() => _PickUserTypeLayoutState();
}

class _PickUserTypeLayoutState extends State<PickUserTypeLayout> {
  List<UserTypeInfoModel> userTypes = [];
  bool isLoading = true;
  UserTypeInfoModel? userTypeSelected;

  List userTypeDescriptionList = [
    UserTypeInfoModel(
        id: 0,
        title: "Professional",
        description:
            "Select this option if you are a working professional or expert in your field. This category is suitable for individuals with specialized skills, qualifications, or expertise related to their profession."),
    UserTypeInfoModel(
        id: 1,
        title: "Facility",
        description:
            "Select this option if you represent a business, organization, or facility, such as a company, medical clinic, gym, or community center. Facilities often have unique needs and access requirements."),
    UserTypeInfoModel(
        id: 2,
        title: "Government Authority",
        description:
            "Select this option if you represent a government entity, agency, or authority at any level, such as municipal, state, or federal. Government authorities often have specific roles, responsibilities, and access requirements"),
    UserTypeInfoModel(
        id: 3,
        title: "VIP Member",
        description:
            "Select this option if you are a distinguished individual with special privileges, such as government officials, celebrities, business leaders, or individuals with significant influence. VIP members often have unique access and service requirements"),
    UserTypeInfoModel(
        id: 4,
        title: "University Student",
        description:
            "Select this option if you are currently enrolled as a university or college student. This category is for individuals pursuing higher education"),
    UserTypeInfoModel(
        id: 5,
        title: "Community Member",
        description:
            "Please select this option if you represent a category of community members not covered by other specific users in our user list. This section includes all individuals with diverse interests and needs in the community"),
    UserTypeInfoModel(
        id: 6,
        title: "Children",
        description:
            "Please select this option if you are a child or a parent/guardian registering on behalf of a child under the age of 18 Years , Children's accounts are subject to special privacy and safety measures"),
  ];

  // Fetch data from the API
  Future<void> _fetchUserTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://menaaii.com/api/v1/provider_types'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> userTypesData = responseData['data']['user_types'];
        log("# user type Data :$userTypesData");

        setState(() {
          userTypes = userTypesData
              .map((data) => UserTypeInfoModel.fromJson(data))
              .toList();
          isLoading = false;
        });
        log("# user type :$userTypes");
      } else {
        // Handle errors, e.g., show a snackbar or an error message
        print("Error fetching user types: ${response.statusCode}");
      }
    } catch (error) {
      // Handle errors, e.g., show a snackbar or an error message
      print("Error fetching user types: $error");
    }
  }

  void displayAlertDialogBasedOnUserType(
      BuildContext context, String userType) async {
    log("# user type selection :$userType");

    switch (userType) {
      case 'Professional User ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[0].title,
            description: userTypeDescriptionList[0].description);
      case 'Facility User ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[1].title,
            description: userTypeDescriptionList[1].description);
      case 'Government Authority User':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[2].title,
            description: userTypeDescriptionList[2].description);
      case 'VIP Member ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[3].title,
            description: userTypeDescriptionList[3].description);
      case 'University Student User ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[4].title,
            description: userTypeDescriptionList[4].description);
      case 'Community Member ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[5].title,
            description: userTypeDescriptionList[5].description);
      case 'Children User ':
        return showDescriptionUserTypeAlertDialog(
            context: context,
            title: userTypeDescriptionList[6].title,
            description: userTypeDescriptionList[6].description);
      // Add cases for other user types
      default:
        // Handle the case for unknown user types or show a default AlertDialog
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Unknown User Type'),
              content: Text('This user type is not recognized.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserTypes();
  }

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/back.png', // Replace with your image path
            scale: 3,
            alignment: Alignment.centerRight,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 18, right: 250),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'PNfont',
                color: Color(0xff152026),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return isLoading
                  ? const DefaultLoaderGrey()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/json/login-and-sign-up.json',
                            height: 0.15.sh),
                        heightBox(10.h),
                        Text(
                          'Please select your user type:',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                          ),
                        ),
                        heightBox(10.h),
                        Text(
                          'Once chosen, it cannot be altered later',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PNfont',
                            color: Color(0xff999B9D),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: userTypes.map((userType) {
                              return Column(
                                children: [
                                  heightBox(20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SelectorButton(
                                          title: userType.title!,
                                          onClick: () {
                                            authCubit.updateSelectedUserType(
                                                userType.title!);
                                            setState(() {
                                              userTypeSelected = userType;
                                            });
                                          },
                                          customHeight: 40.h,
                                          customRadius: defaultRadiusVal,
                                          isSelected: authCubit
                                                  .selectedSignupUserType ==
                                              userType.title,
                                        ),
                                      ),
                                      widthBox(10.w),
                                      // Add your AlertDialog widget for this user type here
                                      InfoWidget(btnClick: () {
                                        displayAlertDialogBasedOnUserType(
                                            context, userType.title!);
                                      }),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Column(
                            children: [
                              DefaultButton(
                                  backColor: Color(0xff0077FF),
                                  text: getTranslatedStrings(context).next,
                                  width: double.maxFinite,
                                  height: 40.h,
                                  radius: 10.r,
                                  fontSize: 12,
                                  onClick: () {
                                    if (userTypeSelected!.title ==
                                        'Professional User ') {
                                      navigateTo(
                                          context,
                                          CountryPage(userTypeInfoModel: userTypeSelected!)
                                          // SelectPlatform(
                                          //   userTypeInfoModel:
                                          //       userTypeSelected!,
                                          // )
                                      
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                        // ...
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    this.customColor,
    required this.btnClick,
  });

  final Color? customColor;
  final VoidCallback btnClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: btnClick,
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: customColor ?? newDarkGreyColor,
        ));
  }
}

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
    required this.content,
    this.customColor,
  });

  final Widget content;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showMyAlertDialog(context, 'Note',
              alertDialogContent: content, isTitleBold: true);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: customColor ?? newDarkGreyColor,
        ));
  }
}

class YourPassword extends StatefulWidget {
  final CreateUserModel userInfo;

  const YourPassword({super.key, required this.userInfo});

  @override
  State<YourPassword> createState() => _YourPasswordState();
}

class _YourPasswordState extends State<YourPassword> {
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  CreateUserModel? newUserModel;

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
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox(15.h),
                      Text(
                        'Create a password',
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
                        "Create a password with at least 8 letters or numbers. It should be something others can\'t guess",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'PNfont',
                            color: Color(0xff303840),
                            fontWeight: FontWeight.w500),
                      ),
                      heightBox(30.h),
                      DefaultInputField(
                        // onFieldChanged: {},
                        fillColor: Color(0xffF2F2F2),
                        focusedBorderColor: Color(0xff0077FF),
                        unFocusedBorderColor: Color(0xffC9CBCD),
                        label: 'Password',
                        validate: passwordValidateSignUp(context),
                        controller: passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Color(0xffF2F2F2),
                          ),
                          onPressed: () {},
                        ),
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
                            if (formKey.currentState!.validate()) {
                              newUserModel = widget.userInfo;
                              newUserModel!.password = passwordController.text;
                              navigateTo(
                                  context,
                                  YourBirthday(
                                    userInfo: newUserModel!,
                                  ));
                            }
                          }),
                      heightBox(415.h),
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

class YourBirthday extends StatefulWidget {
  final CreateUserModel userInfo;

  const YourBirthday({super.key, required this.userInfo});

  @override
  State<YourBirthday> createState() => _YourBirthdayState();
}

class _YourBirthdayState extends State<YourBirthday> {
  final birthDayController = TextEditingController();

  CreateUserModel? newUserModel;

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
                      'What\'s your birthday?',
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
                      "You can use your own birthday, even if this account is for a business, or another purpose. Your birthday won't be visible to anyone unless you choose to share it",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                          fontWeight: FontWeight.w500),
                    ),
                    heightBox(10.h),
                    DefaultInputField(
                      onTap: () async {
                        // buildCupertinoDatePicker(context);
                        var datePicked = await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(3000),
                          dateFormat: "dd-MMMM-yyyy",
                          locale: DateTimePickerLocale.en_us,
                          looping: true,
                        );
                        log("# date selected  :$datePicked");
                        setState(() {
                          birthDayController.text =
                              datePicked.toString().substring(0, 10);
                        });
                      },
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'October 11,2023',
                      controller: birthDayController,
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(30.h),
                    heightBox(15.h),
                    DefaultButton(
                        text: "Next",
                        onClick: () {
                          newUserModel = widget.userInfo;
                          newUserModel!.dateOfBirth = birthDayController.text;
                          navigateTo(
                              context,
                              UserName(
                                userInfo: newUserModel!,
                              ));
                        }),
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
          );
        },
      ),
    );
  }
}












