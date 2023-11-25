import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/functions/main_funcs.dart';


void blockReportBottomSheetDialog(
    {required BuildContext context,
      required VoidCallback btnBlock,
      required VoidCallback btnReport,
    }) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 25.h,
            ),
            InkWell(
              onTap:btnBlock,
              child: SizedBox(
                width: 0.8.sh,
                child: Text(
                  getTranslatedStrings(context).blockAccount,
                  textAlign: TextAlign.start,
                  style: mainStyle(
                    context,
                    12.sp,
                    weight: FontWeight.w500,
                    color: AppColors.grayDarkColor,
                    fontFamily: AppFonts.openSansFont,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            InkWell(
              onTap: btnReport,
              child: SizedBox(
                width: 0.8.sh,
                child: Text(
                  getTranslatedStrings(context).report,
                  textAlign: TextAlign.start,
                  style: mainStyle(
                    context,
                    12.sp,
                    weight: FontWeight.w500,
                    color: AppColors.grayDarkColor,
                    fontFamily: AppFonts.openSansFont,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
          ],
        ),
      );
    },
  );
}
