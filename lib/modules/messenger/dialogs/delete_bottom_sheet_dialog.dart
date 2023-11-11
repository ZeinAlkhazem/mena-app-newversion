import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

void deleteBottomSheetDialog({required BuildContext context,required VoidCallback btnDelete}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
    ),
    isScrollControlled: true,
    backgroundColor:  AppColors.alertBgColor,
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
              height: 10.h,
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
              getTranslatedStrings(context).messengerDeleteMessageRequest,
              textAlign: TextAlign.justify,
              style: mainStyle(
                context,
                12.sp,
                weight: FontWeight.w700,
                color: Colors.black,
                fontFamily: AppFonts.openSansFont,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(),
            SizedBox(
              height: 25.h,
            ),
            Text(
              getTranslatedStrings(context).messengerDeleteMessageMessage,
              textAlign: TextAlign.justify,
              style: mainStyle(
                context,
                12.sp,
                weight: FontWeight.w400,
                // color: AppColors.grayGreenColor,
                color: Color(0xff7F7F7F),
                fontFamily: AppFonts.openSansFont,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Divider(),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              child: DefaultButton(
                onClick: btnDelete,
                text: getTranslatedStrings(context).delete,
                height: 0.06.sh,
                width: 1.sw,
                radius: 10.r,
                backColor: AppColors.lineBlue,
                borderColor: Colors.white,
                customChild: Center(
                  child: Text(
                    getTranslatedStrings(context).delete,
                    style: mainStyle(context, 12.sp,
                        color: Colors.white,
                        fontFamily: AppFonts.openSansFont,
                        weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
