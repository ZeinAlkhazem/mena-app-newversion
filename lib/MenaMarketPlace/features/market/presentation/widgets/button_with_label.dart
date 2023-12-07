import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mena/core/functions/main_funcs.dart';

class ButtonWithLabel extends StatelessWidget {
  final VoidCallback onTap;
  final String btnIcon;
  final String label;
  const ButtonWithLabel({
    super.key,
    required this.onTap,
    required this.btnIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            btnIcon,
            width: 40.w,
          ),
          heightBox(5.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF979797),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
