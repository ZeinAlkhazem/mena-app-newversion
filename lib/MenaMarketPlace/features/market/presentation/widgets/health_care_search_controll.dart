import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'country_picker_drop.dart';
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
        CountryPickerDrop(
          onValuePicked: (country) {},
        ),
      ],
    );
  }
}
