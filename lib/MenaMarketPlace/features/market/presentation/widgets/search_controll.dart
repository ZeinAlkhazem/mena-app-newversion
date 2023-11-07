import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../../../../../core/constants/constants.dart';
import 'search_box.dart';

class SearchControll extends StatelessWidget {
  const SearchControll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/menamarket/qr_code_outline_28.svg",
            color: newDarkGreyColor,
          ),
          widthBox(8.w),
          Flexible(child: SearchBox()),
          widthBox(8.w),
          Image.asset("assets/flags/eg.png", width: 40.w),
        ],
      ),
    );
  }
}
