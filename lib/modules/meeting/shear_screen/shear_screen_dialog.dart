import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/meeting_cubit.dart';

class ShearScreenDialog extends StatelessWidget {
  ShearScreenDialog({super.key});

  final TextStyle? styleText = TextStyle(
    color: const Color(0xFF1A1A1A),
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 2,
    letterSpacing: 0.02,
  );

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    return BlocConsumer<MeetingCubit, MeetingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'About Meeting',
                  textAlign: TextAlign.center,
                  style: mainStyle(context, 20.sp,
                      color: mainBlueColor,
                      isBold: true,
                      weight: FontWeight.w600,
                      textHeight: 2),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
            Text(
              'Who can share?',
              style: styleText,
            ),
            heightBox(16.h),
            DefaultButton(
              radius: 60.r,
              text: "Host Only",
              titleColor: meetingCubit.hostOnly ? Colors.white : Colors.black,
              onClick: () => meetingCubit.onPressShareWhoCanShare(true),
              backColor: meetingCubit.hostOnly ? mainBlueColor : Colors.white,
              borderColor: meetingCubit.hostOnly ? mainBlueColor : Colors.black,
            ),
            heightBox(16.h),
            DefaultButton(
              radius: 60.r,
              borderColor:
                  !meetingCubit.hostOnly ? mainBlueColor : Colors.black,
              titleColor: !meetingCubit.hostOnly ? Colors.white : Colors.black,
              backColor: !meetingCubit.hostOnly ? mainBlueColor : Colors.white,
              text: "All Participants",
              onClick: () => meetingCubit.onPressShareWhoCanShare(false),
            ),
            heightBox(30.h),
            Text(
              'Who can start sharing when someone else is sharing?',
              style: styleText,
            ),
            heightBox(16.h),
            DefaultButton(
              radius: 60.r,
              text: "Host Only",
              titleColor: Colors.black,
              onClick: () {},
              backColor: Colors.white,
              borderColor: Colors.black,
            ),
            heightBox(16.h),
            DefaultButton(
              radius: 60.r,
              borderColor: mainBlueColor,
              titleColor: Colors.white,
              backColor: mainBlueColor,
              text: "All Participants",
              onClick: () {},
            ),
          ],
        );
      },
    );
  }
}
