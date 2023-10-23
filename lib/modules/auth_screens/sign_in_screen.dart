import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/auth_screens/pick_user_type_layout.dart';
import 'package:mena/modules/auth_screens/sign_up_screen.dart';

import '../../core/constants/validators.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../main_layout/main_layout.dart';

import '../messenger/messenger_layout.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static String routeName = 'signInScreen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // TODO: implement initState
    logg('sign in screen init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailCont = TextEditingController();
    var passCont = TextEditingController();
    var authCubit = AuthCubit.get(context)
      ..toggleAutoValidate(false)
      ..togglePassVisibilityFalse();

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is AuthErrorState) {
                    // showMyAlertDialog(context, getTranslatedStrings(context).alert,
                    //     alertDialogContent: Text(
                    //       getTranslatedStrings(context).someThingWentWrong,
                    //       textAlign: TextAlign.center,
                    //     ));
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxHeight: 0.7.sh),
                        child: Column(
                          children: [
                            heightBox(0.1.sh),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const Expanded(child: SizedBox()),
                                SvgPicture.asset(
                                  'assets/svg/mena8.svg',
                                  height: 30.h,
                                  // cacheColorFilter: false,
                                  // color: Colors.blue,
                                ),
                                // Expanded(
                                //     child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     DefaultButtonOutline(
                                //       text: getTranslatedStrings(context).signUp,
                                //       onClick: () {
                                //         showMyAlertDialog(context, getTranslatedStrings(context).signUp,
                                //             alertDialogContent: Column(
                                //               mainAxisSize: MainAxisSize.min,
                                //               children: [
                                //                 Padding(
                                //                   padding: const EdgeInsets.all(14.0),
                                //                   child: Column(
                                //                     children: [
                                //                       heightBox(20.h),
                                //                       DefaultButton(
                                //                         text: getTranslatedStrings(context).asProvider,
                                //                         width: double.maxFinite,
                                //                         height: 40.h,
                                //                         fontSize: 12,
                                //                         onClick: () {
                                //                           navigateTo(
                                //                               context,
                                //                               SignUpScreen(
                                //                                 type: 'provider',
                                //                               ));
                                //                         },
                                //                         radius: 10.r,
                                //                       ),
                                //                       heightBox(7.h),
                                //                       Text(
                                //                         getTranslatedStrings(context).providerDescription,
                                //                         style: mainStyle(context, 12, color: mainBlueColor),
                                //                         textAlign: TextAlign.center,
                                //                       )
                                //                     ],
                                //                   ),
                                //                 ),
                                //
                                //                 /// sign up as student commented for now
                                //                 // heightBox(2.h),
                                //                 // Padding(
                                //                 //   padding:
                                //                 //   const EdgeInsets.all(8.0),
                                //                 //   child: Column(
                                //                 //     children: [
                                //                 //       DefaultButton(
                                //                 //           text: getTranslatedStrings(
                                //                 //               context)
                                //                 //               .asStudent,
                                //                 //           width: double.maxFinite,
                                //                 //           height: 40.h,
                                //                 //           radius: 10.r,
                                //                 //           fontSize: 12,
                                //                 //           onClick: () {
                                //                 //             navigateTo(
                                //                 //                 context,
                                //                 //                 SignUpScreen(
                                //                 //                   type: 'student',
                                //                 //                 ));
                                //                 //           }),
                                //                 //       heightBox(7.h),
                                //                 //       Text(getTranslatedStrings(context).studentDescription,
                                //                 //         style: mainStyle(context, 12,color: mainBlueColor),)
                                //                 //     ],
                                //                 //   ),
                                //                 // ),
                                //                 heightBox(2.h),
                                //                 Padding(
                                //                   padding: const EdgeInsets.all(8.0),
                                //                   child: Column(
                                //                     children: [
                                //                       DefaultButton(
                                //                           text: getTranslatedStrings(context).asClient,
                                //                           width: double.maxFinite,
                                //                           height: 40.h,
                                //                           radius: 10.r,
                                //                           fontSize: 12,
                                //                           onClick: () {
                                //                             navigateTo(
                                //                                 context,
                                //                                 SignUpScreen(
                                //                                   type: 'client',
                                //                                 ));
                                //                           }),
                                //                       heightBox(7.h),
                                //                       Text(
                                //                         getTranslatedStrings(context).clientDescription,
                                //                         style: mainStyle(context, 12, color: mainBlueColor),
                                //                         textAlign: TextAlign.center,
                                //                       )
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ));
                                //       },
                                //     ),
                                //     widthBox(12.w)
                                //   ],
                                // ))
                              ],
                            ),
                            heightBox(33.h),
                            Text(getTranslatedStrings(context).signInToMena,
                                // textAlign: TextAlign.left,
                                style: mainStyle(context, 13, isBold: true)),
                            heightBox(22.h),
                            // Text(
                            //     'Doctors, Providers, professional license, Universities...',
                            //     // textAlign: TextAlign.left,
                            //     style: mainStyle(context,
                            //       14,
                            //     )),
                            // heightBox(30.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
                              child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      DefaultInputField(
                                        label:
                                        '${getTranslatedStrings(context).email} or ${getTranslatedStrings(context).userName}',                                        autoValidateMode: authCubit.autoValidateMode,
                                        controller: emailCont,
                                        validate: normalInputValidate(context,customText: 'Email address or phone number is not valid.'),
                                        //     (String? val) {
                                        //   if (val!.isEmpty) {
                                        //     return 'Please enter your Email';
                                        //   }else
                                        //     // if (!val.contains('@')) {
                                        //     //   return 'Email address not correct';
                                        //     // }
                                        //   if(        val.contains('.')&&
                                        //       val.split('.').last.isNotEmpty&&
                                        //       val.contains('@')&&
                                        //       val.split('@')[1].isNotEmpty){
                                        //     return null;// null is ok 'valid'
                                        //   }else{
                                        //     return 'invalid email';
                                        //   }
                                        //
                                        // },

                                        // labelWidget: IconLabelInputWidget(
                                        //   svgAssetLink: 'assets/svg/icons/email.svg',
                                        //   labelText:
                                        //       '${getTranslatedStrings(context).email} or ${getTranslatedStrings(context).userName}',
                                        // ),
                                      ),
                                      heightBox(10.h),
                                      DefaultInputField(
                                        label: getTranslatedStrings(context).enterPassword,
                                        obscureText: !authCubit.passVisible,
                                        autoValidateMode: authCubit.autoValidateMode,
                                        controller: passCont,
                                        validate: passwordValidate(context),
                                        // labelWidget: IconLabelInputWidget(
                                        //   svgAssetLink: 'assets/svg/icons/password key.svg',
                                        //   labelText: getTranslatedStrings(context).enterPassword,
                                        // ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            authCubit.toggleVisibility('pass');
                                          },
                                          child: SvgPicture.asset(
                                            /// HERE ADD CONDITION IF VISIBLE ASSET LINK WILL BE DEIFFERENT
                                            authCubit.passVisible
                                                ? 'assets/svg/icons/open_eye.svg'
                                                : 'assets/svg/icons/closed eye.svg',
                                            width: 18.sp,
                                            height: 18.sp,
                                          ),
                                        ),
                                      ),
                                      heightBox(0.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.center,
                                          //   children: [
                                          //     Checkbox(
                                          //       value: false,
                                          //       onChanged: (val) {},
                                          //       shape: const CircleBorder(),
                                          //       checkColor: mainBlueColor,
                                          //     ),
                                          //     Text(
                                          //       'Remember me',
                                          //       style: mainStyle(context,13),
                                          //     ),
                                          //   ],
                                          // ),
                                          TextButton(
                                            onPressed: () {
                                              authCubit.resetPasswordRequestOtp(context: context);
                                            },
                                            child: Text(
                                              getTranslatedStrings(context).forgotPassword,
                                              style:
                                                  mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                        //test
                                        // main
                                      ),
                                      heightBox(35.h),
                                      state is AuthLoadingState
                                          ? const DefaultLoaderGrey()
                                          : DefaultButton(
                                              onClick: () {
                                                logg('userLogin started');
                                                authCubit.toggleAutoValidate(true);
                                                if (formKey.currentState!.validate()) {
                                                  logg('validate');
                                                  authCubit.userLogin(
                                                    email: emailCont.text,
                                                    pass: passCont.text,
                                                    context: context,
                                                  );
                                                }
                                              },
                                              text: getTranslatedStrings(context).login,
                                            ),
                                      // heightBox(20.h),
                                      // AgreeTerms(),
                                      // heightBox(40.h),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      // heightBox(10.h),

                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding*2.0),
                        child: DefaultButton(
                          text: getTranslatedStrings(context).signUp,
                          backColor: Colors.green,
                          borderColor: Colors.transparent,
                          onClick: () {
                            navigateTo(context, PickUserTypeLayout());
                            // showMyAlertDialog(context, getTranslatedStrings(context).signUp,
                            //     alertDialogContent: Column(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.all(14.0),
                            //           child: Column(
                            //             children: [
                            //               heightBox(20.h),
                            //               DefaultButton(
                            //                 text: getTranslatedStrings(context).asProvider,
                            //                 width: double.maxFinite,
                            //                 height: 40.h,
                            //                 fontSize: 12,
                            //                 onClick: () {
                            //                   navigateTo(
                            //                       context,
                            //                       SignUpScreen(
                            //                         type: 'provider',
                            //                       ));
                            //                 },
                            //                 radius: 10.r,
                            //               ),
                            //               heightBox(7.h),
                            //               Text(
                            //                 getTranslatedStrings(context).providerDescription,
                            //                 style: mainStyle(context, 12, color: mainBlueColor),
                            //                 textAlign: TextAlign.center,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //
                            //         /// sign up as student commented for now
                            //         // heightBox(2.h),
                            //         // Padding(
                            //         //   padding:
                            //         //   const EdgeInsets.all(8.0),
                            //         //   child: Column(
                            //         //     children: [
                            //         //       DefaultButton(
                            //         //           text: getTranslatedStrings(
                            //         //               context)
                            //         //               .asStudent,
                            //         //           width: double.maxFinite,
                            //         //           height: 40.h,
                            //         //           radius: 10.r,
                            //         //           fontSize: 12,
                            //         //           onClick: () {
                            //         //             navigateTo(
                            //         //                 context,
                            //         //                 SignUpScreen(
                            //         //                   type: 'student',
                            //         //                 ));
                            //         //           }),
                            //         //       heightBox(7.h),
                            //         //       Text(getTranslatedStrings(context).studentDescription,
                            //         //         style: mainStyle(context, 12,color: mainBlueColor),)
                            //         //     ],
                            //         //   ),
                            //         // ),
                            //         heightBox(2.h),
                            //         Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Column(
                            //             children: [
                            //               DefaultButton(
                            //                   text: getTranslatedStrings(context).asClient,
                            //                   width: double.maxFinite,
                            //                   height: 40.h,
                            //                   radius: 10.r,
                            //                   fontSize: 12,
                            //                   onClick: () {
                            //                     navigateTo(
                            //                         context,
                            //                         SignUpScreen(
                            //                           type: 'client',
                            //                         ));
                            //                   }),
                            //               heightBox(7.h),
                            //               Text(
                            //                 getTranslatedStrings(context).clientDescription,
                            //                 style: mainStyle(context, 12, color: mainBlueColor),
                            //                 textAlign: TextAlign.center,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ));
                          },
                        ),
                      ),
                      const ContinueGuestButton(),
                      /// for test
                      // heightBox(30.h),
                      // TextButton(onPressed: (){
                      //   navigateTo(context, const MessengerLayout());
                      // }, child:Text("Messenger"))

                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }
}

class AgreeTerms extends StatelessWidget {
  const AgreeTerms({
    Key? key, required this.byText,
  }) : super(key: key);

  final String byText;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: getTranslatedStrings(context).by,
        style: mainStyle(context, 9.0,
            textHeight: 1.5,
            color: newDarkGreyColor,
            weight: FontWeight.w700,
            fontFamily: getTranslatedStrings(context).language == 'English' ? 'Roboto' : 'Tajawal'),
        children: <TextSpan>[
          TextSpan(
            text: ' ${byText}',
            style: mainStyle(context, 9.0,
                textHeight: 1.5,
                color: newDarkGreyColor,
                weight: FontWeight.w700,
                fontFamily: getTranslatedStrings(context).language == 'English' ? 'Roboto' : 'Tajawal'),          ),
          TextSpan(
            text: ' ${getTranslatedStrings(context).youAgree} ',
            style: mainStyle(context, 9.0,
                textHeight: 1.5,
                color: newDarkGreyColor,
                weight: FontWeight.w700,
                fontFamily: getTranslatedStrings(context).language == 'English' ? 'Roboto' : 'Tajawal'),          ), TextSpan(
            text: ' ${getTranslatedStrings(context).termsOfUse} ',
            style: mainStyle(context, 12.0, weight: FontWeight.w800, color: mainBlueColor, textHeight: 1.5),
          ),
          TextSpan(
            text: '\n${getTranslatedStrings(context).and} ',
            style: mainStyle(context, 10.0,
                textHeight: 1.5,
                weight: FontWeight.w700,
                color: newDarkGreyColor,
                fontFamily: getTranslatedStrings(context).language == 'English' ? 'Roboto' : 'Tajawal'),
          ),
          TextSpan(
            text: getTranslatedStrings(context).privacyPolicy,
            style: mainStyle(context, 12.0, weight: FontWeight.w800, color: mainBlueColor, textHeight: 1.5
                // decoration: TextDecoration.lineThrough
                ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ContinueGuestButton extends StatelessWidget {
  const ContinueGuestButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        removeToken();
        MainCubit.get(context).removeUserModel();
        navigateToAndFinishUntil(context, const MainLayout());
      },
      child: Column(
        children: [
          Text(
            getTranslatedStrings(context).exploreMenaApplication,
            style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
