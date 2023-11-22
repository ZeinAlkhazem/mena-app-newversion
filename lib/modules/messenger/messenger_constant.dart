import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';

class MessengerConstant{
  static double titleFontSize = 18.sp;
  static Color titleFontColor = Color(0xFF444444);

  TextStyle titleStyle(BuildContext context,
      {FontWeight? weight,
        Color? color,
        TextDecoration? decoration,
        FontStyle? fontStyle,
        double? letterSpacing,
        bool isBold = false,
        String? fontFamily,
        Locale? appLocale,
        double? textHeight}) {
    return TextStyle(
      textBaseline: TextBaseline.alphabetic,
      color: titleFontColor,
      fontFamily:AppFonts.interFont,
      fontSize: titleFontSize,
      decoration: decoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing ?? 0.5,
      fontWeight: weight ?? FontWeight.normal,
      height: textHeight ?? 1.1,
    );
  }
}