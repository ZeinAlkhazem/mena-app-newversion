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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.arrow_back_ios,
          color: AppColors.whiteCreamColor,
        ),
        Icon(
          Icons.account_circle,
          color: AppColors.whiteCreamColor,
        ),
        Text(
          "Healthcare Market",
          style: mainStyle(context, 20.sp,
              weight: FontWeight.w900,
              fontFamily: "VisbyBold",
              color: AppColors.whiteCreamColor),
        ),
        Icon(
          Icons.add_circle_outline,
          color: AppColors.whiteCreamColor,
        ),
        SvgPicture.asset(
          "assets/menamarket/shopping_cart_outline_28.svg",
          color: AppColors.whiteCreamColor,
        ),
      ],
    );
  }
}
