// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:

class MoreCard extends StatelessWidget {
  const MoreCard({
    super.key,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
  });

  final String title;
  final String trailingIcon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SvgPicture.asset(trailingIcon),
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
