import 'package:flutter/material.dart';
import 'package:mena/core/constants/Colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color bgColor;
  final String  title;
  final VoidCallback btnClick;
  final double textSize;
  final Color textColor;

  const CustomButtonWidget(
      {super.key,
      required this.height,
      required this.radius,
      required this.width,
      required this.bgColor,
      required this.title,
      required this.btnClick,
      required this.textSize,
      required this.textColor,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontFamily: AppFonts.interFont,
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: -0.14,
            ),
          ),
        ),
      ),
    );
  }
}
