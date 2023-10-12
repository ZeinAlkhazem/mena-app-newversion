import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../cubit/meeting_cubit.dart';
import '../participants/participants_page.dart';

PreferredSize defaultAppBarForMeeting(
  BuildContext context,
) {
  var meetingCubit = MeetingCubit.get(context);

  return PreferredSize(
    preferredSize: Size.fromHeight(56.0.h),
    child: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 30.h,
              width: 53.w,
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  'assets/live_icon/appbar_back.svg',
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              buildShowModalBottomSheet(context,
                  body: const ParticipantsPage(),
                  backColor: Colors.transparent);
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/live_icon/pepole.svg',
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                  child: Text(
                    meetingCubit.viewersCount.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mainBlueColor,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              )),
              backgroundColor: const MaterialStatePropertyAll(Colors.red),
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              maximumSize: MaterialStatePropertyAll(
                Size(75.w, 40.h),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(75.w, 40.h),
              ),
            ),
            onPressed: () => meetingCubit.onPressLeave(context),
            icon: SvgPicture.asset(
              'assets/live_icon/door_arrow_right_outline_20.svg',
            ),
            label: Text(
              "Leave",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
          widthBox(10.w),
        ],
      ),
    ),
  );
}
