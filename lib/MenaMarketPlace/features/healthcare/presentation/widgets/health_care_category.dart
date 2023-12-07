// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';

class HealthCareCategoryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final HealthcareCategory healthCareCategory;
  const HealthCareCategoryWidget({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.healthCareCategory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: isSelected
          ? Container(
              width: 100.w,
              height: 50.h,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    width: 3.w,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  widthBox(2.w),
                  Flexible(
                    child: Text(
                      healthCareCategory.name,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                        color: Color(0xFF2D689E),
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              width: 100.w,
              height: 50.h,
              child: Wrap(
                children: [
                  Text(
                    healthCareCategory.name,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
