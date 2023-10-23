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
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/validators.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../home_screen/cubit/home_screen_cubit.dart';
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
    print('user before logins : ${MainCubit.get(context).userInfoModel?.data.user.fullName}');
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
          } else{}
        });
      });
    });
  }
  bool isAnimationPlaying = false;

  void playAnimation() {
    setState(() {
      isAnimationPlaying = true;
    });
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/addedbyzein/back.png', // Replace with your image path
              scale: 3,
              alignment: Alignment.centerRight, // Adjust the height as needed
            ),
            // SvgPicture.asset(
            //   'assets/svg/back_icon.svg',
            //   color: mainBlueColor,
            // ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is AuthErrorState) {

                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        constraints: BoxConstraints(maxHeight: 0.7.sh),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const Expanded(child: SizedBox()),
                                Image.asset(
                                  'assets/menalogoblack.png',
                                  scale: 2,
                                ),
                              ],
                            ),
                            heightBox(110.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
                              child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      DefaultInputField(
                                        label: '${getTranslatedStrings(context).userLogin}',
                                        labelTextStyle: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'PNfont',
                                          color: Color(0xff999B9D)),
                                        autoValidateMode: authCubit.autoValidateMode,
                                        controller: emailCont,
                                        validate: normalInputValidate(context),
                                      ),
                                      heightBox(10.h),
                                      DefaultInputField(
                                        label: getTranslatedStrings(context).passwordLogin,
                                        labelTextStyle: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'PNfont',
                                            color: Color(0xff999B9D)),
                                        obscureText: !authCubit.passVisible,
                                        autoValidateMode: authCubit.autoValidateMode,
                                        controller: passCont,
                                        validate: passwordValidate(context),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            authCubit.toggleVisibility('pass');
                                          },
                                          child: SvgPicture.asset(
                                            /// HERE ADD CONDITION IF VISIBLE ASSET LINK WILL BE DEIFFERENT
                                            authCubit.passVisible
                                                ? 'assets/open_eyes_icon.svg'
                                                : 'assets/close_eye.svg',
                                            fit: BoxFit.contain,
                                            color: Color(0xff999B9D),
                                            theme: SvgTheme(
                                              currentColor: Color(0xff999B9D),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      heightBox(0.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              authCubit.resetPasswordRequestOtp(context: context);
                                            },
                                            child: Text(
                                              getTranslatedStrings(context).forgotPassword,
                                              style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
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
                                        onAnimationStart: () {
                                          // Trigger the SVG animation when the button is clicked
                                          setState(() {
                                            playAnimation(); // Implement your animation logic here
                                          });
                                        },
                                        text: getTranslatedStrings(context).login,
                                      ),
                                      // SVGAnimationWidget(),
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


// class SVGAnimationWidget extends StatefulWidget {
//   @override
//   _SVGAnimationWidgetState createState() => _SVGAnimationWidgetState();
// }
//
// class _SVGAnimationWidgetState extends State<SVGAnimationWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//     return SvgPicture.asset(
//       'assets/your_animation.svg', // Replace with your SVG file path
//       controller: controllerKey, // Use controller instead of key
//       onReadyState: (state) {
//         controllerKey.currentState?.animationController.repeat();
//       },
//     );
//   }
// }