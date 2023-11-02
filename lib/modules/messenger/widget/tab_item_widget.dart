import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

class TabItemWidget extends StatelessWidget {
  final String title;
  final String iconBlueUrl;
  final String iconGrayUrl;
  final bool isSelected;
  final VoidCallback btnClick;

  const TabItemWidget(
      {super.key,
      required this.title,
      required this.iconBlueUrl,
      required this.iconGrayUrl,
      required this.btnClick,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
        vertical: 10.h,horizontal: 10.w
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: isSelected ?Color(0xffdadcdc):Colors.white,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected ? iconBlueUrl : iconGrayUrl,
            fit: BoxFit.contain,
            width: 20.w,height: 25.h,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            title,
            textAlign: TextAlign.justify,
            style: mainStyle(context, 10.sp,
                weight: FontWeight.w400,
                fontFamily: AppFonts.openSansFont,
                color: isSelected ?AppColors.iconsColor:AppColors.grayGreenColor),
          ),
        ],
      ),
    );
  }
}
