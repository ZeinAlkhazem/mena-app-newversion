import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/modules/messenger/screens/messenger_home_page.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../users_to_start_chat.dart';

class MessengerGetStartPage extends StatelessWidget {


  const MessengerGetStartPage(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// back icon button
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: SvgPicture.asset(
                    '$messengerAssets/icon_back.svg',
                    color: AppColors.iconsColor,
                    width: 20.w,
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight * 0.25,
              width: ScreenUtil().screenWidth * 0.75,
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 70.h, right: 35.w, left: 35.w),
              child: SvgPicture.asset("assets/icons/messenger/icon_mena_messenger_colors.svg", width: 50.w, height: 75.w),
            ),
            heightBox(
              1.h,
            ),
            Text(
              getTranslatedStrings(context)
                  .welcomeToMenaMessenger,
              style: mainStyle(context, 14.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w900,
                  color: AppColors.grayDarkColor,
                  isBold: true),
            ),
            heightBox(
              25.h,
            ),
            SizedBox(
              width: ScreenUtil().screenWidth * 0.85,
              child: Text(
               " getTranslatedStrings(context).messengerDescription1",
                style: mainStyle(context, 10.sp,
                    weight: FontWeight.w700,
                    color: AppColors.grayGreenColor,
                    fontFamily: AppFonts.openSansFont,
                    textHeight: 1.1),
                textAlign: TextAlign.justify,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 35.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowItemTextWidget(
                    context: context, text: " getTranslatedStrings(context).messengerDescription2",),
                  _rowItemTextWidget(
                    context: context,
                    text:
              "      getTranslatedStrings(context).messengerDescription3",),
                  _rowItemTextWidget(
                    context: context,
                    text:
                   " getTranslatedStrings(context).messengerDescription4",),
                  heightBox(
                    30.h,
                  ),
                ],
              ),
            ),

          ],
        ),
        bottomNavigationBar: SizedBox(
          height: ScreenUtil().screenHeight * 0.15,
          child: Column(
            children: [
              _termsTextWidget(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: InkWell(
                  onTap: (){
                    navigateTo(context, MessengerHomePage());
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth * 0.9,
                    height: 45.h,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: AppColors.lineBlue,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: Text(
                        getTranslatedStrings(context).startMessaging,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.whiteCreamColor,
                            fontSize: 14.sp,
                            fontFamily: AppFonts.openSansFont,
                            height: 1.1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowItemTextWidget(
      {required BuildContext context, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Text(
        text,
        style: mainStyle(context, 10.sp,
            weight: FontWeight.w400,
            color: AppColors.grayGreenColor,
            fontFamily: AppFonts.openSansFont,
            textHeight: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _termsTextWidget(BuildContext context){
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RichText(
        text: TextSpan(
          text:
         " getTranslatedStrings(context).termsOfServiceDescriptionPart1",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 11.sp,
            fontFamily: AppFonts.openSansFont,
          ),
          children: <TextSpan>[
            TextSpan(
                text: "getTranslatedStrings(context).termsOfService,",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueDarkColor,
                  fontFamily: AppFonts.openSansFont,
                ),
                recognizer: TapGestureRecognizer()..onTap =(){

                }
            ),
            TextSpan(
                text:" getTranslatedStrings(context).termsOfServiceDescriptionPart2",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontFamily: AppFonts.openSansFont,
                )),
          ],
        ),
      ),
    );
  }
}