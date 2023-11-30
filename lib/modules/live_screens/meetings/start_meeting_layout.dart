import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import 'create_upcoming_meeting_details.dart';

class StartMeetingLayout extends StatelessWidget {
  const StartMeetingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Start meeting',
        ),
      ),
      body: BlocConsumer<LiveCubit, LiveState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Container(
            color: newLightGreyColor,
            child: Column(
              children: [
                Divider(height: 1.h, thickness: 1.h,),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(defaultHorizontalPadding),
                    child: Column(
                      children: [
                        MeetingRowWithToggle(
                          title: 'Video On',
                          // subTitle:
                          //     'Only those with the invite link or passcode are eligible to join the meeting',
                          toggleVal: liveCubit.startMeetingVideoOn,
                          toggleClick: (val) {
                            liveCubit.updateStartMeetingVideoOn(val);
                          },
                        ),
                        Divider(height: 15.h,),
                        MeetingRowWithToggle(
                          title: 'Use personal Meeting ID',
                          subTitle:
                          '558 735 9937',
                          toggleVal: liveCubit.usePersonalMeetingId,
                          toggleClick: (val) {
                            liveCubit.updateUsePersonalMeetingId(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(height: 1.h, thickness: 1.h,),
                heightBox(22.h),
                Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: DefaultButton(text: 'Start meeting', onClick: () {}),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
