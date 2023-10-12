
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class IconWithText extends StatelessWidget {
  const IconWithText({
    Key? key,
    required this.text,
    required this.svgAssetLink,
    this.customColor,
    this.customIconColor,
    this.customSize,
    this.inGallery = false,
    this.customFontSize,
  }) : super(key: key);

  final String text;
  final String svgAssetLink;
  final Color? customColor;
  final Color? customIconColor;
  final double? customSize;
  final double? customFontSize;
  final bool inGallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: DefaultContainer(
        radius: 44.sp,
        backColor: inGallery ? Colors.transparent : newLightGreyColor,
        borderColor: inGallery ? Colors.transparent : newLightGreyColor,
        childWidget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgAssetLink,
                height: customSize ?? 18.sp,
                color: customIconColor != null
                    ? customIconColor
                    : inGallery
                    ? Colors.white
                    : newDarkGreyColor,
              ),
              widthBox(6.w),
              Text(
                text,
                style: mainStyle(context, customFontSize ?? 14,
                    weight: FontWeight.w900,
                    letterSpacing: 1,
                    color: inGallery ? Colors.white : newDarkGreyColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class IconWithTextVertical extends StatelessWidget {
  const IconWithTextVertical({
    Key? key,
    required this.text,
    required this.svgAssetLink,
    this.customColor,
    this.customIconColor,
    this.customSize,
    this.inGallery = false,
    this.customFontSize,
  }) : super(key: key);

  final String text;
  final String svgAssetLink;
  final Color? customColor;
  final Color? customIconColor;
  final double? customSize;
  final double? customFontSize;
  final bool inGallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgAssetLink,
            height: customSize ?? 18.sp,
            color: inGallery ? Colors.white : newDarkGreyColor,
          ),
          heightBox(6.h),
          Text(
            text,
            style: mainStyle(context, customFontSize ?? 14,
                weight: FontWeight.w900,
                letterSpacing: 1,
                color: inGallery ? Colors.white : newDarkGreyColor),
          ),
        ],
      ),
    );
  }
}

