// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../../domain/entities/healthcare_category.dart';
import 'sub_sub_category.dart';

class HealthCareSubCategory extends StatelessWidget {
  final HealthcareSubCategory healthcareSubCategory;
  const HealthCareSubCategory({
    Key? key,
    required this.healthcareSubCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ExpansionTile(
          initiallyExpanded: false,
          children: [
            Wrap(
              children: List.generate(
                healthcareSubCategory.childs.length,
                (index) => Padding(
                  padding: EdgeInsets.all(5.0.h),
                  child: SubSubCategory(
                    healthcareSubSubCategory:
                        healthcareSubCategory.childs[index],
                    onTap: () {},
                  ),
                ),
              ),
            )
          ],
          title: Text(
            healthcareSubCategory.name,
            style: mainStyle(
              context,
              15.sp,
              weight: FontWeight.w500,
              fontFamily: "Roboto",
            ),
          ),
          collapsedIconColor: AppColors.softBlue,
          iconColor: AppColors.hardBlue,
          onExpansionChanged: (value) async {},
        ),
      ),
    );
  }
}
