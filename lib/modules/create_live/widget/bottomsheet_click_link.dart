import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/create_live/widget/radius_20_container.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../cubit/create_live_cubit.dart';
import 'default_button.dart';
import 'live_input_field.dart';

class BottomsheetClickLink extends StatelessWidget {
  const BottomsheetClickLink(
      {super.key, this.onClickConfirm, this.onClickCancel});

  final VoidCallback? onClickCancel;

  final VoidCallback? onClickConfirm;

  @override
  Widget build(BuildContext context) {
    CreateLiveCubit createLiveCubit = CreateLiveCubit.get(context);

    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            LiveInputField(
              label: '',
              controller: createLiveCubit.linkUrl,
              validate: normalInputValidate(context,
                  customText: 'It cannot be empty'),
            ),
            heightBox(20.h),
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
            ),
          ],
        ),
      ),
    );
  }
}
