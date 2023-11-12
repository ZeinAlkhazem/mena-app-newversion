import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class TabItemWidget extends StatelessWidget {
  final String title;

  // final String iconBlueUrl;
  // final String iconGrayUrl;
  final int counter;
  final bool isSelected;
  final VoidCallback btnClick;

  const TabItemWidget(
      {super.key,
      required this.title,
      // required this.iconBlueUrl,
      // required this.iconGrayUrl,
      this.counter=0,
      required this.btnClick,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      child: Container(
        margin:EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.activeBgTabColor : AppColors.deActiveBgTabColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            counter != 0?
                CircleAvatar(
                  backgroundColor: isSelected ? Colors.white : Colors.red,
                  maxRadius: 8.r,
                )
                :SizedBox(),
            SizedBox(
              width: counter!=0?10.w:1.w,
            ),
            Text(
              title,
              textAlign: TextAlign.justify,
              style: mainStyle(context, 12.sp,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.openSansFont,
                  color: isSelected ? AppColors.activeFontTabColor: AppColors.deActiveFontTabColor),
            ),
            SizedBox(
              width: counter!=0?10.w:1.w,
            ),
            counter!=0?Text(
              counter.toString(),
              textAlign: TextAlign.justify,
              style: mainStyle(context, 12.sp,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.openSansFont,
                  color: isSelected ? Colors.white : Colors.red),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
