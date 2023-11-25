import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';


class ArchivedButtonWidget extends StatelessWidget {
  const ArchivedButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 20.w,
            width: 20.w,
            child: SvgPicture.asset(
              "$messengerAssets/icon_archived.svg",
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            getTranslatedStrings(context)
                .messengerArchived,
            style: mainStyle(context, 14.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w600,
                color: Color(0xFF19191A),
                textHeight: 1.1),
          ),
        ],
      ),
    );
  }
}
