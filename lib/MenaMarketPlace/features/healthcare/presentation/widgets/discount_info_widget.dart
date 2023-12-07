import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountInfoWidget extends StatelessWidget {
  final String oldPrice;
  final String discount;
  const DiscountInfoWidget({
    super.key,
    required this.oldPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          oldPrice,
          style: TextStyle(
            color: const Color(0xFFB2B3B5),
            decoration: TextDecoration.lineThrough,
            fontSize: 13.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          discount,
          style: const TextStyle(
            color: Color(0xFF1FBC5E),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}