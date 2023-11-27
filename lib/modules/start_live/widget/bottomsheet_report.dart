// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import '../../create_live/widget/live_input_field.dart';
import '../../create_live/widget/radius_20_container.dart';
import '../cubit/start_live_cubit.dart';

class BottomsheetReport extends StatelessWidget {
  const BottomsheetReport({
    super.key,
    this.onClickCancel,
    this.onClickConfirm,
  });

  final VoidCallback? onClickCancel;

  final VoidCallback? onClickConfirm;

  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    return Radius20Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            LiveInputField(
              label: '',
              controller: startLiveCubit.liveReportText,
              unFocusedBorderColor: const Color(0x7f818c99),
              validate: normalInputValidate(context,
                  customText: 'It cannot be empty'),
            ),
            heightBox(10.h),
            GestureDetector(
              onTap: () => startLiveCubit.pickReportFiles(),
              child: BlocConsumer<StartLiveCubit, StartLiveState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: startLiveCubit.filesMultie.isEmpty
                            ? const Color(0x7f818c99)
                            : startLiveCubit.is4photo == null
                                ? Colors.green
                                : Colors.red,
                        width: 0.50,
                      ),
                      color: const Color(0xfff2f3f5),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/picture_plus_outline.svg',
                            color: startLiveCubit.is4photo == null
                                ? null
                                : Colors.red,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${startLiveCubit.fileNamemultt}/4",
                                  style: TextStyle(
                                      color: startLiveCubit.filesMultie.isEmpty
                                          ? const Color(0xff818c99)
                                          : startLiveCubit.is4photo == null
                                              ? Colors.green
                                              : Colors.red,
                                      fontSize: 13.sp)),
                            ],
                          )
                        ]),
                  );
                },
              ),
            ),
            heightBox(10.h),
            Text(
              "If someone you know is in immediate physical anger,contact local law enforcement right away.",
              style: TextStyle(
                color: const Color(0xff818c99),
                fontSize: 12.sp,
              ),
            ),
            heightBox(30.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultButton(
                  width: 140.w,
                  borderColor: chatGreyColor,
                  titleColor: const Color(0xff6d7885),
                  backColor: chatGreyColor,
                  text: "Cancel",
                  onClick: onClickCancel!,
                ),
                const Spacer(),
                DefaultButton(
                  width: 140.w,
                  text: "Send report",
                  onClick: onClickConfirm!,
                ),
              ],
            ),
          ]),
    );
  }
}
