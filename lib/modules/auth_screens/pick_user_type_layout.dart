import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_state.dart';
import 'package:mena/modules/auth_screens/sign_up_screen.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';

class PickUserTypeLayout extends StatelessWidget {
  const PickUserTypeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Image.asset(
              'assets/back.png', // Replace with your image path
              scale: 3,
              alignment: Alignment.centerRight, // Adjust the height as needed
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 18,right: 250),
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/json/login-and-sign-up.json', height: 0.15.sh),
                    heightBox(10.h),
                    Text(
                      'Please select your user type:',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840)
                      ),
                    ),
                    heightBox(10.h),
                    Text(
                      'Once chosen, it cannot be altered later',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              heightBox(30.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Professional",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Professional');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Professional',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  ProfessionalAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Facility",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Facility');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Facility',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  FacilityAlertDialog(),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: SelectorButton(
                              //         title: "Facility",
                              //         onClick: () {
                              //           authCubit.updateSelectedUserType('Facility');
                              //         },
                              //         customHeight: 40.h,
                              //         customRadius: defaultRadiusVal,
                              //         isSelected: authCubit.selectedSignupUserType == 'facility',
                              //       ),
                              //     ),
                              //     widthBox(10.w),
                              //     FacilityAlertDialog(),
                              //   ],
                              // ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Government authority",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Government authority');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Government authority',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  GovernmentauthorityAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: " VIP Member",
                                      onClick: () {
                                        authCubit.updateSelectedUserType(' VIP Member');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == ' VIP Member',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  VIPMemberAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Student Professional",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Student Professional');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Student Professional',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  StudentProfessionalAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Community Members",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Community Members');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Community Members',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  CommunityMembersAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: "Children",
                                      onClick: () {
                                        authCubit.updateSelectedUserType('Children');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'Children',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  ChildrenAlertDialog(),
                                ],
                              ),
                              heightBox(20.h),
                              DefaultButton(
                                backColor: Color(0xff0077FF),
                                  text: getTranslatedStrings(context).next,
                                  width: double.maxFinite,
                                  height: 40.h,
                                  radius: 10.r,
                                  fontSize: 12,
                                  onClick: () {
                                    navigateTo(
                                        context,
                                        SignUpScreen(
                                          type: authCubit.selectedSignupUserType,
                                        ));
                                  }),
                            ],
                          ),

                          /// sign up as student commented for now

                        ],
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        ));
  }
}

class ProfessionalAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          professionalAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> professionalAlertDialog(BuildContext context) async {
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
          title: Text("Professional User",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Select this option if you are a working professional or expert in your field. This category is suitable for individuals with specialized skills, qualifications, or expertise related to their profession."),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )
          ],
        );
      },
    );
  }
}
class FacilityAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          facilitylAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> facilitylAlertDialog(BuildContext context) async {
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
          title: Text("Facility User",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Select this option if you represent a business, organization, or facility, such as a company, medical clinic, gym, or community center. Facilities often have unique needs and access requirements."),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
  }
}
class GovernmentauthorityAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          governmentauthorityAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> governmentauthorityAlertDialog(BuildContext context) async {
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
          title: Text("Government Authority User",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Select this option if you represent a government entity, agency, or authority at any level, such as municipal, state, or federal. Government authorities often have specific roles, responsibilities, and access requirements"),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
  }
}
class  VIPMemberAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          vipMemberAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> vipMemberAlertDialog(BuildContext context) async {
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
          title: Text("VIP Member",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Select this option if you are a distinguished individual with special privileges, such as government officials, celebrities, business leaders, or individuals with significant influence. VIP members often have unique access and service requirements"),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
  }
}
class StudentProfessionalAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          studentProfessionalAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> studentProfessionalAlertDialog(BuildContext context) async {
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
          title: Text("University Student User",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Select this option if you are currently enrolled as a university or college student. This category is for individuals pursuing higher education"),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
  }
}
class CommunityMembersAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          communityMembersAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> communityMembersAlertDialog(BuildContext context) async {
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
          title: Text("Community Member",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Please select this option if you represent a category of community members not covered by other specific users in our user list. This section includes all individuals with diverse interests and needs in the community"),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
  }
}
class ChildrenAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          childrenAlertDialog(context);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color: Color(0xff999B9D),
        ));
  }
  Future<void> childrenAlertDialog(BuildContext context) async {
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
          title: Text("Children User",),
          titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          content: Text("Please select this option if you are a child or a parent/guardian registering on behalf of a child under the age of 18 Years , Children's accounts are subject to special privacy and safety measures"),
          contentTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff303840)
          ),
          actions: [
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'PNfont',
                        color: Color(0xff0077FF)
                    ),)),
            )],
        );
      },
    );
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
          showMyAlertDialog(context, 'Note', alertDialogContent: content,isTitleBold: true);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color:customColor?? newDarkGreyColor,
        ));
  }
}
