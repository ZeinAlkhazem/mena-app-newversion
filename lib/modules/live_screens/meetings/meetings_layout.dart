import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/meetings/start_meeting_layout.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import 'create_upcoming_meeting.dart';
import 'join_meeting_layout.dart';
import 'meetings_dashboard.dart';

class MeetingsLayout extends StatefulWidget {
  const MeetingsLayout({Key? key}) : super(key: key);

  @override
  State<MeetingsLayout> createState() => _MeetingsLayoutState();
}

class _MeetingsLayoutState extends State<MeetingsLayout> {

  @override
  void initState() {
    // TODO: implement initState

    var liveCubit=LiveCubit.get(context);
    liveCubit.getMeetingsConfig();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  heightBox(55.h),
                  Text(
                    // !mainCubit.isUserProvider()
                    //     ?
                    'Mena Meetings'
                    // : 'Meetings (Events , Support groups ,'
                    //     'Conferences, Discussion group , Virtual'
                    //     'interview , Courses , Classes)',
                    ,
                    style: mainStyle(context, 14, isBold: true),
                    textAlign: TextAlign.center,
                  ),
                  heightBox(17.h),
                  Expanded(child: MenaMeetingHeader()),
                ],
              ),
            ),
            Container(
              // height: 0.42.sh,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: newLightGreyColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(defaultRadiusVal * 3),
                    topLeft: Radius.circular(defaultRadiusVal * 3),
                  )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding * 2.5, vertical: defaultHorizontalPadding * 2),
                child: Column(
                  children: [
                    Text(
                      'Get Started with mena Meeting',
                      style: mainStyle(context, 14, isBold: true),
                    ),
                    heightBox(22.h),
                    DefaultButton(
                      text: 'Meeting Dashboard',
                      backColor: Colors.white,
                      titleColor: Colors.black,
                      borderColor: Colors.transparent,
                      onClick: () {
                        navigateToWithoutNavBar(context, MeetingDashboard(), 'routeName ');
                      },
                    ),
                    heightBox(10.h),
                    DefaultButton(
                      text: 'Join Meeting',
                      backColor: Colors.white,
                      titleColor: Colors.black,
                      borderColor: Colors.transparent,
                      onClick: () {
                        navigateToWithoutNavBar( context, JoinMeetingLayout(),'');
                      },
                    ),
                    heightBox(10.h),
                    if (mainCubit.isUserProvider())
                      Column(
                        children: [
                          DefaultButton(
                            text: 'Create Upcoming Meeting',
                            backColor: Colors.white,
                            titleColor: Colors.black,
                            borderColor: Colors.transparent,
                            onClick: () {
                              navigateToWithoutNavBar(context, CreateUpcomingMeeting(), 'routeName');
                            },
                          ),
                          heightBox(10.h),
                          DefaultButton(
                            text: 'Start Meeting',
                            backColor: Colors.white,
                            titleColor: Colors.black,
                            borderColor: Colors.transparent,
                            onClick: () {
                              navigateToWithoutNavBar(  context, StartMeetingLayout(),'');
                            },
                          ),
                          heightBox(22.h),
                        ],
                      ),
                    heightBox(28.h),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenaMeetingHeader extends StatefulWidget {
  const MenaMeetingHeader({
    super.key,
  });

  @override
  State<MenaMeetingHeader> createState() => _MenaMeetingHeaderState();
}

class _MenaMeetingHeaderState extends State<MenaMeetingHeader> {
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState

    var liveCubit = LiveCubit.get(context);

    liveCubit.updateActiveSliderItem(0);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // var mainCubit = MainCubit.get(context);
    var liveCubit = LiveCubit.get(context);

    return BlocConsumer<LiveCubit, LiveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: liveCubit.meetingsSliderItems.length,
                carouselController: carouselController,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex)
                => MeetingSliderItem(
                  title: liveCubit.meetingsSliderItems[itemIndex].title,
                  thumbLink: liveCubit.meetingsSliderItems[itemIndex].thumbnailLink!,
                ),
                options: CarouselOptions(
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    liveCubit.updateActiveSliderItem(index);
                  },
                  reverse: false,
                  height: 0.25.sh,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: Responsive.isMobile(context) ? 1 : 1,
                  aspectRatio: 1,
                  initialPage: 0,
                  scrollPhysics: ClampingScrollPhysics(),
                ),
              ),
            ),
            heightBox(2.h),
            SizedBox(
              height: 15.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => CircleAvatar(
                  radius: 5.h,
                  backgroundColor: liveCubit.activeSliderItemIndex == index ? mainBlueColor : newDarkGreyColor,
                ),
                separatorBuilder: (c, i) => widthBox(5.w),
                itemCount: liveCubit.meetingsSliderItems.length,
              ),
            ),
            heightBox(9.h)
            // Text((liveCubit.activeSliderItemIndex+1).toString())
          ],
        );
      },
    );
  }
}

class MeetingSliderItem extends StatelessWidget {
  const MeetingSliderItem({
    super.key,
    required this.title,
    required this.thumbLink,
  });

  final String title;
  final String thumbLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child:
                // thumbLink.endsWith('.lottie')?
                // DotLottieLoader.fromAsset("assets/animation_external_image.lottie",
                //     frameBuilder: (ctx, dotlottie) {
                //       if (dotlottie != null) {
                //         return Lottie.memory(dotlottie.animations.values.single,
                //             imageProviderFactory: (asset) {
                //               return MemoryImage(dotlottie.images[asset.fileName]!);
                //             }
                //         );
                //       } else {
                //         return Container();
                //       }
                //     }):
                SvgPicture.asset(thumbLink),
          ),
        ),
        heightBox(15.h),
        Text(
          title,
          style: mainStyle(
            context,
            13,
            color: newDarkGreyColor,
            weight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        // heightBox(5.h),
      ],
    );
  }
}
