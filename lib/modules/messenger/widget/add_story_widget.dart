import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

class AddStoryWidget extends StatelessWidget {
  const AddStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
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
                    "https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
              ),
            ),
            Positioned(
                right: 0.w,
                bottom: 0.h,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: AppColors.iconsColor,
                      border: Border.all(color: Colors.white, width: 2.w)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "My Story",
          style: mainStyle(context, 10.sp,
              weight: FontWeight.w700,
              color: AppColors.grayDarkColor,
              fontFamily: AppFonts.openSansFont,
              textHeight: 1.1),
        ),
      ],
    );
  }
}
