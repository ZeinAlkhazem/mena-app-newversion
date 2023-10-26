import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';

class ArticleUnderLineInputField extends StatelessWidget {
  const ArticleUnderLineInputField({
    Key? key,
    this.label,
    this.suffixIcon,
    this.obscureText,
    this.controller,
    this.focusNode,
    this.customHintText,
    this.unFocusedBorderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.maxLines,
    this.onTap,
    this.readOnly = false,
    this.validate,
    this.onFieldChanged,
    this.withoutLabelPadding = false,
    this.customTextInputType,
    this.floatingLabelAlignment,
    this.floatingLabelBehavior,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.edgeInsetsGeometry,
  }) : super(key: key);

  final String? label;
  final String? customHintText;
  final bool withoutLabelPadding;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Color? unFocusedBorderColor;
  final Color? focusedBorderColor;
  final Function(String)? onFieldChanged;
  final Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final double? borderRadius;
  final int? maxLines;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextInputType? customTextInputType;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onFieldChanged,
      keyboardType: customTextInputType,
      obscureText: obscureText ?? false,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        filled: false,
        hintText: customHintText ?? label ?? '...',
        floatingLabelAlignment: floatingLabelAlignment,
        floatingLabelBehavior:
        floatingLabelBehavior ?? FloatingLabelBehavior.never,
        hintStyle: mainStyle(context, 12,
            color: newDarkGreyColor, weight: FontWeight.w400),
        contentPadding: edgeInsetsGeometry ??
            EdgeInsets.symmetric(
                vertical: Responsive.isMobile(context) ? 15 : 20.0,
                horizontal: 10.0),
        border:  UnderlineInputBorder(borderSide: BorderSide(color: newDarkGreyColor)),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: suffixIcon,
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
        labelStyle: mainStyle(context, 13,
            color: newDarkGreyColor, weight: FontWeight.w700),
        label: Text(label ?? ''),

        focusColor: newLightGreyColor,
        focusedErrorBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: unFocusedBorderColor ?? Colors.red, width: 1),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: unFocusedBorderColor ?? Colors.red.withOpacity(0.6),
                width: 1),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: focusedBorderColor ?? mainBlueColor, width: 1.0),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: unFocusedBorderColor ?? newDarkGreyColor,
                width: 1),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
      ),
      validator: validate,
      minLines: 1,
      maxLines: maxLines ?? 1,
    );
  }
}


