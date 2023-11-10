import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';

class HealthCareCategory extends StatelessWidget {
  final VoidCallback onTap;
  final String btnIcon;
  final String label;
  const HealthCareCategory({
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
            Container(
              margin: EdgeInsets.all(5.w),
              height: 70.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/allNewDesign/logo.jpg',
                      image:
                          "https://media.istockphoto.com/id/1150397417/photo/abstract-luminous-dna-molecule-doctor-using-tablet-and-check-with-analysis-chromosome-dna.webp?s=2048x2048&w=is&k=20&c=ipb_OZxpMheJNNEfC-cZea6_nz59HrYO4Sjli16jGzY="),
                ),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: mainStyle(context, 10.sp,
                  fontFamily: "VisbyBold", weight: FontWeight.w800),
            )
          ],
        ));
  }
}
