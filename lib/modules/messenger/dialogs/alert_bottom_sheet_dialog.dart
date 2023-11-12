import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

void alertBottomSheetDialog(
    {required BuildContext context,
    required String title,
    required String message,required VoidCallback btnOk}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //       top: Radius.circular(35.r), bottom: Radius.circular(35.r)),
    // ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.alertBgColor,
          borderRadius: BorderRadius.circular(25.r),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: mainStyle(
                  context,
                  12.sp,
                  weight: FontWeight.w700,
                  color: AppColors.grayDarkColor,
                  fontFamily: AppFonts.openSansFont,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              message,
              textAlign: TextAlign.start,
              style: mainStyle(
                context,
                10.sp,
                weight: FontWeight.w400,
                color: Colors.black,
                fontFamily: AppFonts.openSansFont,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: btnOk,
                  child: Text(
                    getTranslatedStrings(context).yes,
                    textAlign: TextAlign.start,
                    style: mainStyle(
                      context,
                      12.sp,
                      weight: FontWeight.w700,
                      color: AppColors.grayDarkColor,
                      fontFamily: AppFonts.openSansFont,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                  child: VerticalDivider(
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: ()=>Navigator.of(context).pop(),
                  child: Text(
                    getTranslatedStrings(context).no,
                    textAlign: TextAlign.start,
                    style: mainStyle(
                      context,
                      12.sp,
                      weight: FontWeight.w700,
                      color: AppColors.grayDarkColor,
                      fontFamily: AppFonts.openSansFont,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
