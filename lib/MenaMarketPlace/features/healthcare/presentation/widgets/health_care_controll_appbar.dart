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
      mainAxisAlignment: MainAxisAlignment.start,
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
        Text(
          "Healthcare Market",
          style: mainStyle(context, 18.sp,
              weight: FontWeight.w500,
              fontFamily: "Roboto",
              color: AppColors.whiteCreamColor),
        ),
        Spacer(),
        Icon(
          Icons.add_circle_outline,
          color: AppColors.whiteCreamColor,
        ),
        widthBox(15.w),
        SvgPicture.asset(
          "assets/menamarket/shopping_cart_outline_28.svg",
          color: AppColors.whiteCreamColor,
        ),
        widthBox(15.w),
        SvgPicture.asset(
          "assets/menamarket/menu_28.svg",
          color: AppColors.whiteCreamColor,
        ),
      ],
    );
  }
}
