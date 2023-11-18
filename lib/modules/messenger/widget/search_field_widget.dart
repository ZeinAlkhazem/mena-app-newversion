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
              style: mainStyle(
                context,
                16.sp,
                fontFamily: AppFonts.interFont,
                color: Color(0xFF5B5C5E),
                weight: FontWeight.w600,
                textHeight: 0,
                letterSpacing: 0.24,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: Container(
              width: 314.w,
              height: 37.h,
              padding: const EdgeInsets.only(
                top: 12,
                left: 16,
                right: 8,
                bottom: 12,
              ),
              decoration: ShapeDecoration(
                color: Color(0xFFF2F3F5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            child: SvgPicture.asset(
                              "$messengerAssets/icon_search_field.svg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.h,
                    ),
                    child: Text(
                      getTranslatedStrings(context).search,
                      style: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0.07,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ),
                ],
              ),
            )

                // DefaultInputField(
                //   onFieldChanged: (text) {},
                //   // fillColor: hasError?Color(0xffF2D5D5):null,
                //   label: getTranslatedStrings(context).search,
                //   focusedBorderColor: Colors.white,
                //   unFocusedBorderColor: Colors.white,
                //   borderRadius: 10.r,
                //   labelTextStyle: TextStyle(
                //     fontSize: 14.sp,
                //     fontFamily: AppFonts.interFont,
                //     color: Color(0xFF979797),
                //     fontWeight: FontWeight.w400,
                //     height: 0.07,
                //     letterSpacing: -0.14,
                //   ),
                //   prefixWidget: Container(
                //     width: 12,
                //     height: 12,
                //     child: Stack(
                //       children: [
                //         Center(
                //           child: Container(
                //             width: 12,
                //             height: 12,
                //             child: SvgPicture.asset(
                //               "$messengerAssets/icon_search_field.svg",
                //
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //
                //   //
                //   // SizedBox(
                //   //   height: 12.w,
                //   //   width: 12.w,
                //   //   child: SvgPicture.asset(
                //   //     "$messengerAssets/icon_search_field.svg",
                //   //     // color: AppColors.grayDarkColor,
                //   //   ),
                //   // ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
