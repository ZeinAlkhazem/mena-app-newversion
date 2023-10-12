import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/meetings/create_upcoming_meeting.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';
import '../../../models/api_model/my_meetings.dart';
import 'meeting_before_join_confirm.dart';

class MeetingDashboard extends StatefulWidget {
  const MeetingDashboard({Key? key}) : super(key: key);

  @override
  State<MeetingDashboard> createState() => _MeetingDashboardState();
}

class _MeetingDashboardState extends State<MeetingDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    var liveCubit = LiveCubit.get(context);

    liveCubit.getMyMeetings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Meetings Dashboard',
        ),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: BlocConsumer<LiveCubit, LiveState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileBubble(
                    isOnline: true,
                    customRingColor: mainBlueColor,
                    radius: 33.sp,
                    pictureUrl: MainCubit.get(context).userInfoModel!.data.user.personalPicture,
                  ),
                  heightBox(13.h),
                  Text(
                    'My Meeting id',
                    style: mainStyle(context, 13, weight: FontWeight.w700),
                  ),
                  heightBox(8.h),
                  Text(
                    '87219837',
                    style: mainStyle(context, 13, weight: FontWeight.w700, color: newDarkGreyColor),
                  ),
                  heightBox(8.h),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                    // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
                    childAspectRatio: 1.1,
                    padding: EdgeInsets.all(defaultHorizontalPadding),
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 9.sp,
                    crossAxisSpacing: 10.sp,
                    children: List.generate(
                        liveCubit.meetingsDashboardItems(context).length,
                        (index) => GestureDetector(
                              onTap: liveCubit.meetingsDashboardItems(context)[index].onClickCallback,
                              child: Container(
                                // color: Colors.white,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(3.0.sp),
                                        child: DefaultContainer(
                                          width: double.maxFinite,
                                          backColor: newLightGreyColor,
                                          borderColor: newLightGreyColor,
                                          withoutBorder: true,
                                          withBoxShadow: true,
                                          childWidget: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(defaultRadiusVal),
                                                child: SvgPicture.asset(
                                                  liveCubit.meetingsDashboardItems(context)[index].thumbnailLink!,
                                                  height: 66.h,
                                                  width: 66.h,
                                                ),
                                              ),
                                              heightBox(15.h),
                                              Text(
                                                liveCubit.meetingsDashboardItems(context)[index].title,
                                                style: mainStyle(
                                                  context,
                                                  13,
                                                  color: newDarkGreyColor,
                                                  isBold: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ) //getProductObjectAsList
                        ),
                  ),
                  state is LoadingMeetingsState
                      ? DefaultLoaderColor()
                      : (liveCubit.myMeetingsModel == null || liveCubit.myMeetingsModel!.meetingsCollections!.isEmpty)
                          ? SizedBox()
                          : MyMeetingsSection()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyMeetingsSection extends StatelessWidget {
  const MyMeetingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);

    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        MeetingCollectionModel currentMeeting = liveCubit.myMeetingsModel!.meetingsCollections![index];
        return MeetingCollection(currentMeetingCollection: currentMeeting);
      },
      separatorBuilder: (c, i) => heightBox(9.h),
      itemCount: liveCubit.myMeetingsModel!.meetingsCollections!.length,
    );
  }
}

class MeetingCollection extends StatelessWidget {
  const MeetingCollection({
    super.key,
    required this.currentMeetingCollection,
  });

  final MeetingCollectionModel currentMeetingCollection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 1,
          height: 1,
        ),
        Container(
          width: double.maxFinite,
          color: newLightGreyColor,
          child: Padding(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child: Text(
              getFormattedDateWithDayName(currentMeetingCollection.date!),
              style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.all(defaultHorizontalPadding),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Meeting meeting = currentMeetingCollection.meetings![index];
              return MeetingCard(meeting: meeting);
            },
            separatorBuilder: (c, i) => Divider(
              height: 22.h,
              thickness: 1,
            ),
            itemCount: currentMeetingCollection.meetings!.length,
          ),
        ),
      ],
    );
  }
}

class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
  });

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Container(
      child: Column(
        children: [
          heightBox(10.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'From',
                  //   style: mainStyle(context, 13,
                  //       color: Colors.black, weight: FontWeight.w700),
                  // ),
                  // heightBox(5.h),
                  // Text(
                  //   meeting.from!,
                  //   style:
                  //       mainStyle(context, 13, color: Colors.black),
                  // ),
                  // heightBox(10.h),
                  // Text(
                  //   'To',
                  //   style: mainStyle(context, 13,
                  //       color: Colors.black, weight: FontWeight.w700),
                  // ),
                  // heightBox(5.h),
                  Text(
                    getFormattedDateOnlyTime(meeting.from!),
                    style: mainStyle(context, 13, color: Colors.black),
                  ),
                ],
              ),
              widthBox(22.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meeting.title!,
                      style: mainStyle(
                        context,
                        15,
                        weight: FontWeight.w700,
                      ),
                    ),
                    heightBox(12.h),
                    Text(
                      'Event For Professional',
                      style: mainStyle(context, 12, color: Colors.black, weight: FontWeight.w700),
                    ),
                    heightBox(12.h),
                    // Text(meeting.id.toString(),style: mainStyle(context , 13,color: Colors.black),),
                    Text(
                      'Meeting ID: 720 8986 9867',
                      style: mainStyle(context, 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          heightBox(15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DefaultButton(
                  height: 27.h,
                  fontSize: 10,
                  withoutPadding: true,
                  width: 0.2.sw,
                  text: meeting.isMine ?? false ? 'Start' : 'Join',
                  onClick: () {
                    navigateToWithoutNavBar(
                        context, MeetingBeforeStartJoinConfirmationLayout(meeting: meeting), 'routeName');
                    // naviga
                    // if (MainCubit.get(context).isUserProvider()) {
                    //   logg('user provider so start . . this need update to if  my meet then start');
                    // } else {
                    //   logg('user client so join . . this need update to if not  my meet then start');
                    // }
                  }),
              DefaultButton(
                  height: 27.h,
                  fontSize: 10,
                  withoutPadding: true,
                  backColor: newLightGreyColor,
                  borderColor: newLightGreyColor,
                  titleColor: Colors.black,
                  width: 0.2.sw,
                  text: meeting.isMine ?? false ? 'Edit' : 'Reminder',
                  onClick: () {
                    if (meeting.isMine ?? false) {
                      logg('my meeting edit');
                      navigateToWithoutNavBar(
                          context,
                          CreateUpcomingMeeting(
                            customMeetingToEdit: meeting,
                          ),
                          'routeName');
                    } else {
                      logg('meeting reminder');
                    }
                  }),
              DefaultButton(
                  height: 27.h,
                  fontSize: 10,
                  backColor: newLightGreyColor,
                  borderColor: newLightGreyColor,
                  titleColor: Colors.black,
                  withoutPadding: true,
                  width: 0.2.sw,
                  text: 'Share',
                  onClick: () {}),
            ],
          ),
          Divider(
            height: 22.h,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
