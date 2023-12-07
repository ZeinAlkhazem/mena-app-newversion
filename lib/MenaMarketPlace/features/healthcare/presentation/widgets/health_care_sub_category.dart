// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/sub_sub_category.dart';

class HealthCareSubCategory extends StatelessWidget {
  final HealthcareSubCategory healthcareSubCategory;
  const HealthCareSubCategory({
    super.key,
    required this.healthcareSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        child: ExpansionTile(
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
            ),
          ],
          title: Text(
            healthcareSubCategory.name,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
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
