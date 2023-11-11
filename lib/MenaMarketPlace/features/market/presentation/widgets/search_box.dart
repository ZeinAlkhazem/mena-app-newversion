import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
  });

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
        hintText: "Search Products / Suppliers",
        hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w900,
            fontSize: 12),
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SvgPicture.asset(
            "assets/menamarket/camera_outline_56.svg",
            width: 30.w,
            color: Colors.grey.shade600,
            height: 30.w,
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxWidth: 40.w),
        suffixIconConstraints: BoxConstraints(maxWidth: 40.w),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SvgPicture.asset(
            "assets/menamarket/search_outline_56.svg",
            width: 30.w,
            color: Colors.grey.shade600,
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
