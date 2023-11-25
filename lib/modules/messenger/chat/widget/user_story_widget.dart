import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';

class UserStoryWidget extends StatelessWidget {
  const UserStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 65.w,
            height: 65.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(65.r),
                // color: AppColors.iconsColor,
                border: Border.all(color: Colors.white, width: 2.w)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: DefaultImage(
                backGroundImageUrl:
                    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: 75.w,
            child: Text(
              "Username Username Username",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 9.sp,
                  weight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: AppFonts.interFont,
                  textHeight: 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
