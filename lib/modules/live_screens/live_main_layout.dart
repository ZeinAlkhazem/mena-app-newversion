import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/create_live/create_live_screen.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/live_screen.dart';
import 'package:mena/modules/live_screens/start_live_form.dart';
import '../../core/constants/validators.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/local_models.dart';

class LiveMainLayout extends StatelessWidget {
  const LiveMainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Padding(
      padding: EdgeInsets.only(bottom: rainBowBarBottomPadding(context)),
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: const [
        //     // FloatingLive(
        //     //   heroTag: 'LiveInLiveScreen',
        //     // ),
        //     // widthBox(10.w),
        //     SharedFloatingMsngr(
        //       heroTag: 'LiveScreen',
        //     ),
        //   ],
        // ),
        body: MainBackground(
          bodyWidget: BlocConsumer<LiveCubit, LiveState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: rainBowBarHeight),

                ///rainbow padding for scroll
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        heightBox(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => liveCubit.changeCurrentView(true),
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
                                          color: liveCubit.liveNowLayout ? mainBlueColor : softGreyColor,
                                        ),
                                        widthBox(12.w),
                                        Text(
                                          'Live Now',
                                          style: mainStyle(context, 11,
                                              weight: FontWeight.w800,
                                              color: liveCubit.liveNowLayout ? mainBlueColor : softGreyColor),
                                        )
                                      ],
                                    ),
                                    heightBox(5.h),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 100),
                                      height: 2.h,
                                      color: liveCubit.liveNowLayout ? mainBlueColor : softGreyColor,
                                      width: liveCubit.liveNowLayout ? 0.4.sw : 0.3.sw,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            widthBox(30.w),
                            GestureDetector(
                              onTap: () => liveCubit.changeCurrentView(false),
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
                                          color: !liveCubit.liveNowLayout ? mainBlueColor : softGreyColor,
                                        ),
                                        widthBox(12.w),
                                        Text(
                                          'Upcoming',
                                          style: mainStyle(context, 11,
                                              weight: FontWeight.w800,
                                              color: !liveCubit.liveNowLayout ? mainBlueColor : softGreyColor),
                                        )
                                      ],
                                    ),
                                    heightBox(5.h),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 100),
                                      height: 2.h,
                                      color: !liveCubit.liveNowLayout ? mainBlueColor : softGreyColor,
                                      width: !liveCubit.liveNowLayout ? 0.4.sw : 0.3.sw,
                                      // borderColor: Colors.transparent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        heightBox(7.h),
                        Expanded(child: liveCubit.liveNowLayout ? const LiveNowView() : const UpcomingLiveView())
                      ],
                    )),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LiveNowView extends StatefulWidget {
  const LiveNowView({Key? key}) : super(key: key);

  @override
  State<LiveNowView> createState() => _LiveNowViewState();
}

class _LiveNowViewState extends State<LiveNowView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (LiveCubit.get(context).selectedNowLiveCat != null) {
      LiveCubit.get(context)
          .getLivesNowAndUpcoming(filter: 'live', categoryId: LiveCubit.get(context).selectedNowLiveCat!);
    } else {
      LiveCubit.get(context).getLivesNowAndUpcoming(filter: 'live', categoryId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context)..getLivesNowAndUpcomingCategories(filter: 'live');
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // heightBox(7.h),
                  (liveCubit.nowLiveCategoriesModel == null ||
                          state is GettingLiveCategories ||
                          liveCubit.nowLivesModel == null)
                      ? DefaultLoaderColor()
                      : LivesList(
                          categories: liveCubit.nowLiveCategoriesModel!.liveCategories,
                          livesByCategoryItems: liveCubit.nowLivesModel!.data.livesByCategory.livesByCategoryItem,
                          isNow: true,
                        ),
                ],
              ),
            ),
            if(getCachedToken() != null)
            Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    // navigateToWithoutNavBar(context, StartLiveFormLayout(), 'routeName');
                    navigateToWithoutNavBar(context, CreateLivePage(), 'routeName');
                    logg('go live');

                    // await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ZegoUIKitPrebuiltLiveStreaming(
                    //               appID: zegoAppId,
                    //               appSign: zegoAppSign,
                    //               userID: generateRandUserID,
                    //               userName: generateRandUserID,
                    //               liveID: 'widget.liveID',
                    //               config:
                    //                   ZegoUIKitPrebuiltLiveStreamingConfig
                    //                       .host(),
                    //             ))).then((value) async {
                    //   logg('zego live pop');
                    //   // await Future.delayed(Duration(seconds: 3));
                    //   await ScreenUtil.init(
                    //           context,
                    //           designSize: const Size(360, 770),
                    //           splitScreenMode: true)
                    //       .then((value) => logg('screen init '));
                    //   setState(() {
                    //
                    //   });
                    // });
                    // viewLiveModalBottomSheet(context, formKey, liveCubit, titleController,
                    //     goalController, topicController);
                  },
                  child: DefaultContainer(
                    radius: 35.sp,
                    backColor: mainBlueColor,
                    childWidget: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: defaultHorizontalPadding),
                      child: Text(
                        'Create',
                        style: mainStyle(context, 11, color: Colors.white, isBold: true),
                      ),
                    ),
                  ),
                ))
          ],
        );
      },
    );
  }
}

// class ProviderGoLiveBubble extends StatelessWidget {
//   const ProviderGoLiveBubble({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var liveCubit=LiveCubit.get(context);
//     return   getCachedToken() == null
//         ? widthBox(defaultHorizontalPadding)
//         :
//
//     ! MainCubit.get(context).isUserProvider()?
//     widthBox(defaultHorizontalPadding):
//     Row(
//       children: [
//         widthBox(
//           defaultHorizontalPadding,
//         ),
//         GestureDetector(
//           onTap: () async {
//             logg('go live');
//             var formKey = GlobalKey<FormState>();
//             TextEditingController titleController =
//             TextEditingController();
//             TextEditingController goalController = TextEditingController();
//             TextEditingController topicController =
//             TextEditingController();
//             liveCubit.changeSelectedStartLiveCat(liveCubit
//                 .nowLiveCategoriesModel!.liveCategories[0].id
//                 .toString());
//             liveCubit.updateThumbnailFile(null);
//
//             // await Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) =>
//             //             ZegoUIKitPrebuiltLiveStreaming(
//             //               appID: zegoAppId,
//             //               appSign: zegoAppSign,
//             //               userID: generateRandUserID,
//             //               userName: generateRandUserID,
//             //               liveID: 'widget.liveID',
//             //               config:
//             //                   ZegoUIKitPrebuiltLiveStreamingConfig
//             //                       .host(),
//             //             ))).then((value) async {
//             //   logg('zego live pop');
//             //   // await Future.delayed(Duration(seconds: 3));
//             //   await ScreenUtil.init(
//             //           context,
//             //           designSize: const Size(360, 770),
//             //           splitScreenMode: true)
//             //       .then((value) => logg('screen init '));
//             //   setState(() {
//             //
//             //   });
//             // });
//             viewLiveModalBottomSheet(context, formKey, liveCubit,
//                 titleController, goalController, topicController);
//           },
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Lottie.asset('assets/json/live.json',
//                   width: 60.sp, fit: BoxFit.fill),
//               SizedBox(height: 8.h),
//               Text(
//                 'Go live',
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: mainStyle(context, 9, weight: FontWeight.w700),
//               ),
//             ],
//           ),
//         ),
//         widthBox(
//           defaultHorizontalPadding / 2,
//         ),
//       ],
//     );
//   }
// }

class UpcomingLiveView extends StatefulWidget {
  const UpcomingLiveView({Key? key}) : super(key: key);

  @override
  State<UpcomingLiveView> createState() => _UpcomingLiveViewState();
}

class _UpcomingLiveViewState extends State<UpcomingLiveView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (LiveCubit.get(context).selectedUpcomingLiveCat != null) {
      LiveCubit.get(context)
          .getLivesNowAndUpcoming(filter: 'upcoming', categoryId: LiveCubit.get(context).selectedUpcomingLiveCat!);
    } else {
      LiveCubit.get(context).getLivesNowAndUpcoming(filter: 'upcoming', categoryId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context)..getLivesNowAndUpcomingCategories(filter: 'upcoming');
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (liveCubit.upcomingLiveCategoriesModel == null ||
                state is GettingLiveCategories ||
                liveCubit.upcomingLivesModel == null)
            ? DefaultLoaderColor()
            : LivesList(
                isNow: false,
                categories: liveCubit.upcomingLiveCategoriesModel!.liveCategories,
                livesByCategoryItems: liveCubit.upcomingLivesModel!.data.livesByCategory.livesByCategoryItem,
              );
      },
    );
  }
}
