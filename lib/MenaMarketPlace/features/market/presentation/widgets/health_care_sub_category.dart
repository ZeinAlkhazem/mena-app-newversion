import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

import 'sub_sub_category.dart';

class HealthCareSubCategory extends StatelessWidget {
  const HealthCareSubCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      children: List.generate(
        2,
        (index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.all(5.0.h),
              child: SubSubCategory(
                btnIcon:
                    "https://images.unsplash.com/photo-1551884170-09fb70a3a2ed?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D",
                label: "Healthcare\nCampaigns",
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "Sub Category :",
        style: mainStyle(
          context,
          12.sp,
          weight: FontWeight.w600,
          fontFamily: "VisbyBold",
        ),
      ),
      collapsedIconColor: AppColors.softBlue,
      iconColor: AppColors.hardBlue,
      onExpansionChanged: (value) async {},
    );
  }
}
