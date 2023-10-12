import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/community_space/cubit/community_cubit.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../live_screens/live_main_layout.dart';

class PlatformWebinar extends StatelessWidget {
  const PlatformWebinar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var communityCubit = CommunityCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Webinar',
        ),
      ),
      body: BlocConsumer<CommunityCubit, CommunityState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    heightBox(25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => communityCubit.changeCurrentView('live'),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  heightBox(5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/icons/livenow.svg',
                                        height: 16.h,
                                        color: communityCubit.currentLayout == 'live' ? mainBlueColor : softGreyColor,
                                      ),
                                      widthBox(12.w),
                                      Text(
                                        'Live Now',
                                        style: mainStyle(context, 11,
                                            weight: FontWeight.w800,
                                            color:
                                                communityCubit.currentLayout == 'live' ? mainBlueColor : softGreyColor),
                                      )
                                    ],
                                  ),
                                  heightBox(5.h),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: 2.h,
                                    color: communityCubit.currentLayout == 'live' ? mainBlueColor : softGreyColor,
                                    width: communityCubit.currentLayout == 'live' ? 0.4.sw : 0.3.sw,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => communityCubit.changeCurrentView('upcoming'),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  heightBox(5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/icons/upcomingLive.svg',
                                        height: 16.h,
                                        color:
                                            communityCubit.currentLayout == 'upcoming' ? mainBlueColor : softGreyColor,
                                      ),
                                      widthBox(12.w),
                                      Text(
                                        'Upcoming',
                                        style: mainStyle(context, 11,
                                            weight: FontWeight.w800,
                                            color: communityCubit.currentLayout == 'upcoming'
                                                ? mainBlueColor
                                                : softGreyColor),
                                      )
                                    ],
                                  ),
                                  heightBox(5.h),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: 2.h,
                                    color: communityCubit.currentLayout == 'upcoming' ? mainBlueColor : softGreyColor,
                                    width: communityCubit.currentLayout == 'upcoming' ? 0.4.sw : 0.3.sw,
                                    // borderColor: Colors.transparent,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => communityCubit.changeCurrentView('past'),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  heightBox(5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/icons/upcomingLive.svg',
                                        height: 16.h,
                                        color: communityCubit.currentLayout == 'past' ? mainBlueColor : softGreyColor,
                                      ),
                                      widthBox(12.w),
                                      Text(
                                        'Past',
                                        style: mainStyle(context, 11,
                                            weight: FontWeight.w800,
                                            color:
                                                communityCubit.currentLayout == 'past' ? mainBlueColor : softGreyColor),
                                      )
                                    ],
                                  ),
                                  heightBox(5.h),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: 2.h,
                                    color: communityCubit.currentLayout == 'past' ? mainBlueColor : softGreyColor,
                                    width: communityCubit.currentLayout == 'past' ? 0.4.sw : 0.3.sw,
                                    // borderColor: Colors.transparent,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox(7.h),
                    Expanded(
                      child: communityCubit.currentLayout == 'live'
                          ? const LiveNowView()
                          : communityCubit.currentLayout == 'upcoming'
                              ? const UpcomingLiveView()
                              : const UpcomingLiveView(),
                    )
                  ],
                ),
              ),
              // Center(
              //     child: GestureDetector(
              //   onTap: () => pushNewScreenLayout(
              //       context,
              //       const LivePage(
              //         liveID: 'test12365656565679876ghvbnvbnv',
              //         isHost: false,
              //
              //         /// audience false
              //         /// true for host
              //         /// this will change the layout view behaviour
              //       ),
              //       false),
              //   child: Container(
              //     color: Colors.red,
              //     height: 33,
              //     width: 200,
              //     child: Center(
              //         child: Text(
              //       'Go Live..',
              //       style: mainStyle(context,
              //         26.0,
              //         color: Colors.white,
              //       ),
              //     )),
              //   ),
              // )),
            ],
          );
        },
      ),
    );
  }
}
