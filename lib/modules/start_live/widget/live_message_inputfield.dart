// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';

class LiveMessageInputField extends StatelessWidget {
  const LiveMessageInputField({
    Key? key,
    this.label,
    this.suffixIcon,
    this.obscureText,
    this.controller,
    this.focusNode,
    this.customHintText,
    this.unFocusedBorderColor,
    this.focusedBorderColor,
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
    this.prefixIcon,
  }) : super(key: key);

  final String? label;
  final String? customHintText;
  final bool withoutLabelPadding;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? unFocusedBorderColor;
  final Color? focusedBorderColor;
  final Function(String)? onFieldChanged;
  final Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final int? maxLines;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextInputType? customTextInputType;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      onTap: onTap,
      onChanged: onFieldChanged,
      keyboardType: customTextInputType,
      obscureText: obscureText ?? false,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      autofocus: false,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        filled: true,
        hintText: 'message...',
        floatingLabelAlignment: floatingLabelAlignment,
        floatingLabelBehavior:
            floatingLabelBehavior ?? FloatingLabelBehavior.never,
        hintStyle: mainStyle(context, 12.sp,
            color: newLightGreyColor, weight: FontWeight.w700),
        contentPadding: edgeInsetsGeometry ??
            EdgeInsets.symmetric(
                vertical: Responsive.isMobile(context) ? 15 : 20.0,
                horizontal: 10.0),
        border: const OutlineInputBorder(),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: suffixIcon,
        ),
        // suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: prefixIcon,
              ),
        labelStyle: mainStyle(context, 13.sp,
            color: Colors.white, weight: FontWeight.w700),
        label: Text(label ?? ''),
        fillColor: Colors.transparent,
        focusColor: newLightGreyColor,
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: unFocusedBorderColor ?? Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(60.r))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: unFocusedBorderColor ?? Colors.red.withOpacity(0.6),
                width: 1),
            borderRadius: BorderRadius.all(Radius.circular(60.r))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: focusedBorderColor ?? disabledGreyColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(60.r))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    unFocusedBorderColor ?? disabledGreyColor.withOpacity(0.7),
                width: 1),
            borderRadius: BorderRadius.all(Radius.circular(60.r))),
      ),
      validator: validate,
      minLines: 1,
      maxLines: maxLines ?? 1,
    );
  }
}
