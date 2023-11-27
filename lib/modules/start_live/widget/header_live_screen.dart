// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_down_button/pull_down_button.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import '../cubit/start_live_cubit.dart';
import 'header_live_bubble.dart';

class HeaderLiveScreen extends StatelessWidget {
  const HeaderLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: const HeaderLiveBubble(
                pictureUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
              ),
            ),
            SizedBox(
              width: 50.w,
              child: Text(
                overflow: TextOverflow.ellipsis,
                "Dr.Name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            widthBox(10.w),
            const Spacer(),
            GestureDetector(
              onTap: () => startLiveCubit.onShowViewer(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: const Color(0x19ffffff),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person_2, color: Colors.white, size: 12.sp),
                    widthBox(2.w),
                    Text(
                      "22K",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PullDownButton(
              backgroundColor: Colors.white,
              widthConfiguration: PullDownMenuWidthConfiguration(175.w),
              itemBuilder: (context) => [
                PullDownMenuItem(
                  iconSize: 20.w,
                  icon: Icons.stop_rounded,
                  iconColor: mainBlueColor,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: 'Stop Live',
                  onTap: () => startLiveCubit.onPressStopLive(context),
                ),
                PullDownMenuItem(
                  iconSize: 20.w,
                  icon: startLiveCubit.isLivePaused
                      ? Icons.play_arrow
                      : Icons.pause,
                  iconColor: mainBlueColor,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: startLiveCubit.isLivePaused
                      ? 'Continue Live'
                      : 'Pause Live',
                  onTap: () => startLiveCubit.onPressPauseLive(),
                ),
                PullDownMenuItem(
                  iconSize: 20.w,
                  icon: Icons.poll_outlined,
                  iconColor: mainBlueColor,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: 'Create Poll',
                  onTap: () => startLiveCubit.onPressCreatePoll(),
                ),
                PullDownMenuItem(
                  iconSize: 20.w,
                  iconWidget: SvgPicture.asset(
                    color: mainBlueColor,
                    'assets/svg/share_outline_56.svg',
                    width: 20.w,
                  ),
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: 'Share Live',
                  onTap: () => startLiveCubit.onPressShareLive(
                      context,
                      "2222222222222222222222",
                      "lllllllllllllllllllllllllllll"),
                ),
                PullDownMenuItem(
                  iconSize: 20.w,
                  iconWidget: SvgPicture.asset(
                    color: mainBlueColor,
                    'assets/svg/linked_outline.svg',
                    width: 20.w,
                  ),
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: 'Copy Link',
                  onTap: () => startLiveCubit.onPressCopyLink(
                      context, "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"),
                ),
                PullDownMenuItem(
                  iconSize: 20.w,
                  icon: Icons.report_gmailerrorred,
                  iconColor: mainBlueColor,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                  title: 'Report',
                  onTap: () => startLiveCubit.onPressReport(context),
                ),
              ],
              buttonBuilder: (context, showMenu) => CupertinoButton(
                onPressed: showMenu,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: DefaultButton(
            text: "Follow",
            titleColor: mainBlueColor,
            onClick: () => startLiveCubit.onPressFollow(),
            backColor: Colors.transparent,
            width: 50.w,
            height: 25.h,
            radius: 10.r,
            fontSize: 8.sp,
            withoutPadding: true,
          ),
        ),
      ],
    );
  }
}
