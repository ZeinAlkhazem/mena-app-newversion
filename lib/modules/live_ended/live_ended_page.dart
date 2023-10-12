import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../start_live/cubit/start_live_cubit.dart';
import '../start_live/widget/header_live_bubble.dart';
import '../start_live/widget/header_live_screen.dart';

class LiveEndedPage extends StatefulWidget {
  const LiveEndedPage({super.key});

  @override
  State<LiveEndedPage> createState() => _LiveEndedPageState();
}

class _LiveEndedPageState extends State<LiveEndedPage> {
  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/live_background.png"))),
          child: Column(children: [
            heightBox(10.h),
            const HeaderLiveScreen(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: const HeaderLiveBubble(
                pictureUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
              ),
            ),
            heightBox(10.h),
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
            heightBox(20.h),
            Text(
              "Your live video has ended",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            heightBox(20.h),
            DefaultButton(
              text: "Done",
              titleColor: mainBlueColor,
              onClick: () => startLiveCubit.onPressDoneLive(context),
              backColor: Colors.transparent,
              width: 65.w,
              radius: 10.r,
            ),
            const Spacer(),
            heightBox(10.h)
          ]),
        ),
      ),
    );
  }
}
