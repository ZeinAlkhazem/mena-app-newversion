// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoTitleWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String? descInfo;
  const InfoTitleWidget({
    super.key,
    required this.title,
    required this.desc,
    this.descInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF286294),
            fontSize: 16.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (descInfo == null)
          Text(
            desc,
            style: TextStyle(
              color: const Color(0xFF444444),
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )
        else
          Row(
            children: [
              Text(
                desc,
                style: TextStyle(
                  color: const Color(0xFF444444),
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                descInfo!,
                style: TextStyle(
                  color: const Color(0xFFB2B3B5),
                  fontSize: 10.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
