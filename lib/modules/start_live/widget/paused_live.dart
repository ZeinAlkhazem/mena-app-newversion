import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/functions/main_funcs.dart';

class PausedLive extends StatelessWidget {
  const PausedLive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/svg/pausedlive.svg',
        ),
        heightBox(20.h),
        SizedBox(
          width: 200.w,
          child: Text(
            "The host has temporarily paused the live broadcast and will return shortly.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
