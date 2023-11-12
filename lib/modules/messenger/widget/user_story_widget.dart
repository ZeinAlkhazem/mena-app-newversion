import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

class UserStoryWidget extends StatelessWidget {
  const UserStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 75.w,
            height: 75.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: AppColors.iconsColor,
                border: Border.all(color: Colors.white, width: 2.w)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.network(
                  fit: BoxFit.fill,
                  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
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
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 10.sp,
                  weight: FontWeight.w500,
                  color: AppColors.grayDarkColor,
                  fontFamily: AppFonts.openSansFont,
                  textHeight: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}
