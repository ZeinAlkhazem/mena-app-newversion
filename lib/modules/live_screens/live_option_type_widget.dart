import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/functions/main_funcs.dart';

class LiveOptionTypeWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback btnClick;
  const LiveOptionTypeWidget({super.key,required this.title,required this.btnClick,required this.icon});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (icon.endsWith('.svg')) {
      // If the imageAsset is an SVG file, use SvgPicture
      imageWidget = SvgPicture.asset(
        icon,
        // Adjust the size as needed
      );
    } else {
      // If it's not an SVG, use Image.asset
      imageWidget = Image.asset(
        icon,
      );
    }

    return Container(
      width: 60.w,
      padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 10.h
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 25.w,
              height: 30.h,
              child: imageWidget),
          heightBox(5.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'PNfont',
              color: Color(0xff152026),
            ),
          ),
        ],
      ),
    );
  }
}
