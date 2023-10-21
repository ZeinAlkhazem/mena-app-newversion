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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultOnlyLogoAppbar(
            withBack: true,
          ),
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
                      'Choose your account type:',
                      style: mainStyle(context, 15, isBold: true),
                    ),
                    heightBox(10.h),
                    Text(
                      'Once chosen, it cannot be altered later',
                      style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
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
                                      title: getTranslatedStrings(context).asProvider,
                                      onClick: () {
                                        authCubit.updateSelectedUserType('provider');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'provider',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  NoteWidget(
                                    content: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            'If you fall under any of the following categories - professional, facility, company, supplier, university, authority, or school …etc- you must choose ',
                                        style: mainStyle(
                                          context,
                                          12,
                                          color: newDarkGreyColor,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                          text: '\'Provider\'',
                                          style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.w700)),
                                    ])),
                                  )
                                ],
                              ),
                              heightBox(20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectorButton(
                                      title: getTranslatedStrings(context).asClient,
                                      onClick: () {
                                        authCubit.updateSelectedUserType('client');
                                      },
                                      customHeight: 40.h,
                                      customRadius: defaultRadiusVal,
                                      isSelected: authCubit.selectedSignupUserType == 'client',
                                    ),
                                  ),
                                  widthBox(10.w),
                                  NoteWidget(
                                    content: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Choose ',
                                        style: mainStyle(
                                          context,
                                          12,
                                          color: newDarkGreyColor,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                          text: '\'Client\'',
                                          style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.w700)),
                                      TextSpan(
                                        text:
                                            ' if you are a public user, patient, parent, job seeker, or seeking services or products, …etc.',
                                        style: mainStyle(
                                          context,
                                          12,
                                          color: newDarkGreyColor,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    ])),
                                  )
                                ],
                              ),

                              // DefaultContainer(
                              //   width: double.maxFinite,
                              //   childWidget: Padding(
                              //     padding: const EdgeInsets.all(14.0),
                              //     child: Center(
                              //       child: Text(
                              //         getTranslatedStrings(context).asProvider,
                              //         style: mainStyle(context, 12),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Text('dataaaaaaaaaaaaaaaaa'),
                              // // heightBox(20.h),
                              // DefaultButton(
                              //   text: getTranslatedStrings(context).asProvider,
                              //   width: double.maxFinite,
                              //   height: 40.h,
                              //   fontSize: 12,
                              //   onClick: () {
                              //     navigateTo(
                              //         context,
                              //         SignUpScreen(
                              //           type: 'provider',
                              //         ));
                              //   },
                              //   radius: 10.r,
                              // ),
                              // heightBox(7.h),
                              // Text(
                              //   getTranslatedStrings(context).providerDescription,
                              //   style: mainStyle(context, 12, color: mainBlueColor),
                              //   textAlign: TextAlign.center,
                              // )
                            ],
                          ),

                          /// sign up as student commented for now
                          // heightBox(2.h),
                          // Padding(
                          //   padding:
                          //   const EdgeInsets.all(8.0),
                          //   child: Column(
                          //     children: [
                          //       DefaultButton(
                          //           text: getTranslatedStrings(
                          //               context)
                          //               .asStudent,
                          //           width: double.maxFinite,
                          //           height: 40.h,
                          //           radius: 10.r,
                          //           fontSize: 12,
                          //           onClick: () {
                          //             navigateTo(
                          //                 context,
                          //                 SignUpScreen(
                          //                   type: 'student',
                          //                 ));
                          //           }),
                          //       heightBox(7.h),
                          //       Text(getTranslatedStrings(context).studentDescription,
                          //         style: mainStyle(context, 12,color: mainBlueColor),)
                          //     ],
                          //   ),
                          // ),
                          // heightBox(2.h),
                          // Column(
                          //   children: [
                          //     DefaultButton(
                          //         text: getTranslatedStrings(context).asClient,
                          //         width: double.maxFinite,
                          //         height: 40.h,
                          //         radius: 10.r,
                          //         fontSize: 12,
                          //         onClick: () {
                          //           navigateTo(
                          //               context,
                          //               SignUpScreen(
                          //                 type: 'client',
                          //               ));
                          //         }),
                          //     // heightBox(7.h),
                          //     // Text(
                          //     //   getTranslatedStrings(context).clientDescription,
                          //     //   style: mainStyle(context, 12, color: mainBlueColor),
                          //     //   textAlign: TextAlign.center,
                          //     // )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    DefaultButton(
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
                );
              },
            ),
          ),
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
          showMyAlertDialog(context, 'Note', alertDialogContent: content,isTitleBold: true);
        },
        child: Icon(
          Icons.info_outline,
          size: 20.sp,
          color:customColor?? newDarkGreyColor,
        ));
  }
}
