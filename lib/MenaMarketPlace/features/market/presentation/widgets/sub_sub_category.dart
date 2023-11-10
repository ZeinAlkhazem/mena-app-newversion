import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';

class SubSubCategory extends StatelessWidget {
  final VoidCallback onTap;
  final String btnIcon;
  final String label;
  const SubSubCategory({
    Key? key,
    required this.onTap,
    required this.btnIcon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage: NetworkImage(btnIcon),
            ),
            heightBox(5.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: mainStyle(
                  context,
                  fontFamily: "VisbyBold",
                  8.sp,
                  weight: FontWeight.w700),
            )
          ],
        ));
  }
}
