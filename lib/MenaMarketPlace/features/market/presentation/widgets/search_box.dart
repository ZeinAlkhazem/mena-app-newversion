// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mena/core/constants/Colors.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/widgets/select_scanner_mode.dart';

class SearchBox extends StatelessWidget {
  final String hint;
  const SearchBox({
    super.key,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return TextFormField(
      controller: searchController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        filled: true,
        errorStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF979797),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0.07,
          letterSpacing: -0.14,
        ),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: InkWell(
            onTap: () {
              selectScannerMode(
                context,
              );
            },
            child: SvgPicture.asset(
              'assets/menamarket/qr_code_outline_28.svg',
              color: const Color(0xff979797),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: 40.w),
        suffixIconConstraints: BoxConstraints(maxWidth: 40.w),
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(
            'assets/menamarket/search_outline_56.svg',
            width: 30.w,
            color: const Color(0xff979797),
            height: 30.w,
          ),
        ),
        fillColor: const Color(0xfff2f2f2),
        focusColor: Colors.grey,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff0077FF)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff999B9D)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff999B9D)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      onFieldSubmitted: (value) async {},
    );
  }
}
