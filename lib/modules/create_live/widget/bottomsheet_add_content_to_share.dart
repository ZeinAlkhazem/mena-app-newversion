import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/create_live/widget/radius_20_container.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class BottomSheetContentToShare extends StatelessWidget {
  const BottomSheetContentToShare(
      {super.key,
      this.onClickConfirm,
      this.isClearCache,
      this.onClickLink,
      this.onClickProduct,
      this.onClickPoll});

  final VoidCallback? onClickLink;

  final VoidCallback? onClickProduct;

  final VoidCallback? onClickPoll;

  final VoidCallback? onClickConfirm;

  final bool? isClearCache;

  @override
  Widget build(BuildContext context) {
    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultButton(
              titleColor: const Color(0xff6d7885),
              borderColor: chatGreyColor,
              backColor: chatGreyColor,
              text: "Link",
              onClick: onClickLink!,
            ),
            heightBox(20.h),
            DefaultButton(
              titleColor: const Color(0xff6d7885),
              borderColor: chatGreyColor,
              backColor: chatGreyColor,
              text: "Product",
              onClick: onClickProduct!,
            ),
            heightBox(20.h),
            DefaultButton(
              titleColor: const Color(0xff6d7885),
              text: "Poll",
              onClick: onClickPoll!,
              borderColor: chatGreyColor,
              backColor: chatGreyColor,
            ),
            heightBox(20.h),
            DefaultButton(
              text: "Confirm",
              onClick: onClickConfirm!,
              borderColor: mainBlueColor,
              backColor: mainBlueColor,
            ),
          ],
        ),
      ),
    );
  }
}
