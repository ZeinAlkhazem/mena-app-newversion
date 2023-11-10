import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/functions/main_funcs.dart';
import 'search_box.dart';

class HealthCareSearchControll extends StatelessWidget {
  const HealthCareSearchControll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widthBox(8.w),
        Flexible(child: SearchBox()),
        widthBox(8.w),
        Image.asset(
          "assets/flags/ae.png",
          width: 40.w,
        ),
        widthBox(8.w),
      ],
    );
  }
}
