import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/Colors.dart';



class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.prefixWidget,
    this.hint,
    this.controller,
    this.inputType,
    required this.obscure,

    this.validator,
    this.isPadding,
    this.onChanged,
    this.suffixIcon,
    this.disableForm,
    this.withoutPadding,
    this.multiLine,
    this.readOnly,
    this.isFilled,
    this.isAlignCenter,
    this.onTap,
    this.onTapOutsidel,
    this.onFieldSubmitted,
    this.isFileWhite,
    this.inputFormatters,
    this.isPromo,
    this.textColor,
    this.fillColor,
    this.hintColor,
    this.isWrite
  });
  final bool? isWrite ;
  final Widget? prefixWidget;
  final Color? fillColor;
  final Color? hintColor;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool obscure;
  final String? Function(String?)? validator;
  final bool? isPadding;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool? disableForm;
  final bool? withoutPadding;
  final bool? multiLine;
  final bool? readOnly;
  final bool? isFilled;
  final bool? isAlignCenter;
  final void Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final void Function(PointerDownEvent)? onTapOutsidel;
  final bool? isFileWhite;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isPromo;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: AppColors.blueDarkColor,

        maxLines: multiLine != null ? 4 : 1,
        enabled: disableForm == null ? true : false,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscure,
        keyboardType: inputType,
        controller: controller,
        onTap: onTap,

        inputFormatters: inputFormatters,
        onTapOutside: onTapOutsidel,
        textAlign: isAlignCenter != null ? TextAlign.center : TextAlign.start,
        readOnly: readOnly ?? false,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color:textColor?? AppColors.white,
            ),
        decoration: InputDecoration(
          errorMaxLines: 3,

          suffixIconConstraints:
              const BoxConstraints(minHeight: 15, minWidth: 15),
          contentPadding: withoutPadding != null
              ? const EdgeInsets.symmetric(horizontal: 4)
              : null,
          filled: isFilled,
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color:hintColor?? AppColors.lineGray ,fontSize: 10),
          hintText: hint,
          fillColor:fillColor?? (isFileWhite == null ? AppColors.lineGray : AppColors.white),


          enabledBorder: readOnly == null
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide.none,
                )
              :        (  readOnly == false && isWrite != true)
                  ? OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3.0)),
                      borderSide: BorderSide( color:AppColors.lineGray ),
                    )
              :  (readOnly == false && isWrite == true )?
          UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white, width: 1))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.white, width: 1)),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color:AppColors.lineGray),
          ),
         focusedErrorBorder: OutlineInputBorder(
           borderRadius:
           const BorderRadius.all(Radius.circular(15.0)),
           borderSide: BorderSide(),
         ),
           errorBorder: OutlineInputBorder(
             borderRadius:
             const BorderRadius.all(Radius.circular(15.0)),
             borderSide: BorderSide(),
           ),
          focusedBorder: readOnly == null
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                )
              :
        (  readOnly == false && isWrite != true)
                  ? OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      borderSide:
                          BorderSide( width: 2),
                    )
                  :  (readOnly == false && isWrite == true )?
          UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.white, width: 1))
          :    UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white, width: 1))
          ,
          prefixIcon: prefixWidget,
          suffixIcon: suffixIcon,
        ));
  }
}
