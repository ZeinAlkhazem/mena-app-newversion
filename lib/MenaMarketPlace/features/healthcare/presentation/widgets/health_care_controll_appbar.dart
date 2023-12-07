import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

class HealthCareControllAppbar extends StatelessWidget {
  const HealthCareControllAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            size: 18,
            Icons.arrow_back_ios,
            color: AppColors.whiteCreamColor,
          ),
        ),
        const Text(
          'Healthcare Market',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.add_circle_outline,
          color: AppColors.whiteCreamColor,
        ),
        widthBox(15.w),
        SvgPicture.asset(
          'assets/menamarket/shopping_cart_outline_28.svg',
          color: AppColors.whiteCreamColor,
        ),
        widthBox(15.w),
        SvgPicture.asset(
          'assets/menamarket/menu_28.svg',
          color: AppColors.whiteCreamColor,
        ),
      ],
    );
  }
}
