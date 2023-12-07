// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';

class SubSubCategory extends StatelessWidget {
  final VoidCallback onTap;
  final HealthcareSubSubCategory healthcareSubSubCategory;
  const SubSubCategory({
    super.key,
    required this.onTap,
    required this.healthcareSubSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 70.w,
        child: Column(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage:
                  CachedNetworkImageProvider(healthcareSubSubCategory.image),
            ),
            heightBox(5.h),
            Text(
              healthcareSubSubCategory.name,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                color: Color(0xFF444444),
                fontSize: 8,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
