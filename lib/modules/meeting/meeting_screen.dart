import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/meeting/widget/appbar_for_meeting.dart';
import 'package:mena/modules/meeting/widget/option_item.dart';

import 'cubit/meeting_cubit.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  void initState() {
    MeetingCubit.get(context).emitInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    final List<Map> meetingOption = [
      {
        "onTap": () => meetingCubit.onPressAudio(context, 0),
        "title": "Audio",
        "icon": "assets/live_icon/Audio.svg",
      },
      {
        "onTap": () => meetingCubit.onPressCamera(context, 1),
        "title": "Camera",
        "icon": "assets/live_icon/Camera.svg",
      },
      {
        "onTap": () => meetingCubit.onPressChat(
              context,
            ),
        "title": "Chat",
        "icon": "assets/live_icon/Chat.svg",
      },
      {
        "onTap": () => meetingCubit.onPressShare(context, 3),
        "title": "Share Screen",
        "icon": "assets/live_icon/Share Screen.svg",
      },
      {
        "onTap": () => meetingCubit.onPressRecord(context, 4),
        "title": "Record",
        "icon": "assets/live_icon/Record.svg",
      },
      {
        "onTap": () => meetingCubit.onPressReactions(context, 5),
        "title": "Reactions",
        "icon": "assets/live_icon/Reactions.svg",
      },
      {
        "onTap": () => meetingCubit.onPressWhiteboards(context, 6),
        "title": "Whiteboards",
        "icon": "assets/live_icon/Whiteboards.svg",
      },
      {
        "onTap": () => meetingCubit.onPressSecurity(context, 7),
        "title": "Security",
        "icon": "assets/live_icon/Security.svg",
      },
      {
        "onTap": () => meetingCubit.onPressMore(context, 8),
        "title": "More",
        "icon": "assets/live_icon/More.svg",
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor:  Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0.h),
          child: defaultAppBarForMeeting(context),
        ),
        body: BlocConsumer<MeetingCubit, MeetingState>(
          listener: (context, state) {},
          builder: (context, state) {
            log(state.toString());

            return Column(
              children: [
                if (state is OnloadingState)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                Expanded(
                  child: SvgPicture.asset("assets/live_icon/person_icon.svg"),
                ),
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: meetingOption.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return OptionItem(
                            index: index,
                            onTap: meetingOption[index]["onTap"],
                            title: meetingOption[index]["title"],
                            icon: meetingOption[index]["icon"]);
                      }),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
