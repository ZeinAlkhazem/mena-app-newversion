import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/app_toasts.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/api_model/home_section_model.dart';
import '../../modules/auth_screens/sign_in_screen.dart';
import '../../modules/create_live/widget/default_button.dart';
import '../constants/constants.dart';

void logg(String logVal) {
  log('++********++\n$logVal\n--***********--');
}

void logRequestedUrl(String logText) {
  ///  commented 'log to disable'
  log(logText);

  ///  commented 'log to disable'
}

Future<void> navigateTo(BuildContext context, page,
    {PageTransitionType? customTransition}) async {
  logg('navigateTo $page');

  final routPage = page;
  pushNewScreenWithRouteSettings(
    context,
    // isIos: Platform.isIOS
    settings: RouteSettings(name: 'routeName'),
    screen: routPage,
    // withNavBar: true,
    pageTransitionAnimation:

        /// Todo: uncomment to enable swipe to back
        Platform.isIOS
            ? PageTransitionAnimation.cupertino
            : PageTransitionAnimation.fade,
  );

  // Navigator.push(
  //   context,
  //   PageTransition(
  //     type:Platform.isIOS?PageTransitionType.: PageTransitionType.fade,
  //     child: routPage,
  //     duration: const Duration(milliseconds: 400),
  //   ),
  // );
}

Future<void> navigateBackToHome(BuildContext context,
    {PageTransitionType? customTransition}) async {
  // logg('navigateTo $page');
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void pushNewScreenLayout(BuildContext context, page, bool withNavBar) {
  logg('pushNewScreenLayout');
  pushNewScreen(
    context,
    screen: page,
    withNavBar: withNavBar, // OPTIONAL VALUE. True by default.
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

Future<void> navigateToAndFinish(BuildContext context, page) async {
  Navigator.pushReplacement(
    context,
    PageTransition(
      type: PageTransitionType.bottomToTop,
      child: page,
      duration: const Duration(milliseconds: 0),
    ),
  );
}

Future<void> navigateToAndFinishUntil(BuildContext context, page) async {
  logg('navigateToAndFinishUntil: $page');

  Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      ),
      ModalRoute.withName("/Homeeee"));
}

Future<void> navigateToWithoutNavAndFinishUntil(
    BuildContext context, page) async {
  logg('navigateToAndFinishUntil');
  Navigator.of(context, rootNavigator: true)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
}

Future<void> navigateToWithNavBar(
    BuildContext context, Widget page, routeName) async {
  pushNewScreenWithRouteSettings(
    context,
    settings: RouteSettings(name: routeName),
    screen: page,
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

Future<void> navigateToWithoutNavBar(
    BuildContext context, Widget page, routeName,
    {VoidCallback? onBackToScreen, bool resetDesignSize = false}) async {
  // if(resetDesignSize){
  //   logg('asjdghbkjnd');
  //   // ScreenUtil.init(
  //   //     context,
  //   //     designSize: const Size(
  //   //         360,
  //   //         770),
  //   //     splitScreenMode:
  //   //     true
  //   //   // width: 750, height: 1334, allowFontScaling: false
  //   // );
  // }
  // await Navigator.push(context, MaterialPageRoute(builder: (ctx)=>page)).then((value) {
  //    logg('back to ${page.toString()}');

  // if(onBackToScreen!=null){
  //   logg('on back not null');
  //   onBackToScreen();
  // }
  // });
  logg('navigate to without nav bar to $page');
  pushNewScreenWithRouteSettings(
    context,
    settings: RouteSettings(name: routeName),
    screen: page,
    withNavBar: false,
    pageTransitionAnimation:

        /// Todo: uncomment to enable swipe to back
        Platform.isIOS
            ? PageTransitionAnimation.cupertino
            : PageTransitionAnimation.fade,
  ).then((value) {
    logg('back to ${page.toString()}');
    if (onBackToScreen != null) {
      logg('on back not null');
      onBackToScreen();
    }
    if (resetDesignSize) {
      logg('asjdghbkjnd');
    }
  });
}

Future<void> showMyAlertDialog(
  BuildContext context,
  String title, {
  Widget? alertDialogContent,
  bool? dismissible,
  List<Widget>? actions,
  bool isTitleBold = false,
  TextStyle? titleTextStyle,
  Color? alertDialogBackColor,
}) async {
  await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: dismissible ?? true,
      barrierColor: Colors.white.withOpacity(0),
      // barrierDismissible: false,
      builder: (BuildContext context) =>
          //     BlocConsumer<MainCubit, MainStates>(
          //   listener: (context, state) {},
          //   builder: (context, state) {
          //     return AlertDialog(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(18.0.r))),
          //       title: Center(
          //           child: Text(
          //             'Request Item',
          //             style: mainStyle(context,18.0, FontWeight.w200,),
          //           )),
          //       content: Padding(
          //         padding: EdgeInsets.all(6.0.sp),
          //         child: SingleChildScrollView(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               ConditionalBuilder(
          //                   condition: imageFile != null,
          //                   builder: (ctx) {
          //                     if (state is ImageGotState) {
          //                       imageFile = state.imageFile!;
          //                       kbytes = state.kbytes;
          //                     }
          //                     return Container(
          //                       // color: Colors.red,
          //                       height: 200.h,
          //                       width: 200.h,
          //                       child: Image.file(
          //                         imageFile!,
          //                         width: 200.h,
          //                         height: 200.h,
          //                       ),
          //                     );
          //                   },
          //                   fallback: (ctx) => Container()),
          //               SizedBox(
          //                 height: 7.h,
          //               ),
          //               Form(
          //                 key: formKey,
          //                 child: SingleChildScrollView(
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       InputItemInAlertDialogItem(
          //                         label: 'Brand name',
          //                         maxLines: 1,
          //                         controller: brandNameCont,
          //                         validate: (String? val) {
          //                           if (val!.isEmpty) {
          //                             return 'Please enter Brand name';
          //                           }
          //                         },
          //                       ),
          //                       SizedBox(
          //                         height: 10.h,
          //                       ),
          //                       InputItemInAlertDialogItem(
          //                         label: 'Shoes name',
          //                         maxLines: 1,
          //                         controller: shoesNameCont,
          //                         validate: (String? val) {
          //                           if (val!.isEmpty) {
          //                             return 'Please enter shoes name';
          //                           }
          //                         },
          //                       ),
          //                       SizedBox(
          //                         height: 10.h,
          //                       ),
          //                       // InputItemInAlertDialogItem(
          //                       //   label: 'Email',
          //                       //   maxLines: 1,
          //                       //   controller: emailCont,
          //                       //   validate: (String? val) {
          //                       //     if (val!.isEmpty) {
          //                       //       return 'Please enter your email';
          //                       //     }
          //                       //   },
          //                       // ),
          //                       SizedBox(
          //                         height: 10.h,
          //                       ),
          //                       DefaultButtonWithIcon(
          //                           borderRad: 24.0,
          //                           titleSize: 12.0,
          //                           onClick: () {
          //                             pickImage();
          //                           },
          //                           title: 'Upload image',
          //                           iconPath:
          //                           'assets/images/account/Group 263.png'),
          //                       SizedBox(
          //                         height: 15.h,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       actions: <Widget>[
          //         TextButton(
          //           onPressed: () {
          //             logg('after cancel clear cached image');
          //             imageFile = null;
          //             Navigator.pop(context, 'Cancel');
          //           },
          //           child: const Text('Cancel'),
          //         ),
          //         state is SendingFeedbackState?LinearProgressIndicator():
          //         TextButton(
          //           onPressed: () {
          //             if (formKey.currentState!.validate()) {
          //               if (imageFile != null) {
          //                 logg('file size is: ' + kbytes.toString());
          //                 logg('Brand name: ' + brandNameCont.text);
          //                 logg('Shoes name: ' + shoesNameCont.text);
          //                 logg('Email: ' + emailCont.text);
          //
          //                 if (kbytes! < 20480) {
          //                   logg('image size ok');
          //
          //                   String imageExtension = imageFile!.path
          //                       .substring((imageFile!.path.length) - 4);
          //                   logg('image extension:' + imageExtension);
          //
          //                   if (imageExtension == '.jpg' ||
          //                       imageExtension == '.png' ||
          //                       imageExtension == '.gif' ||
          //                       imageExtension == 'jpeg' ||
          //                       imageExtension == '.svg') {
          //                     logg('image extension accepted');
          //                     logg('sending file now');
          //
          //
          //                     ///////////////////////////////need modify
          //
          //                     requestItemPst(
          //                       brandName: brandNameCont.text,
          //                       shoeName: shoesNameCont.text,
          //                       imageFile: imageFile!,
          //                       context: context,
          //                     );
          //
          //
          //                   }
          //                   logg('after sending file');
          //                   imageFile = null;
          //                 }
          //               }
          //             }
          //           },
          //           //add Send logic
          //           child: const Text('Send'),
          //         ),
          //       ],
          //     );
          //   },
          // ))
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: SizedBox(
              width: double.maxFinite,
              child: AlertDialog(
                backgroundColor: alertDialogBackColor ?? Colors.white,
                titlePadding: EdgeInsets.all(16.sp),
                contentPadding:
                    EdgeInsets.only(bottom: 16.sp, left: 16.sp, right: 16.sp),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: titleTextStyle ??
                          mainStyle(context, 14.0,
                              color: Colors.black,
                              isBold: isTitleBold,
                              weight: isTitleBold
                                  ? FontWeight.normal
                                  : FontWeight.w700,
                              textHeight: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    // Divider(
                    //   color: Colors.black,
                    // )
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultRadiusVal)),
                ),
                content: alertDialogContent,
                actions: actions,
              ),
            ),
          ));
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  try {
    var value = double.parse(s);
    return true;
  } on FormatException {
    return false;
  }
  // finally {
  //   return true;
  // }
  // return double.parse(s, (e) => null) != null;
}

Future<void> showMyBottomSheet({
  required BuildContext context,
  required String title,
  bool isDismissible = true,
  required Widget body,
  Widget? titleActionWidget,
}) async {
  buildShowModalBottomSheet(context,
      isDismissible: isDismissible,
      backColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints(maxHeight: 0.7.sh),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultRadiusVal),
              topRight: Radius.circular(defaultRadiusVal),
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: mainStyle(context, 16, isBold: true),
                        ),
                      ),
                      if (titleActionWidget != null) titleActionWidget
                    ],
                  ),
                  Divider(),
                  heightBox(10.h),
                  body,
                ],
              ),
            ),
          ),
        ),
      ));
}

Future<void> viewComingSoonAlertDialog(BuildContext context,
    {Widget? customAddedWidget}) async {
  await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0),
      // barrierDismissible: false,
      builder: (BuildContext context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  'Coming SOON',
                  style: mainStyle(context, 15.0,
                      weight: FontWeight.w800, color: mainBlueColor),
                  textAlign: TextAlign.center,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(11.0.r))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/json/coming soon.json'),
                  Text('This feature not available right now',
                      style: mainStyle(context, 13)),
                  heightBox(7.h),
                  customAddedWidget ?? SizedBox()
                ],
              ),
            ),
          ));
}

Future<void> viewLoginAlertDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: true,
    barrierColor: Colors.white.withOpacity(0),
    // barrierDismissible: false,
    builder: (BuildContext context) =>
        //     BlocConsumer<MainCubit, MainStates>(
        //   listener: (context, state) {},
        //   builder: (context, state) {
        //     return AlertDialog(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(18.0.r))),
        //       title: Center(
        //           child: Text(
        //             'Request Item',
        //             style: mainStyle(context,18.0, FontWeight.w200,),
        //           )),
        //       content: Padding(
        //         padding: EdgeInsets.all(6.0.sp),
        //         child: SingleChildScrollView(
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               ConditionalBuilder(
        //                   condition: imageFile != null,
        //                   builder: (ctx) {
        //                     if (state is ImageGotState) {
        //                       imageFile = state.imageFile!;
        //                       kbytes = state.kbytes;
        //                     }
        //                     return Container(
        //                       // color: Colors.red,
        //                       height: 200.h,
        //                       width: 200.h,
        //                       child: Image.file(
        //                         imageFile!,
        //                         width: 200.h,
        //                         height: 200.h,
        //                       ),
        //                     );
        //                   },
        //                   fallback: (ctx) => Container()),
        //               SizedBox(
        //                 height: 7.h,
        //               ),
        //               Form(
        //                 key: formKey,
        //                 child: SingleChildScrollView(
        //                   child: Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       InputItemInAlertDialogItem(
        //                         label: 'Brand name',
        //                         maxLines: 1,
        //                         controller: brandNameCont,
        //                         validate: (String? val) {
        //                           if (val!.isEmpty) {
        //                             return 'Please enter Brand name';
        //                           }
        //                         },
        //                       ),
        //                       SizedBox(
        //                         height: 10.h,
        //                       ),
        //                       InputItemInAlertDialogItem(
        //                         label: 'Shoes name',
        //                         maxLines: 1,
        //                         controller: shoesNameCont,
        //                         validate: (String? val) {
        //                           if (val!.isEmpty) {
        //                             return 'Please enter shoes name';
        //                           }
        //                         },
        //                       ),
        //                       SizedBox(
        //                         height: 10.h,
        //                       ),
        //                       // InputItemInAlertDialogItem(
        //                       //   label: 'Email',
        //                       //   maxLines: 1,
        //                       //   controller: emailCont,
        //                       //   validate: (String? val) {
        //                       //     if (val!.isEmpty) {
        //                       //       return 'Please enter your email';
        //                       //     }
        //                       //   },
        //                       // ),
        //                       SizedBox(
        //                         height: 10.h,
        //                       ),
        //                       DefaultButtonWithIcon(
        //                           borderRad: 24.0,
        //                           titleSize: 12.0,
        //                           onClick: () {
        //                             pickImage();
        //                           },
        //                           title: 'Upload image',
        //                           iconPath:
        //                           'assets/images/account/Group 263.png'),
        //                       SizedBox(
        //                         height: 15.h,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             logg('after cancel clear cached image');
        //             imageFile = null;
        //             Navigator.pop(context, 'Cancel');
        //           },
        //           child: const Text('Cancel'),
        //         ),
        //         state is SendingFeedbackState?LinearProgressIndicator():
        //         TextButton(
        //           onPressed: () {
        //             if (formKey.currentState!.validate()) {
        //               if (imageFile != null) {
        //                 logg('file size is: ' + kbytes.toString());
        //                 logg('Brand name: ' + brandNameCont.text);
        //                 logg('Shoes name: ' + shoesNameCont.text);
        //                 logg('Email: ' + emailCont.text);
        //
        //                 if (kbytes! < 20480) {
        //                   logg('image size ok');
        //
        //                   String imageExtension = imageFile!.path
        //                       .substring((imageFile!.path.length) - 4);
        //                   logg('image extension:' + imageExtension);
        //
        //                   if (imageExtension == '.jpg' ||
        //                       imageExtension == '.png' ||
        //                       imageExtension == '.gif' ||
        //                       imageExtension == 'jpeg' ||
        //                       imageExtension == '.svg') {
        //                     logg('image extension accepted');
        //                     logg('sending file now');
        //
        //
        //                     ///////////////////////////////need modify
        //
        //                     requestItemPst(
        //                       brandName: brandNameCont.text,
        //                       shoeName: shoesNameCont.text,
        //                       imageFile: imageFile!,
        //                       context: context,
        //                     );
        //
        //
        //                   }
        //                   logg('after sending file');
        //                   imageFile = null;
        //                 }
        //               }
        //             }
        //           },
        //           //add Send logic
        //           child: const Text('Send'),
        //         ),
        //       ],
        //     );
        //   },
        // ))
        BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Join us',
            style: mainStyle(context, 15.0,
                weight: FontWeight.w800, color: mainBlueColor),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0.r))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/json/login.json',
            ),
            Text(
              'Login / Register to proceed',
              style: mainStyle(context, 13),
            ),
            heightBox(10.h),
            DefaultButton(
              text: 'Join now',
              onClick: () {
                Navigator.pop(context);
                navigateTo(context, SignInScreen());
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> viewMessengerLoginAlertDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: true,
    barrierColor: Colors.white.withOpacity(0),
    // barrierDismissible: false,
    builder: (BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: SizedBox(
              height: 25.h,
              child: SvgPicture.asset('$messengerAssets/icon_mena_messenger_color_hor.svg')),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0.r))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/json/messengerstart.json',
            ),
            heightBox(10.h),
            Text(
              'To use Messenger, you need to log in',
              style: mainStyle(context, 12,
                  weight: FontWeight.w700,
                  color: AppColors.grayDarkColor,
                  isBold: false),
              textAlign: TextAlign.center,
            ),
            heightBox(15.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: DefaultButton(
                text: 'Get started',
                onClick: () {
                  Navigator.pop(context);
                  navigateTo(context, SignInScreen());
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String replaceFlutterColorWithHexValue(Color color) {
  return color.value
      .toRadixString(16)
      .padLeft(6, '0')
      .toUpperCase()
      .toString()
      .replaceRange(0, 2, '#');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

String? getErrorMessageFromErrorJsonResponse(dynamic error) {
  if (error.response == null) {
    AppToasts.errorToast('Check your internet connection');
    return 'Check your internet connection';
  } else {
    AppToasts.errorToast(json.decode(error.response.toString())["message"])
        .toString();

    return (json.decode(error.response.toString())["message"]).toString();
  }
}

void showErrorStateSnackBar(BuildContext context, state, {String? text}) {
  viewMySnackBar(
      context,
      state.error != null ? state.error.toString() : text ?? 'unknown error',
      '',
      () {});
}

// void playSuccessSound() {
//   Platform.isIOS
//       ? FlutterBeep.beep()
//   // FlutterBeep.playSysSound(iOSSoundIDs.AudioToneBusy)
//       : FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
// }

// Future<void> buildCarsFiltersModalBottom(
//     BuildContext context,
//     ) async {
//   var localizationStrings = AppLocalizations.of(context);
//   var categoriesCubit = CategoriesCubit.get(context);
//   categoriesCubit.resetSelectedSequenceFilter();
//   List<CategoryItemModel> subCategoriesDueSelectedMain=[];
//   List<CategoryItemModel> subSubCategoriesDueSelectedMain=[];
//   logg('categoriesCubit.categoriesModel!.data!.where((element) '
//       '=> element.type==car'
//       ')' +
//       categoriesCubit.categoriesModel!.data!
//           .where((element) => element.type == 'car')
//           .toList()
//           .toString());
//
//
//   FilterListDelegate.show<CategoryItemModel>(
//     context: context,
//
//     list: categoriesCubit.categoriesModel!.data!
//         .where((element) => element.type == 'car')
//         .toList(),
//     selectedListData: categoriesCubit.selectedMainCategoriesList,
//     onItemSearch: (brand, query) {
//       return brand.name!.toLowerCase().contains(query.toLowerCase());
//     },
//     tileLabel: (brand) => brand!.name!,
//     emptySearchChild: Center(child: Text(localizationStrings!.noResultFound)),
//     searchFieldHint: localizationStrings.search,
//     onApplyButtonClick: (list) {
//       /// apply on main
//       ///
//       ///
//
//       logg('09090categoriesCubit.selectedMainCategoriesList: ' +
//           categoriesCubit.selectedMainCategoriesList.toString());
//       categoriesCubit.addSelectedMainCategoriesToMainList(list!)
//       ;
//       if(categoriesCubit.selectedMainCategoriesList.isNotEmpty){
// //////
//         /// getCategoriesBySelectedParent
//         logg('selected.main is: '+categoriesCubit.selectedMainCategoriesList.toString());
//         logg('selected.main childes is: '+categoriesCubit.selectedMainCategoriesList
//             .map((e) => e.childes)
//             .toString());
//         subCategoriesDueSelectedMain=[];
//         categoriesCubit.selectedMainCategoriesList
//             .forEach((e) {
//           logg('adding to subCategoriesDueSelectedMain - value: '+e.toString());
//           subCategoriesDueSelectedMain+=e.childes!.toList();
//         }
//         );
//
//         logg('comined subCategoriesDueSelectedMain: '+subCategoriesDueSelectedMain.toString());
//
//         FilterListDelegate.show<CategoryItemModel>(
//           context: context,
//           list: subCategoriesDueSelectedMain,
//
//
//           selectedListData: categoriesCubit.selectedSubCategoriesList,
//           onItemSearch: (brand, query) {
//             return brand.name!.toLowerCase().contains(query.toLowerCase());
//           },
//           tileLabel: (brand) => brand!.name!,
//           emptySearchChild: Center(child: Text(localizationStrings.noResultFound)),
//           searchFieldHint: localizationStrings.search,
//           onApplyButtonClick: (list) {
//             /// this one is the last apply on tree so view results no ned to if else
//             ///
//             logg('categoriesCubit.selectedSubCategoriesList: ' +
//                 categoriesCubit.selectedSubCategoriesList.toString());
//             categoriesCubit.addSelectedSubCategoriesToMainList(list!)
//             ;
//             if(categoriesCubit.selectedSubCategoriesList.isNotEmpty){
// //////
//               /// getCategoriesBySelectedParent
//
//               logg('selected.main is: '+categoriesCubit.selectedMainCategoriesList.toString());
//               logg('selected.sub is: '+categoriesCubit.selectedSubCategoriesList.toString());
//               logg('selected.sub childes is: '+categoriesCubit.selectedSubCategoriesList
//                   .map((e) => e.childes)
//                   .toString());
//
//               subSubCategoriesDueSelectedMain=[];
//               categoriesCubit.selectedSubCategoriesList
//                   .forEach((e) {
//                 logg('adding to subSubCategoriesDueSelectedMain - value: '+e.toString());
//                 subSubCategoriesDueSelectedMain+=e.childes!.toList();
//               }
//               );
//
//               logg('comined subSubCategoriesDueSelectedMain: '+subSubCategoriesDueSelectedMain.toString());
//
//               FilterListDelegate.show<CategoryItemModel>(
//                 context: context,
//                 list: subSubCategoriesDueSelectedMain,
//
//
//                 selectedListData: categoriesCubit.selectedSubSubCategoriesList,
//                 onItemSearch: (brand, query) {
//                   return brand.name!.toLowerCase().contains(query.toLowerCase());
//                 },
//                 tileLabel: (brand) => brand!.name!,
//                 emptySearchChild: Center(child: Text(localizationStrings.noResultFound)),
//                 searchFieldHint: localizationStrings.search,
//                 onApplyButtonClick: (list) {
//                   logg('closing sub filter layout');
//                   // logg('categoriesCubit.selectedMainCategoriesList: ' +
//                   //     categoriesCubit.selectedSubSubCategoriesList.toString());
//                   categoriesCubit.addSelectedSubSubCategoriesToMainList(list!);
//
//
//                   logg('selected Main categories: '+categoriesCubit.selectedMainCategoriesList.toString());
//                   logg('selected sub categories: '+categoriesCubit.selectedSubCategoriesList.toString());
//                   logg('selected subsub categories: '+categoriesCubit.selectedSubSubCategoriesList.toString());
//
//
//                   List<String> listOfIdsInLastLayoutToSendToSubSubProducts=[];
//                   if(categoriesCubit.selectedSubSubCategoriesList.isNotEmpty){
//
//                     categoriesCubit.selectedSubSubCategoriesList
//                         .forEach((element)
//                     {listOfIdsInLastLayoutToSendToSubSubProducts.add(element.id.toString());});
//                     navigateToWithNavBar(context, SubSubCategoryProductsLayout(cateId: listOfIdsInLastLayoutToSendToSubSubProducts), SubSubCategoryProductsLayout.routeName);
//                   }else{
//                     if(subSubCategoriesDueSelectedMain.isNotEmpty){
//                       logg('no items selected in this layout');
//                       logg('should navigate with previous selected category');
//                       listOfIdsInLastLayoutToSendToSubSubProducts=[];
//                       subSubCategoriesDueSelectedMain.forEach((element) {
//                         listOfIdsInLastLayoutToSendToSubSubProducts.add(element.id.toString());
//                       });
//                       logg('ids to send to sub sub layout'+listOfIdsInLastLayoutToSendToSubSubProducts.toString());
//                       navigateToWithNavBar(context, SubSubCategoryProductsLayout(cateId: listOfIdsInLastLayoutToSendToSubSubProducts), SubSubCategoryProductsLayout.routeName);
//
//                     }
//                     else{
//                       logg('(*(*(*(*');
//                       viewMySnackBar(context, 'No results for your selection', '', () => null);
//                     }
//
//                   }
//
//
//
//
//
//
//                   // Do something with selected list
//                 },
//
//               );
//             }
//             else{
//               logg(''
//                   'no items selected view products');
//               List<String> listOfIdsToSendToSubSubProducts=[];
//               if(subCategoriesDueSelectedMain.isNotEmpty){
//                 subCategoriesDueSelectedMain.forEach((element) {
//                   logg(
//                       'ids of current page: '+element.id.toString()
//                   );
//                   listOfIdsToSendToSubSubProducts.add(element.id.toString());
//                 });
//                 logg('listOfIdsToSendToSubSubProducts: '+listOfIdsToSendToSubSubProducts.toString());
//
//                 navigateToWithNavBar(context, SubSubCategoryProductsLayout(cateId: listOfIdsToSendToSubSubProducts), SubSubCategoryProductsLayout.routeName);
//
//               }else{
//                 viewMySnackBar(context, 'No results for your selection', '', () => null);
//               }
//
//             }
//             // Do something with selected list
//           },
//
//         );
//       }
//       /// if empty get results of all
//       else{
//         logg(''
//             'no items selected view products');
//         List<String> listOfIdsToSendToSubSubProducts=[];
//         if(categoriesCubit.categoriesModel!.data!
//             .where((element) => element.type == 'car')
//             .toList().isNotEmpty){
//           categoriesCubit.categoriesModel!.data!
//               .where((element) => element.type == 'car').toList().forEach((element) {
//             logg(
//                 'ids of current page: '+element.id.toString()
//             );
//             listOfIdsToSendToSubSubProducts.add(element.id.toString());
//           });
//
//           logg('listOfIdsToSendToSubSubProducts: '+listOfIdsToSendToSubSubProducts.toString());
//
//           navigateToWithNavBar(context, SubSubCategoryProductsLayout(cateId: listOfIdsToSendToSubSubProducts), SubSubCategoryProductsLayout.routeName);
//
//         }else{
//           viewMySnackBar(context, 'No results for your selection', '', () => null);
//         }
//       }
//
//       // Do something with selected list
//     },
//
//   );
//
// }

// void handleResourceType(BuildContext context, String? resourceType,
//     String? resourceId, String? url) {
//   if (resourceType == 'category') {
//     List<String>resourceIdList=[resourceId!];
//     navigateToWithNavBar(
//         context,
//         SubSubCategoryProductsLayout(
//           cateId: resourceIdList,
//         ),
//         CategoryDetailedLayout.routeName);
//   }
//
//   ///commented for now then change resource type in the next condition to car
//   else if (resourceType == 'product') {
//     ProductDetailsCubit.get(context).changeFirstRunVal(true);
//     navigateToWithNavBar(
//         context,
//         ProductDetailsLayout(
//           productId: resourceId.toString(),
//         ),
//         ProductDetailsLayout.routeName);
//   } else if (resourceType == 'car') {
//     buildCarsFiltersModalBottom(context);
//     // ProductDetailsCubit.get(context).changeFirstRunVal(true);
//     // navigateToWithNavBar(
//     //     context,
//     //     ProductDetailsLayout(
//     //       productId: resourceId.toString(),
//     //     ),
//     //     ProductDetailsLayout.routeName);
//   } else {
//     logg('this resource type not handled');
//   }
// }

void loginRequiredSnackBar(BuildContext context) {
  var localizationStrings = AppLocalizations.of(context);
  viewMySnackBar(
      context,
      localizationStrings!.loginRequired,
      localizationStrings.login,
      () => pushNewScreenLayout(context, const SignInScreen(), false));
}

void viewMySnackBar(
    BuildContext context, String text, String actionLabel, Function() action,
    {Color? customColor}) {
  var localizationStrings = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 2.0,
    backgroundColor: customColor ?? Colors.black.withOpacity(0.8),
    padding: EdgeInsets.only(bottom: 7.h),
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Text(
        text,
        style: mainStyle(context, 14.0, color: Colors.white),
      ),
    ),
    action: actionLabel == ''
        ? SnackBarAction(
            label: localizationStrings!.hide,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          )
        : SnackBarAction(
            label: actionLabel,
            onPressed: action,
          ),
  ));
}
// auth functions
// Future<void> userAuthAndSaveAndNavigatee(
//     Response<dynamic> value, BuildContext context) async {
//   //add navigate
//   UserModel userSignUpModel;
//   userSignUpModel = UserModel.fromJson(value.data);
//   saveCacheToken(userSignUpModel.data!.token);
//   saveCacheName(userSignUpModel.data!.user!.fName! +
//       ' ' +
//       userSignUpModel.data!.user!.lName!);
//   saveCacheEmail(userSignUpModel.data!.user!.email);
//   // CacheHelper.saveData(key: 'name', value: userSignUpModel.data!.user!.fName!+' '+userSignUpModel.data!.user!.lName!);
//   // CacheHelper.saveData(key: 'email', value: userSignUpModel.data!.user!.email);
//   // logg(userSignUpModel.data!.user!.name.toString() + ' LoggedIn');
//   logg(CacheHelper.getData(key: 'token') + '\n Saved to cache');
//
//   isUserAuth(userSignUpModel.data!.token.toString());
//
//   //
//   // SplashCubit.get(context).getConfig();
//   // SplashCubit.get(context).getAddresses();
//
//   navigateToWithoutNavBar(
//       context, const MainAppMaterialApp(), MainLayout.routeName);
//
//
//   //should navigate to MainLayout
// }

// Future<bool> isUserAuthh(String token) async {
//   bool isAuth = false;
//   UserInfoModel? userInfoModel;
//
//   await MainDioHelper.getData(url: userInfoEnd, token: token).then((value) {
//     logg('Saving userInfo to model');
//
//     logg(value.data['data']['email'].toString());
//     try {
//       userInfoModel = UserInfoModel.fromJson(value.data);
//       logg('userInfo Saved to model: ' + userInfoModel.toString());
//     } catch (error) {
//       logg('error is: #@' + error.toString());
//     }
//     // try {
//     //   userInfoAllDetails = UserInfoModel.fromJson(value.data);
//     //   logg('userInfo Saved to model');
//     // } catch (error) {
//     //   logg('error is: #@' + error.toString());
//     // }
//
//     if (userInfoModel != null) {
//       if (userInfoModel!.data!.email!.length > 2) {
//         logg('token is authorized');
//         // if (userInfoAllDetails != null) {
//         //   savePayoutCachedValues(
//         //       [userInfoAllDetails.data!.payoutInfo!.bankName.toString(),
//         //         userInfoAllDetails.data!.payoutInfo!.holderName.toString(),
//         //         userInfoAllDetails.data!.payoutInfo!.iban.toString(),
//         //         userInfoAllDetails.data!.payoutInfo!.accountNumber.toString(),
//         //       ]
//         //   );
//         //   // [0]: bank name
//         //   // [1]: holder name
//         //   // [2]: iban
//         //   // [3]: account Number
//         // }
//         isAuth = true;
//       }
//     }
//   }).catchError((error) {
//     logg('an error occurred');
//     logg(error.toString());
//   });
//
//   return isAuth;
// }
bool isUserSignedIn(String? token) {
  if (token != null) {
    return true;
  }
  return false;
}

// Future<void> _launchUrl(Uri url) async {
//   if (!await launchUrl(url)) {
//     throw 'Could not launch $url';
//   }
// }

TextStyle mainStyle(BuildContext context, double? size,
    {FontWeight? weight,
    Color? color,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    double? letterSpacing,
    bool isBold = false,
    String? fontFamily,
    Locale? appLocale,
    double? textHeight}) {
  return TextStyle(
    textBaseline: TextBaseline.alphabetic,
    color: color ?? const Color.fromRGBO(0, 0, 0, 1),
    fontFamily:

        /// will check if there is font family then if app locale passed
        fontFamily ??
            (getTranslatedStrings(context).language == 'English'
                ? isBold
                    ? 'VisbyBold'
                    : 'Visby'
                : 'Tajawal'),
    fontSize: size == null ? 14.sp : size * 1.05.sp,
    decoration: decoration,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing ?? 0.5,
    /*percentages not used in flutter.
    defaulting to zero*/

    fontWeight: weight ?? FontWeight.normal,
    height: textHeight ?? 1.1,
  );
}

Widget heightBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget widthBox(double width) {
  return SizedBox(
    width: width,
  );
}

Future<void> buildShowModalBottomSheet(BuildContext context,
    {required Widget body, Color? backColor, bool isDismissible = true}) async {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    // useSafeArea: true,
    backgroundColor: backColor ?? Colors.white,
    // clipBehavior: Clip.hardEdge,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: body,
      );
    },
  );
}

String getFormattedDate(DateTime date) {
  DateTime now = new DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(date.year, date.month, date.day);
  if (aDate == today) {
    return 'Today ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
  } else if (aDate == yesterday) {
    return 'Yesterday ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
  } else {
    return '${date.year}/${date.month < 10 ? date.month.toString().padLeft(2, '0') : date.month.toString()}/${date.day < 10 ? date.day.toString().padLeft(2, '0') : date.day.toString()}   ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
  }
  // return '${date.year}/${date.month}/${date.day}   ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedDateWithAMPM(DateTime date) {
  DateTime now = new DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(date.year, date.month, date.day);
  if (aDate == today) {
    return 'Today ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
  } else if (aDate == yesterday) {
    return 'Yesterday ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
  } else {
    return DateFormat('MM-dd-yyyy / hh:mm a').format(date);
  }
  // return '${date.year}/${date.month}/${date.day}   ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedDateOnlyDate(DateTime date) {
  DateTime now = new DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  final aDate = DateTime(date.year, date.month, date.day);

  if (aDate == today) {
    return 'Today ';
  } else if (aDate == yesterday) {
    return 'Yesterday';
  } else {
    return '${date.year}/${date.month < 10 ? date.month.toString().padLeft(2, '0') : date.month.toString()}/${date.day < 10 ? date.day.toString().padLeft(2, '0') : date.day.toString()}';
  }
  // return '${date.year}/${date.month}/${date.day}   ${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedDateOnlyTime(DateTime date) {
  return DateFormat('hh:mm a').format(date);
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedNumberWithKandM(String num) {
  double val = double.parse(num);
  if (val >= 1000000) {
    return '${(val / 1000000).toString().split('.')[0]} M';

    // if (val % 1000000 == 0) {
    //   return '${(val / 1000000).toString().split('.')[0]} M';
    // }
    // return '${val / 1000000} M';
  } else if (val >= 1000) {
    return '${(val / 1000).toString().split('.')[0]} K';
    //
    // if (val % 1000 == 0) {
    //   return '${(val / 1000).toString().split('.')[0]} K';
    // }
    // return '${val / 1000} K';
  } else
    return num;
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedDateWithDayName(DateTime date) {
  return DateFormat('EEEE, d MMM  ' 'yyyy').format(date);
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedDateOnlyDayName(DateTime date) {
  return DateFormat('EEEE').format(date);
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getFormattedUserName(User user) {
  return user.fullName!.contains(' ')
      ?

      /// contains spaces
      user.fullName!.split(' ').length > 2

          /// more than 2 word
          ? '${user.abbreviation == null ? '' : user.abbreviation!.name == '' ? '' : user.abbreviation!.name! + ' '}${user.fullName!.split(' ')[0]} ${user.fullName!.split(' ')[1]} ...'
          : user.fullName!.split(' ').length > 1
              ?

              /// 2 words

              '${user.abbreviation == null ? '' : user.abbreviation!.name == '' ? '' : user.abbreviation!.name! + ' '}${user.fullName!.split(' ')[0]} ${user.fullName!.split(' ')[1]}'
              :

              /// 1 word
              '${user.abbreviation == null ? '' : user.abbreviation!.name == '' ? '' : user.abbreviation!.name! + ' '}${user.fullName!.split(' ')[0]}'
      :

      /// doesn't contains spaces
      '${user.abbreviation == null ? '' : user.abbreviation!.name == '' ? '' : user.abbreviation!.name! + ' '}${user.fullName}';
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getIsTodayOrYesterday(DateTime date) {
  DateTime now = new DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(date.year, date.month, date.day);

  if (aDate == today) {
    return 'Today ';
  } else if (aDate == yesterday) {
    return 'Yesterday';
  }
  return '';
  // return '${date.hour < 10 ? date.hour.toString().padLeft(2, '0') : date.hour.toString()}:${date.minute < 10 ? date.minute.toString().padLeft(2, '0') : date.minute.toString()}';
}

String getWeekDayOrder(String day) {
  switch (day.toLowerCase()) {
    case 'saturday':
      return '0';
    case 'sunday':
      return '1';

    case 'monday':
      return '2';

    case 'tuesday':
      return '3';

    case 'wednesday':
      return '4';

    case 'thursday':
      return '5';

    case 'friday':
      return '6';

    default:
      return '-';
  }
}

String getDayOfWeekByOrder(int day) {
  switch (day) {
    case 0:
      return 'Saturday';
    case 1:
      return 'Sunday';
    case 2:
      return 'Monday';
    case 3:
      return 'Tuesday';
    case 4:
      return 'Wednesday';
    case 5:
      return 'Thursday';
    case 6:
      return 'Friday';
    default:
      return '-';
  }
}
