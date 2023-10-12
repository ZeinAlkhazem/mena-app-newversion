import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class AlertDialogSelectorItem extends StatelessWidget {
  const AlertDialogSelectorItem({
    Key? key,
    this.label = 'View all',
    this.customColor,
    this.customFontColor,
    this.customHeight,
    required this.isSelected,
  }) : super(key: key);
  final String label;
  final Color? customColor;
  final Color? customFontColor;
  final double? customHeight;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      height: customHeight ?? 27.sp,
      radius: defaultRadiusVal,
      backColor: Colors.transparent,
      borderColor: Colors.transparent,
      childWidget: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: mainStyle(
                context,
                12,
                isBold: true,
                color: Colors.black,
              ),
              // maxLines: 1,
            ),
            if (isSelected) SvgPicture.asset('assets/svg/icons/correct.svg')
          ],
        ),
      ),
    );
  }
}