// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../domain/entities/healthcare_category.dart';

class HealthCareCategoryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final HealthcareCategory healthCareCategory;
  const HealthCareCategoryWidget({
    Key? key,
    required this.onTap,
    required this.healthCareCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5.w),
              height: 70.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child:CachedNetworkImage(imageUrl: healthCareCategory.image , placeholder: (context, url) => DefaultLoaderGrey(),),
              ),
            ),
            Text(
              healthCareCategory.name,
              textAlign: TextAlign.center,
              style: mainStyle(context, 10.sp,
                  fontFamily: "VisbyBold", weight: FontWeight.w800),
            )
          ],
        ));
  }
}
