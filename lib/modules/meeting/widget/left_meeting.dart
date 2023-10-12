import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class LeftMeeting extends StatelessWidget {
  const LeftMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/live_icon/hand.png',
        ),
        heightBox(24.h),
        Text(
          'You left the Meeting',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        heightBox(24.h),
        Text(
          'Have a nice day!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        heightBox(24.h),
        Text(
          'Left by mistake?',
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        heightBox(24.h),
        TextButton.icon(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            )),
            backgroundColor: MaterialStatePropertyAll(mainBlueColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            maximumSize: MaterialStatePropertyAll(
              Size(100.w, 50.h),
            ),
            minimumSize: MaterialStatePropertyAll(
              Size(100.w, 50.h),
            ),
          ),
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/live_icon/door_arrow_right_outline_20.svg',
          ),
          label: Text(
            "Rejoin",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
