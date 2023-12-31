import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';

class LiveOptionButton extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback btnClick;
  final double iconSize;
  final double hieght;
  final double top;
  final double bottom;

  const LiveOptionButton(
      {super.key,
      required this.btnClick,
      this.hieght = 7,
      this.top = 1,
      this.bottom = 1,
      this.iconSize = 39.0,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      child: Container(
        padding: EdgeInsets.only(top: top, bottom: bottom),
        // width: 60.w,
        // height: 100.h,
        // margin: EdgeInsets.symmetric(
        //   horizontal: 10.w
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: iconSize,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            heightBox(hieght.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'PNfont',
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w200),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveOptionButtonExtra extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback btnClick;
  final double iconSize;
  final double width;

  const LiveOptionButtonExtra(
      {super.key,
      required this.btnClick,
      this.iconSize = 60.0,
      this.width = 7,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: iconSize,
            fit: BoxFit.contain,
          ),
          widthBox(width.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'PNfont',
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }
}
