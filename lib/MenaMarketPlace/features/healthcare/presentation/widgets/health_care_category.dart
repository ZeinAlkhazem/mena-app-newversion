// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../domain/entities/healthcare_category.dart';

class HealthCareCategoryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final HealthcareCategory healthCareCategory;
  const HealthCareCategoryWidget({
    Key? key,
    required this.onTap,
    required this.isSelected,
    required this.healthCareCategory,
  }) : super(key: key);

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
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      width: 4.w,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(2.r)),
                    ),
                    widthBox(2.w),
                    Flexible(
                      child: Text(
                        healthCareCategory.name,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: mainStyle(context, 10.sp,
                            color: Colors.indigo,
                            fontFamily: "Roboto",
                            weight: FontWeight.w600),
                      ),
                    )
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
                      style: mainStyle(context, 10.sp,
                          fontFamily: "Roboto", weight: FontWeight.w600),
                    ),
                  ],
                ),
              ));
  }
}
