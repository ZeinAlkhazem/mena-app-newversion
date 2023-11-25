import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';


class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 20.w,
        height: 28.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        padding: EdgeInsets.only(left: 13.w, right: 8.w),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 20.w,
                height: 28.h,
                child: Stack(children: [
                  SvgPicture.asset(
                    "$messengerAssets/icon_back.svg",
                    // fit: BoxFit.contain,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),);
  }
}
