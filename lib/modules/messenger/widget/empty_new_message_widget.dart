import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class EmptyNewMessageWidget extends StatelessWidget {
  final String content;

  const EmptyNewMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: ScreenUtil().screenWidth * 0.75,
          height: 200.h,
          padding: EdgeInsets.zero,
          child: Lottie.asset(
            '$messengerAssets/chat_bubble_animate.json',
          ),
        ),
        Center(
          child: Container(
            width: 325.w,
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: mainStyle(context, 10.sp,
                  weight: FontWeight.normal,
                  color: Color(0xFF999B9D),
                  fontFamily: AppFonts.interFont,
                  textHeight: 1.1),
            ),
          ),
        ),
      ],
    );
  }
}
