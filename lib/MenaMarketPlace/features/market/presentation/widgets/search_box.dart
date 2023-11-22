// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/Colors.dart';
import 'select_scanner_mode.dart';

class SearchBox extends StatelessWidget {
  
  final String hint;
  const SearchBox({
    Key? key,
    
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? searchController = TextEditingController();
    return TextFormField(
      controller: searchController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        filled: true,
        errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w900,
            fontSize: 12),
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        suffixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: InkWell(
            onTap: () {
              selectScannerMode(
                context,
              );
            },
            child: SvgPicture.asset(
              "assets/menamarket/qr_code_outline_28.svg",
              color: AppColors.grayColor,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: 40.w),
        suffixIconConstraints: BoxConstraints(maxWidth: 40.w),
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(
            "assets/menamarket/search_outline_56.svg",
            width: 30.w,
            color: Colors.grey.shade500,
            height: 30.w,
            fit: BoxFit.contain,
          ),
        ),
        fillColor: Color(0xfff2f2f2),
        focusColor: Colors.grey,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff0077FF), width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff999B9D), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff999B9D), width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      onFieldSubmitted: (value) async {},
    );
  }
}
