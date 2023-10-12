import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/my_meetings.dart';
import 'create_upcoming_meeting.dart';

class MeetingBeforeStartJoinConfirmationLayout extends StatelessWidget {
  const MeetingBeforeStartJoinConfirmationLayout({Key? key, required this.meeting}) : super(key: key);

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Confirmation',
          suffix: meeting.isMine ?? false
              ? TextButton(
                  onPressed: () {
                    navigateToWithoutNavBar(
                        context,
                        CreateUpcomingMeeting(
                          customMeetingToEdit: meeting,
                        ),
                        'routeName');
                  },
                  child: Text(
                    'Edit',
                    style: mainStyle(context, 13, color: mainBlueColor, weight: FontWeight.w700),
                  ),
                )
              : null,
        ),
      ),
      body: Center(
        child: SafeArea(
          child: BlocConsumer<LiveCubit, LiveState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Lottie.asset('assets/json/event-alert.json', width: 0.35.sw),
                    heightBox(33.h),
                    Text(
                      'Meeting Details',
                      style: mainStyle(context, 15, isBold: true),
                    ),
                    heightBox(18.h),
                    MeetingNormalRowDivider(
                      title: 'Meeting Type',
                      subTitle: meeting.meetingType!.title ?? '',
                    ),
                    MeetingNormalRowDivider(
                      title: 'Title',
                      subTitle: meeting.title ?? '',
                    ),
                    MeetingNormalRowDivider(
                      title: 'Meeting ID',
                      subTitle: meeting.id.toString(),
                    ),
                    MeetingNormalRowDivider(
                      title: 'Duration',
                      subTitle: meeting.duration.toString() + ' min',
                    ),
                    MeetingNormalRowDivider(
                      title: 'When',
                      subTitle: getFormattedDateWithDayName(meeting.date!),
                    ),
                    MeetingNormalRowDivider(
                      title: 'Passcode',
                      subTitle: meeting.passcode ?? '',
                    ),
                    heightBox(22.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                      child: Column(
                        children: [
                          DefaultButton(
                            text: meeting.isMine ?? false ? 'Start now' : ' Join',
                            onClick: () {},
                          ),
                          heightBox(10.h),
                          DefaultButton(
                            text: 'Invite',
                            onClick: () {},
                            backColor: newLightGreyColor,
                            borderColor: newLightGreyColor,
                            titleColor: Colors.black,
                          ),
                          heightBox(10.h),
                          DefaultButton(
                            text: 'Add to your calendar',
                            onClick: () {
                              final Event event = Event(
                                title: meeting.title ?? '',
                                description: meeting.id.toString(),
                                location: 'Online',
                                startDate: meeting.from!,
                                endDate: meeting.to!,
                                iosParams: IOSParams(
                                  reminder: Duration(minutes: meeting.duration ?? 0),
                                  // on iOS, you can set alarm notification after your event.
                                  url: 'https://www.menaplatforms.com', // on iOS, you can set url to your event.
                                ),
                                androidParams: AndroidParams(
                                  emailInvites: [], // on Android, you can add invite emails to your event.
                                ),
                              );
                              Add2Calendar.addEvent2Cal(event);
                            },
                            backColor: newLightGreyColor,
                            borderColor: newLightGreyColor,
                            titleColor: Colors.black,
                          ),
                          heightBox(10.h),
                          if (meeting.isMine ?? false)
                            state is UpdatingLiveStatus
                                ? DefaultLoaderColor()
                                : DefaultButton(
                                    text: 'Delete',
                                    onClick: () {
                                      logg('delete meeting');
                                      liveCubit.deleteMeeting(meetingId: meeting.id!);
                                    },
                                    backColor: newLightGreyColor,
                                    borderColor: newLightGreyColor,
                                    titleColor: Colors.black,
                                  ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MeetingNormalRowDivider extends StatelessWidget {
  const MeetingNormalRowDivider({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: mainStyle(context, 14, weight: FontWeight.w700),
              ),
              Text(
                subTitle,
                style: mainStyle(context, 14, isBold: true),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          height: 5.h,
        )
      ],
    );
  }
}
