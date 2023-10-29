import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconButtonWidget extends StatelessWidget {
  final String iconUrl;
  final VoidCallback btnClick;
  const IconButtonWidget({super.key,required this.iconUrl,required this.btnClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w
      ),
      child: InkWell(
        onTap:btnClick,
        child: SvgPicture.asset(iconUrl,width: 10.w,height: 20.h),
      ),
    );
  }
}
