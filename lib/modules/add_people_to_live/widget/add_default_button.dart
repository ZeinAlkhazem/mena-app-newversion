import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class AddDefaultButton extends StatelessWidget {
  const AddDefaultButton({
    Key? key,
    required this.onClick,
    this.height,
    this.width,
    this.radius,
    this.fontSize,
    this.customChild,
    this.titleColor,
    this.withoutPadding = false,
    required this.isCoHost,
  }) : super(key: key);
  final Function() onClick;
  final double? height;
  final double? width;
  final double? radius;
  final bool withoutPadding;
  final double? fontSize;
  final Widget? customChild;
  final Color? titleColor;
  final bool isCoHost;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(radius ?? defaultRadiusVal),
      ),
      color: newLightGreyColor,
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? defaultRadiusVal),
            ),
            border: Border.all(width: 1.0, color: newLightGreyColor),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: withoutPadding ? 0 : 5,
              vertical: withoutPadding ? 0 : 10),
          child: customChild ??
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isCoHost
                        ? Icon(Icons.remove, color: alertRedColor)
                        : Icon(Icons.add, color: mainBlueColor),
                    Text(
                      isCoHost ? "Remove" : "Add",
                      textAlign: TextAlign.center,
                      style: mainStyle(
                          context,
                          isBold: true,
                          fontSize ?? 14,
                          color: titleColor ?? Colors.white),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
