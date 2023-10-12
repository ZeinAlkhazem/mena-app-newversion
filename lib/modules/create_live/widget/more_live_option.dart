import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class MoreOptionRow extends StatelessWidget {
  const MoreOptionRow({
    Key? key,
    this.title,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String? title;
  final bool? value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value!,
          onChanged: onChanged,
          activeTrackColor: mainBlueColor,
          activeColor: disabledGreyColor,
        ),
        widthBox(10.w),
        Text(
          title!,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
          ),
        )
      ],
    );
  }
}
