import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "To",
              textAlign: TextAlign.justify,
              style: mainStyle(context, 12.sp,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.openSansFont,
                  color: AppColors.grayDarkColor),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: DefaultInputField(
                onFieldChanged: (text) {},
                // fillColor: hasError?Color(0xffF2D5D5):null,
                label: getTranslatedStrings(context).search,
                focusedBorderColor: Colors.white,
                unFocusedBorderColor: Colors.white,
                borderRadius: 10.r,
                labelTextStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.openSansFont,
                    color: AppColors.grayDarkColor),
                prefixWidget: SvgPicture.asset(
                  "assets/icons/messenger/icon_search.svg",
                  color: AppColors.grayDarkColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
