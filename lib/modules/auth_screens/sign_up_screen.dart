import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/config_model.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_state.dart';
import 'package:mena/modules/auth_screens/pick_user_type_layout.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mena/modules/auth_screens/specialization_info_layout.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/provider_types.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    this.phoneController,
    required this.type,
  }) : super(key: key);
  final TextEditingController? phoneController;
  final String type;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<MenaPlatform>? platforms;

  var formKey = GlobalKey<FormState>();
  var fullNameCont = TextEditingController();
  var emailCont = TextEditingController();
  var userNameCont = TextEditingController();
  var passCont = TextEditingController();
  var reEnterPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    platforms = MainCubit.get(context).configModel!.data.platforms;
    // fullNameCont.text = 'skmdk';
    // emailCont.text = 'skmdk@dskjhk.sjadhk';
    // userNameCont.text = 'skmdk';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context)
      ..updateSelectedPlatform(platforms![0], widget.type == 'provider')
      ..toggleAutoValidate(false)
      ..togglePassVisibilityFalse()
      ..resetCategoriesFilters();
    if (widget.type == 'provider') {
      authCubit.getPlatformCategories(platforms![0].id.toString()).then((value) {
        if (authCubit.platformCategory != null) {
          // if (authCubit.platformCategory!.data.isNotEmpty) {
          //   authCubit
          //       .changeSelectedProviderType(authCubit.platformCategory!.data[0]);
          // }
        }
      });
    } else {
      authCubit.changeSelectedProviderType(ProviderTypeItem(id: -1));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultOnlyLogoAppbar(
            withBack: true,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultHorizontalPadding,
              right: defaultHorizontalPadding,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state is AuthErrorState) {
                          showMyAlertDialog(context, getTranslatedStrings(context).error,
                              alertDialogContent: Text(
                                state.error.toString(),
                                textAlign: TextAlign.center,
                              ),
                              dismissible: true);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Lottie.asset('assets/json/information.json', height: 0.15.sh),
                            // heightBox(27.h),
                            // // Row(
                            // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // //   children: [
                            // //     const Expanded(child: SizedBox()),
                            // //     SvgPicture.asset(
                            // //       'assets/svg/mena8.svg',
                            // //       height: 30.h,
                            // //     ),
                            // //     Expanded(
                            // //         child: Row(
                            // //       mainAxisAlignment: MainAxisAlignment.end,
                            // //       children: [
                            // //         DefaultButtonOutline(
                            // //           text: getTranslatedStrings(context).login,
                            // //           onClick: () {
                            // //             navigateTo(context, const SignInScreen());
                            // //           },
                            // //         ),
                            // //         widthBox(12.w)
                            // //       ],
                            // //     ))
                            // //   ],
                            // // ),
                            // heightBox(45.h),
                            Text(getTranslatedStrings(context).loginInfo, style: mainStyle(context, 20, isBold: true)),
                            // heightBox(5.h),
                            // Text('tmp ${widget.type}'),
                            heightBox(22),
                            Text(
                              'To proceed further,\nyou have to fill out your login information.',
                              style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            // heightBox(5.h),
                            // Text('tmp ${widget.type}'),
                            heightBox(22),
                            Form(
                                key: formKey,

                                ///
                                ///
                                ///
                                ///
                                child: Column(
                                  children: [
                                    DefaultInputField(
                                      label: widget.type.toLowerCase() == 'provider'
                                          ? getTranslatedStrings(context).legalFullName
                                          : getTranslatedStrings(context).fullName,
                                      controller: fullNameCont,
                                      autoValidateMode: authCubit.autoValidateMode,
                                      // onFieldChanged: (val){
                                      //   formKey.currentState.
                                      // },
                                      validate: normalInputValidate(context),

                                      // labelWidget: IconLabelInputWidget(
                                      //   svgAssetLink: 'assets/svg/icons/full name.svg',
                                      //   labelText: widget.type.toLowerCase() == 'provider'
                                      //       ? getTranslatedStrings(context).legalFullName
                                      //       : getTranslatedStrings(context).fullName,
                                      // ),
                                      suffixIcon: NoteWidget(
                                        customColor: mainBlueColor,
                                        content: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text:
                                                'If you are a licensed professional, provide your full legal name as identification; if you represent a facility, provide the full trade license name.',
                                            style: mainStyle(
                                              context,
                                              12,
                                              color: newDarkGreyColor,
                                              weight: FontWeight.w700,
                                            ),
                                          ),
                                        ])),
                                      ),
                                    ),
                                    // heightBox(10.h),

                                    // widget.type.toLowerCase() ==
                                    //     'provider'?
                                    // DefaultInputField(
                                    //
                                    //   controller: fullNameCont,
                                    //   autoValidateMode:
                                    //       authCubit.autoValidateMode,
                                    //   // onFieldChanged: (val){
                                    //   //   formKey.currentState.
                                    //   // },
                                    //   validate: normalInputValidate(context),
                                    //   labelWidget: IconLabelInputWidget(
                                    //     svgAssetLink:
                                    //         'assets/svg/icons/full name.svg',
                                    //     labelText: getTranslatedStrings(context)
                                    //             .legalCompanyName
                                    //        ,
                                    //   ),
                                    // ):SizedBox(),
                                    heightBox(10.h),
                                    DefaultInputField(
                                      label: getTranslatedStrings(context).email,
                                      autoValidateMode: authCubit.autoValidateMode,
                                      controller: emailCont,
                                      validate: emailValidate(context),
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
                                      //   labelText: getTranslatedStrings(context).email,
                                      // ),
                                    ),
                                    heightBox(10.h),
                                    DefaultInputField(
                                      label: getTranslatedStrings(context).userName,
                                      autoValidateMode: authCubit.autoValidateMode,
                                      controller: userNameCont,
                                      validate: normalInputValidate(context),
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
                                      //   svgAssetLink: 'assets/svg/icons/full name.svg',
                                      //   labelText: getTranslatedStrings(context).userName,
                                      // ),
                                    ),
                                    heightBox(10.h),
                                    // SizedBox(
                                    //   child: Stack(
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    //         child: Container(
                                    //           width: double.infinity,
                                    //           height: 52.h,
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(5.0.sp),
                                    //             border: Border.all(width: 0.5, color: mainBlueColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(
                                    //                 vertical: defaultHorizontalPadding * 0.3,
                                    //                 horizontal: defaultHorizontalPadding * 2),
                                    //             child: Center(
                                    //               child: InternationalPhoneNumberInput(
                                    //                 textFieldController: widget.phoneController,
                                    //
                                    //                 onFieldSubmitted: (String? val) {
                                    //                   // accountCubit.updatePhoneNum(val!);
                                    //                 },
                                    //                 inputDecoration: const InputDecoration(
                                    //                   border: InputBorder.none,
                                    //                   isDense: true,
                                    //                   contentPadding:
                                    //                       EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                    //                 ),
                                    //                 formatInput: true,
                                    //                 autoValidateMode: authCubit.autoValidateMode!,
                                    //                 validator: (String? val) {
                                    //                   if (val!.isEmpty) {
                                    //                     return getTranslatedStrings(context).thisFieldIsRequired;
                                    //                   }
                                    //                   return null;
                                    //                 },
                                    //                 onInputChanged: (PhoneNumber value) {
                                    //                   // PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])
                                    //                   logg(value.toString());
                                    //                   authCubit.updatePhoneNum(value.phoneNumber.toString());
                                    //                 },
                                    //                 // locale: locale,
                                    //                 initialValue: PhoneNumber(
                                    //                   isoCode: 'AE',
                                    //                 ),
                                    //                 selectorConfig: const SelectorConfig(
                                    //                   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    //                   showFlags: true,
                                    //                   leadingPadding: 0.0,
                                    //                   trailingSpace: false,
                                    //                   setSelectorButtonAsPrefixIcon: false,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       Positioned(
                                    //           top: 0,
                                    //           left: getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                    //               ? defaultHorizontalPadding * 0.7
                                    //               : null,
                                    //           right: getTranslatedStrings(context).currentLanguageDirection == 'rtl'
                                    //               ? defaultHorizontalPadding * 0.7
                                    //               : null,
                                    //           child: Container(
                                    //             height: 16.h,
                                    //             color: Colors.white,
                                    //             child: IconLabelInputWidget(
                                    //               svgAssetLink: 'assets/svg/icons/phone.svg',
                                    //               labelText: getTranslatedStrings(context).phone,
                                    //             ),
                                    //           ))
                                    //     ],
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0.sp),
                                          color: newLightGreyColor,
                                          border: Border.all(width: 0.5, color: mainBlueColor),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: defaultHorizontalPadding * 0.3,
                                              horizontal: defaultHorizontalPadding * 2),
                                          child: Center(
                                            child:

                        // InternationalPhoneNumberInput(),
                                            InternationalPhoneNumberInput(
                                              textFieldController: widget.phoneController,
                                              // hintText: 'Phone number',
                                              onFieldSubmitted: (String? val) {
                                                // accountCubit.updatePhoneNum(val!);
                                              },
                                              inputDecoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                                // labelText: 'Phone number',
                                                hintText:  'Phone number'

                                              ),
                                              formatInput: true,
                                              keyboardType: TextInputType.phone,
                                              textStyle: mainStyle(context, 13,color: newDarkGreyColor,weight: FontWeight.w700),
                                              autoValidateMode: authCubit.autoValidateMode!,
                                              validator: (String? val) {
                                                if (val!.isEmpty) {
                                                  return getTranslatedStrings(context).thisFieldIsRequired;
                                                }
                                                return null;
                                              },
                                              onInputChanged: (PhoneNumber value) {
                                                // PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])
                                                logg(value.toString());
                                                authCubit.updatePhoneNum(value.phoneNumber.toString());
                                              },
                                              // locale: locale,
                                              initialValue:
                                                  // authCubit.phone==null?
                                                  PhoneNumber(
                                                isoCode: 'AE',
                                                // dialCode: authCubit.phone!.dialCode,
                                                // phoneNumber: '05',
                                              ),
                                              // :
                                              // PhoneNumber(
                                              //   isoCode: authCubit.phone!.isoCode,
                                              //   dialCode: authCubit.phone!.dialCode,
                                              //   phoneNumber: authCubit.phone!.phoneNumber,
                                              // ),
                                              selectorConfig: const SelectorConfig(
                                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                                showFlags: true,
                                                leadingPadding: 0.0,
                                                trailingSpace: false,
                                                setSelectorButtonAsPrefixIcon: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                    heightBox(10.h),
                                    DefaultInputField(
                                      label: getTranslatedStrings(context).confirmPassword,
                                      obscureText: !authCubit.confirmPassVisible,
                                      autoValidateMode: authCubit.autoValidateMode,
                                      controller: reEnterPasswordController,
                                      validate: (String? val) {
                                        if (val !=null &&  val.isEmpty) {
                                          return getTranslatedStrings(context).thisFieldIsRequired;
                                        }
                                        if (val != passCont.text) {
                                          return getTranslatedStrings(context).passwordNotMatch;
                                        }
                                        return null;
                                      },
                                      // labelWidget: IconLabelInputWidget(
                                      //   svgAssetLink: 'assets/svg/icons/password key.svg',
                                      //   labelText: getTranslatedStrings(context).confirmPassword,
                                      // ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          authCubit.toggleVisibility('confirmPass');
                                        },
                                        child: SvgPicture.asset(
                                          /// HERE ADD CONDITION IF VISIBLE ASSET LINK WILL BE DIFFERENT
                                          authCubit.confirmPassVisible
                                              ? 'assets/svg/icons/open_eye.svg'
                                              : 'assets/svg/icons/closed eye.svg',
                                          width: 18.sp,
                                          height: 18.sp,
                                        ),
                                      ),
                                    ),
                                    heightBox(10.h),

                                    ///
                                    ///
                                    ///
                                    ///
                                    heightBox(25.h),
                                    state is AuthLoadingState
                                        ? const DefaultLoaderGrey()
                                        : DefaultButton(
                                            onClick: () {
                                              logg('Sign up started');
                                              authCubit.toggleAutoValidate(true);
                                              if (formKey.currentState!.validate()) {
                                                logg('validate');
                                                if (widget.type.toLowerCase() == 'provider') {
                                                  navigateTo(
                                                      context,
                                                      SpecializationInformationLayout(
                                                        type: widget.type,
                                                        fullName: fullNameCont.text,
                                                        email: emailCont.text,
                                                        pass: passCont.text,
                                                        userName: userNameCont.text,
                                                      ));
                                                } else {
                                                  authCubit.userRegister(
                                                    fullName: fullNameCont.text,
                                                    email: emailCont.text,
                                                    pass: passCont.text,
                                                    registrationNumCont: null,
                                                    userName: userNameCont.text,
                                                    providerType: widget.type,

                                                    /// -1 is client
                                                    context: context,
                                                  );
                                                }
                                              }
                                              // authCubit.register();
                                            },
                                            text: widget.type == 'client'
                                                ? getTranslatedStrings(context).register
                                                : getTranslatedStrings(context).next,
                                          ),
                                    // heightBox(10.h),
                                    // AgreeTerms(),
                                    // heightBox(25.h),
                                    // Column(
                                    //   children: [
                                    //     const ContinueGuestButton(),
                                    //     heightBox(20.h),
                                    //     Text(
                                    //       getTranslatedStrings(context).copyRight,
                                    //       style: mainStyle(context, 9, weight: FontWeight.w800),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                )),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
