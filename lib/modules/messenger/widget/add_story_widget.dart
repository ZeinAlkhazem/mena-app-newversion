import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

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
              width: 65.w,
              height: 65.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(65.r),
                  // color: AppColors.iconsColor,
                  border: Border.all(color: Colors.white, width: 2.w)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65.r),
                child:
                DefaultImage(
                  backGroundImageUrl: "https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
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
          style: mainStyle(context, 9.sp,
              weight: FontWeight.normal,
              color: Colors.black,
              fontFamily: AppFonts.interFont,
              textHeight: 1.1),
        ),
      ],
    );
  }
}
