import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/messenger/widget/custom_button_widget.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

void alertBottomSheetDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required VoidCallback btnOk}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
    ),
    isScrollControlled: true,
    backgroundColor: AppColors.alertBgColor,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
          left: Radius.circular(15.r),
          right: Radius.circular(15.r),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 5.h,
            ),
            Container(
              height: 5.h,
              width: 40.w,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50.r)),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: mainStyle(
                context,
                15.sp,
                weight: FontWeight.w500,
                color: Color(0xFF19191A),
                fontFamily: AppFonts.interFont,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Divider(),
            SizedBox(
              height: 8.h,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: mainStyle(
                context,
                11.sp,
                weight: FontWeight.w400,
                color: Color(0xFF445154),
                fontFamily: AppFonts.interFont,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CustomButtonWidget(
                  width: 105.w,
                  height: 34.h,
                  radius: 5.r,
                  bgColor: Color(0xFFCBCCCD),
                  title: getTranslatedStrings(context).no,
                  btnClick: () => Navigator.of(context).pop(),
                  textSize: 14.sp,
                  textColor: Colors.white,
                ),
                SizedBox(width: 50.w),
                CustomButtonWidget(
                  width: 105.w,
                  height: 34.h,
                  radius: 5.r,
                  bgColor: Color(0xFF2788E8),
                  title: getTranslatedStrings(context).yes,
                  btnClick: () {},
                  textSize: 14.sp,
                  textColor: Colors.white,
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
