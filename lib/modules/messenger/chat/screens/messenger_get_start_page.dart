import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import 'messenger_home_page.dart';


class MessengerGetStartPage extends StatelessWidget {
  const MessengerGetStartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: SvgPicture.asset(
                '$messengerAssets/icon_back.svg',
                color: AppColors.iconsColor,
                width: 20.w,
              ),
            ),
          ),
          centerTitle: false,
          title: SvgPicture.asset(
            "$messengerAssets/icon_mena_messenger_color_hor.svg",
            height: 25.h,
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          actions: [],
        ),
        body: SizedBox(
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.25.sh,
              ),
              Container(
                // height: ScreenUtil().screenHeight * 0.25,
                width: ScreenUtil().screenWidth * 0.75,

                padding: EdgeInsets.only(
                    top: 5.h, bottom: 5.h, right: 35.w, left: 35.w),
                child: Image.asset("$messengerAssets/img_mena_welcome.gif",
                    width: 50.w, height: 75.w),
              ),
              heightBox(
                1.h,
              ),
              Text(
                getTranslatedStrings(context).menaMessenger,
                style: mainStyle(
                  context,
                  22.sp,
                  fontFamily: AppFonts.interFont,
                  weight: FontWeight.normal,
                  color: AppColors.grayDarkColor,
                ),
              ),
              heightBox(
                10.h,
              ),
              SizedBox(
                width:308.w,
                child: Text(
                  getTranslatedStrings(context).messengerDescription,
                  textAlign: TextAlign.center,
                  style: mainStyle(
                    context, 10.sp,
                    weight: FontWeight.normal,
                    color: AppColors.grayColor,
                    fontFamily: AppFonts.interFont,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: ScreenUtil().screenHeight * 0.17,
          child: Column(
            children: [
              _termsTextWidget(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: InkWell(
                  onTap: () {
                    navigateTo(context, MessengerHomePage());
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth * 0.75,
                    height: 38.h,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Color(0xFF2788E8),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Center(
                      child: Text(
                        getTranslatedStrings(context).agreeAndContinue,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: AppFonts.interFont,
                            height: 1.1,
                            fontWeight: FontWeight.w500),
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

  // Widget _rowItemTextWidget(
  //     {required BuildContext context, required String text}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
  //     child: Text(
  //       text,
  //       style: mainStyle(context, 10.sp,
  //           weight: FontWeight.w400,
  //           color: AppColors.grayGreenColor,
  //           fontFamily: AppFonts.openSansFont,
  //           textHeight: 1.5),
  //       textAlign: TextAlign.justify,
  //     ),
  //   );
  // }

  Widget _termsTextWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: getTranslatedStrings(context).termsOfServiceDescriptionPart1,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: AppColors.grayColor,
            fontSize: 12.sp,
            fontFamily: AppFonts.interFont,
          ),
          children: <TextSpan>[
            TextSpan(
                text: getTranslatedStrings(context).termsOfService,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: AppColors.blueDarkColor,
                  fontFamily: AppFonts.interFont,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: getTranslatedStrings(context)
                    .termsOfServiceDescriptionPart2,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: AppColors.grayColor,
                  fontFamily: AppFonts.interFont,
                )),
          ],
        ),
      ),
    );
  }
}
