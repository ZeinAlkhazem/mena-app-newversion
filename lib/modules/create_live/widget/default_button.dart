import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class DefaultButtonLive extends StatelessWidget {
  const DefaultButtonLive({
    Key? key,
    required this.text,
    required this.onClick,
    this.height,
    this.width,
    this.radius,
    this.fontSize,
    this.backColor,
    this.borderColor,
    this.customChild,
    this.titleColor,
    this.withoutPadding = false,
    this.isEnabled = true,
  }) : super(key: key);
  final String text;
  final Function() onClick;
  final double? height;
  final double? width;
  final double? radius;
  final bool withoutPadding;
  final double? fontSize;
  final Widget? customChild;
  final Color? backColor;
  final Color? borderColor;
  final Color? titleColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onClick : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? defaultRadiusVal),
          ),
          border: Border.all(
              width: 1.0,
              color:
                  isEnabled ? borderColor ?? mainBlueColor : disabledGreyColor),
          color: isEnabled ? backColor ?? mainBlueColor : disabledGreyColor,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: withoutPadding ? 0 : 5,
            vertical: withoutPadding ? 0 : 10),
        child: customChild ??
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: mainStyle(
                    context,
                    isBold: true,
                    fontSize ?? 14.sp,
                    color: titleColor ?? Colors.white),
              ),
            ),
      ),
    );
  }
}
