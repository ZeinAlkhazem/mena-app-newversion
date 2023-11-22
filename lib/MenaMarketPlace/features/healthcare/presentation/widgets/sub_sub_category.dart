// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';
import '../../domain/entities/healthcare_category.dart';

class SubSubCategory extends StatelessWidget {
  final VoidCallback onTap;
  final HealthcareSubSubCategory healthcareSubSubCategory;
  const SubSubCategory({
    Key? key,
    required this.onTap,
    required this.healthcareSubSubCategory,
  }) : super(key: key);

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
                style: mainStyle(
                    context,
                    fontFamily: "Roboto",
                    8.sp,
                    weight: FontWeight.w400),
              )
            ],
          ),
        ));
  }
}
