import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/validators.dart';
import '../../core/dialogs/dialogs_page.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../home_screen/cubit/home_screen_cubit.dart';
import '../initial_onboarding/initial_choose_lang.dart';
import '../main_layout/main_layout.dart';

import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'error-message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static String routeName = 'signInScreen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showContainer = false;
  late double height, width;
  var formKey = GlobalKey<FormState>();
  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  String selectedLanguage = "";

  void getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    String lastLanguage = prefs.getString('selectedLanguage') ?? "";

    setState(() {
      selectedLanguage = lastLanguage;
    });
  }

  @override
  void initState() {
    super.initState();
    getSelectedLanguage();

    MainCubit.get(context).checkPermAndSaveLatLng(context).then((value) {
      MainCubit.get(context).getConfigData().then((value) async {
        MainCubit.get(context).getCountersData();

        /// commented for now
        MainCubit.get(context).checkConnectivity().then((value) async {
          if (value == true) {
            await HomeScreenCubit.get(context)
              ..changeSelectedHomePlatform(
                      MainCubit.get(context).configModel!.data.platforms[0].id!)
                  .then((value) async {
                await MainCubit.get(context)
                    .checkSetUpData()
                    .then((value) async {
                  await Future.delayed(Duration(milliseconds: 2000));
                  // moveToRouteEngine(context);
                });
              });
          } else
          // not connected
          {
            // moveToConnectionErrorScreen(context);
          }
        });

        ///
        // if(_controller.value.duration==await _controller.position){
        //   return Future.delayed(const Duration(milliseconds: 10)).then((value) =>
        //
        //   /// set minimum duration to complete splash continue
        //   ///
        //   /// get config data
        //   ///
        //   ///
        //   MainCubit.get(context)
        //       .checkConnectivity()
        //       .then((value) => value == true
        //       ? moveToRouteEngine(context)
        //       : // not connected
        //   moveToConnectionErrorScreen(context)));
        // }
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getSelectedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
                  if (state is AuthErrorState) {}
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 18),
                        constraints: BoxConstraints(maxHeight: 0.7.sh),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            InitialChooseLang()))
                                    .then((value) => getSelectedLanguage());
                              },
                              child: Text(
                                selectedLanguage,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'PNfont',
                                    color: Color(0xff999B9D)),
                              ),
                            ),
                            heightBox(0.1.sh),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/test.png',
                                  scale: 2,
                                ),
                              ],
                            ),
                            heightBox(33.h),
                            heightBox(22.h),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultHorizontalPadding * 2),
                              child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      DefaultInputField(
                                        label:
                                            "Username, email or mobile number",
                                        labelTextStyle: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PNfont',
                                            color: Color(0xff999B9D)),
                                        unFocusedBorderColor: Color(0xffC9CBCD),
                                        focusedBorderColor: hasError
                                            ? Color(0xffE72B1C)
                                            : Color(0xff0077FF),
                                        autoValidateMode:
                                            authCubit.autoValidateMode,
                                        controller: emailCont,
                                        validate: normalInputValidate,
                                      ),
                                      heightBox(10.h),
                                      DefaultInputField(
                                        label: "Password",
                                        labelTextStyle: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PNfont',
                                            color: Color(0xff999B9D)),
                                        unFocusedBorderColor: Color(0xffC9CBCD),
                                        focusedBorderColor: hasError
                                            ? Color(0xffE72B1C)
                                            : Color(0xff0077FF),
                                        obscureText: !authCubit.passVisible,
                                        autoValidateMode:
                                            authCubit.autoValidateMode,
                                        controller: passCont,
                                        validate: passwordValidate(context),
                                      ),
                                      heightBox(10.h),
                                      // heightBox(35.h),
                                      state is AuthLoadingState
                                          ? const DefaultLoaderGrey()
                                          : DefaultButton(
                                              height: 40,
                                              backColor: Color(0xff0077FF),
                                              onClick: () {
                                                if (emailCont.text.isEmpty ||
                                                    passCont.text.isEmpty) {
                                                  logInAlertDialog(context);
                                                  return;
                                                }
                                                logg('userLogin started');
                                                authCubit
                                                    .toggleAutoValidate(true);
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  logg('validate');
                                                  authCubit.userLogin(
                                                    email: emailCont.text,
                                                    pass: passCont.text,
                                                    context: context,
                                                  );
                                                }
                                              },
                                              text: "Log in",
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              AuthCubit()
                                                  .resetPasswordRequestOtp(
                                                      context: context);
                                            },
                                            child: Text(
                                              getTranslatedStrings(context)
                                                  .forgotPassword,
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'PNfont',
                                                  color: Color(0xff303840)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding * 2.0),
                        child: DefaultButton(
                          height: 40,
                          text: "Create new account",
                          backColor: Color(0xff34A853),
                          borderColor: Colors.transparent,
                          onClick: () {
                            navigateTo(context, PickUserTypeLayout());
                          },
                        ),
                      ),
                      // heightBox(30.h),
                      const ContinueGuestButton(),
                      SvgPicture.asset(
                        'assets/svg/10-10.svg',
                        height: 150,
                      ),
                      showContainer
                          ? Container(
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: AlertDialog(),
                                  ),
                                  Positioned(
                                    child: AlertDialog(),
                                  )
                                ],
                              ),
                            )
                          : Container(),
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
    Key? key,
    required this.byText,
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
            fontFamily: getTranslatedStrings(context).language == 'English'
                ? 'Roboto'
                : 'Tajawal'),
        children: <TextSpan>[
          TextSpan(
            text: ' ${byText}',
            style: mainStyle(context, 9.0,
                textHeight: 1.5,
                color: newDarkGreyColor,
                weight: FontWeight.w700,
                fontFamily: getTranslatedStrings(context).language == 'English'
                    ? 'Roboto'
                    : 'Tajawal'),
          ),
          TextSpan(
            text: ' ${getTranslatedStrings(context).youAgree} ',
            style: mainStyle(context, 9.0,
                textHeight: 1.5,
                color: newDarkGreyColor,
                weight: FontWeight.w700,
                fontFamily: getTranslatedStrings(context).language == 'English'
                    ? 'Roboto'
                    : 'Tajawal'),
          ),
          TextSpan(
            text: ' ${getTranslatedStrings(context).termsOfUse} ',
            style: mainStyle(context, 12.0,
                weight: FontWeight.w800, color: mainBlueColor, textHeight: 1.5),
          ),
          TextSpan(
            text: '\n${getTranslatedStrings(context).and} ',
            style: mainStyle(context, 10.0,
                textHeight: 1.5,
                weight: FontWeight.w700,
                color: newDarkGreyColor,
                fontFamily: getTranslatedStrings(context).language == 'English'
                    ? 'Roboto'
                    : 'Tajawal'),
          ),
          TextSpan(
            text: getTranslatedStrings(context).privacyPolicy,
            style: mainStyle(context, 12.0,
                weight: FontWeight.w800, color: mainBlueColor, textHeight: 1.5),
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
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'PNfont',
                color: Color(0xff303840)),
          ),
        ],
      ),
    );
  }
}

// class logInAlertDialog extends StatelessWidget{
//   const logInAlertDialog({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30), // Customize the border radius
//         // You can also use other ShapeBorder classes like OutlineInputBorder, StadiumBorder, etc.
//       ),
//       backgroundColor: Colors.white,
//       title: Text("Enter credentials",),
//       titleTextStyle: TextStyle(
//           fontSize: 22.0,
//           fontWeight: FontWeight.w800,
//           fontFamily: 'PNfont',
//           color: Color(0xff303840)
//       ),
//       content: Text("To proceed, please input your mobile number, email,or username"),
//       contentTextStyle: TextStyle(
//           fontSize: 16.0,
//           fontWeight: FontWeight.w400,
//           fontFamily: 'PNfont',
//           color: Color(0xff303840)
//       ),
//       actions: [
//         TextButton(
//           style: ButtonStyle(
//             alignment: Alignment.centerRight,
//           ),
//             onPressed: (){
//               Navigator.pop(context);
//             },
//             child: Text(
//               "TRY AGAIN",
//               style: TextStyle(
//           fontSize: 13.0,
//           fontWeight: FontWeight.w800,
//           fontFamily: 'PNfont',
//           color: Color(0xff303840)
//       ),))],
//     );
//   }
// }


