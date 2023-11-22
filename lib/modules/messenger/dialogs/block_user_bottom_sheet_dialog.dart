import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../add_people_to_live/widget/live_bubble.dart';

void blockUserBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
    ),
    isScrollControlled: true,
    backgroundColor:  AppColors.alertBgColor,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
              height: 3.h,
              width: 40.w,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50.r)),
            ),
            SizedBox(
              height: 25.h,
            ),
            // ProfileBubble(
            //   isOnline: false,
            //   pictureUrl:"",
            // ),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "$messengerAssets/icon_user_default.svg",
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Block Username',
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
              height: 25.h,
            ),
            Text(
              "This will also block any other accounts they may have or create in the future",
              textAlign: TextAlign.center,
              style: mainStyle(
                context,
                10.sp,
                weight: FontWeight.w400,
                color: Color(0xFF445154),
                fontFamily: AppFonts.interFont,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            rowItemWidget(
                context: context,
                title: getTranslatedStrings(context).messengerBlockAlert1,
                image: "icon_message_error.svg"),
            rowItemWidget(
                context: context,
                title: getTranslatedStrings(context).messengerBlockAlert2,
                image: "icon_no_notification.svg"),
            rowItemWidget(
                context: context,
                title: getTranslatedStrings(context).messengerBlockAlert3,
                image: "icon_settings.svg"),
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
                onClick: ()=>Navigator.of(context).pop(),
                text: getTranslatedStrings(context).block,
                height: 40.h,
                width: 281.w,
                radius: 10.r,
                backColor: AppColors.lineBlue,
                borderColor: Colors.white,
                customChild: Center(
                  child: Text(
                    getTranslatedStrings(context).block,
                    style: mainStyle(context, 14.sp,
                        color: Colors.white,
                        fontFamily: AppFonts.interFont,
                        weight: FontWeight.w500),
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

Widget rowItemWidget({
  required BuildContext context,
  required String title,
  required String image,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 10.w,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 30.w,
            height: 30.w,
            child: SvgPicture.asset("$messengerAssets/$image")),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 0.65.sw,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: mainStyle(context, 10.sp,
                color: Color(0xFF445154),
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}
