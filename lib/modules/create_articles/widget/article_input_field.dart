import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';

class ArticleInputField extends StatelessWidget {
  const ArticleInputField({
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
    this.minLines,
    this.onTap,
    this.readOnly = false,
    this.validate,
    this.onFieldChanged,
    this.withoutLabelPadding = false,
    this.customTextInputType,
    this.floatingLabelAlignment,
    this.floatingLabelBehavior,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.edgeInsetsGeometry, this.enabled,
  }) : super(key: key);

  final String? label;
  final String? customHintText;
  final bool withoutLabelPadding;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool? enabled;
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
  final int? minLines;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextInputType? customTextInputType;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
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
        filled: true,
        
        hintText: customHintText ?? label ?? '...',
        floatingLabelAlignment: floatingLabelAlignment,
        floatingLabelBehavior:
            floatingLabelBehavior ?? FloatingLabelBehavior.never,
        hintStyle: mainStyle(context, 12,
            color: newLightGreyColor, weight: FontWeight.w400),
        contentPadding: edgeInsetsGeometry ??
            EdgeInsets.symmetric(
                vertical: Responsive.isMobile(context) ? 15 : 20.0,
                horizontal: 10.0),
        border:  OutlineInputBorder(
            borderRadius:BorderRadius.circular(20.0)
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: suffixIcon,
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
        labelStyle: mainStyle(context, 13,
            color:  AppColors.textGray, weight: FontWeight.w600),
        label: Text(label ?? ''),
        fillColor: Colors.white,

        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: unFocusedBorderColor ?? Colors.red, width: 1),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: unFocusedBorderColor ?? Colors.red.withOpacity(0.6),
                width: 1),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: focusedBorderColor ?? mainBlueColor, width: 1.0),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: unFocusedBorderColor ?? AppColors.textGray,
                width: .5),
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? defaultRadiusVal))),
      ),
      validator: validate,
      minLines: minLines??1,
      maxLines: maxLines ?? 1,
    );
  }
}

String? Function(String?)? normalInputValidate(BuildContext context,
    {String? customText}) {
  return (String? val) {
    if (val!.isEmpty) {
      return customText;
    }
    return null;
  };
}
