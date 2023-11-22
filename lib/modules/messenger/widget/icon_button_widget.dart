import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';

class IconButtonWidget extends StatelessWidget {
  final String iconUrl;
  final VoidCallback btnClick;
  final double iconWidth;
  final double? iconHeight;
  final Color? iconColor;

  const IconButtonWidget(
      {super.key,
      required this.iconUrl,
      required this.btnClick,
      required this.iconWidth,
      this.iconHeight,
      this.iconColor,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      child: Container(
        margin: EdgeInsets. symmetric(vertical: 5.h, horizontal: 5.w),
        width: iconWidth,
        height: iconHeight ?? 10.h,
        child: SvgPicture.asset(
          iconUrl,
          fit: BoxFit.contain,
          color: iconColor ?? AppColors.iconsColor,
        ),
      ),
    );
  }
}
