import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class EmptyNewMessageWidget extends StatelessWidget {
  final String content;
  const EmptyNewMessageWidget({super.key,required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: ScreenUtil().screenWidth * 0.75,
          height: 250.h,
          padding: EdgeInsets.zero,
          child: Lottie.asset(
            'assets/icons/messenger/chat_bubble_animate.json',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.w),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            style: mainStyle(context, 10.sp,
                weight: FontWeight.w400,
                color: AppColors.grayGreenColor,
                fontFamily: AppFonts.openSansFont,
                textHeight: 1.1),
          ),
        ),
      ],
    );
  }
}
