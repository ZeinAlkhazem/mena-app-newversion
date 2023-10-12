import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/create_live/widget/radius_20_container.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import 'check_box_button.dart';

class BottomSheetSeeMyLiveAndComment extends StatelessWidget {
  const BottomSheetSeeMyLiveAndComment({
    super.key,
    this.onClickAll,
    this.onClickClient,
    this.onClickProviders,
    this.valueAll,
    this.valueClient,
    this.valueProviders,
    this.onClickCancel,
    this.onClickConfirm,
  });
  final void Function(bool?)? onClickAll;
  final void Function(bool?)? onClickClient;
  final void Function(bool?)? onClickProviders;

  final bool? valueAll;
  final bool? valueClient;
  final bool? valueProviders;

  final VoidCallback? onClickCancel;
  final VoidCallback? onClickConfirm;

  @override
  Widget build(BuildContext context) {
    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxButton(text: "All", onClick: onClickAll, value: valueAll!),
            CheckboxButton(
                text: "Client", onClick: onClickClient, value: valueClient!),
            CheckboxButton(
                text: "Providers",
                onClick: onClickProviders,
                value: valueProviders!),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultButton(
                  width: 100.w,
                  borderColor: chatGreyColor,
                  titleColor: const Color(0xff6d7885),
                  backColor: chatGreyColor,
                  text: "Cancel",
                  onClick: onClickCancel!,
                ),
                DefaultButton(
                  width: 100.w,
                  text: "Confirm",
                  onClick: onClickConfirm!,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
