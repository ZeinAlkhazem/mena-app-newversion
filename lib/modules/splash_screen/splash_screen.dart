import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/splash_screen/route_engine.dart';
import 'package:video_player/video_player.dart';

import '../../core/shared_widgets/error_widgets.dart';
import '../home_screen/cubit/home_screen_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late VideoPlayerController _controller;

  void moveToRouteEngine(BuildContext context) {
    logg('navigating to route engine');
    navigateToAndFinishUntil(context, const RouteEngine());
  }

  void moveToConnectionErrorScreen(BuildContext context) {
    logg('ConnectionErrorScreen');
    navigateToAndFinishUntil(context, const ConnectionErrorScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    // animation();
    ///
    ///
    // videoControl();
    MainCubit.get(context).checkPermAndSaveLatLng(context).then((value) {
      MainCubit.get(context).getConfigData().then((value) async {
        MainCubit.get(context).getCountersData();
        /// commented for now
        MainCubit.get(context).checkConnectivity().then((value) async {
          if (value == true) {
            await HomeScreenCubit.get(context)
              ..changeSelectedHomePlatform(MainCubit.get(context).configModel!.data.platforms[0].id!).then((value) async{
            await    MainCubit.get(context).checkSetUpData().then((value) async{
              await Future.delayed(Duration(milliseconds: 2000));
              moveToRouteEngine(context);
            });
              });
          } else
          // not connected
          {
            moveToConnectionErrorScreen(context);
          }
        });

        ///
        // if(_controller.value.duration==await _controller.position){
        //   return Future.delayed(const Duration(milliseconds: 10)).then((value) =>
        //
        //   /// set minimum duration to complete splash continue
        //   ///
        //   /// get config data
        //   ///
        //   ///
        //   MainCubit.get(context)
        //       .checkConnectivity()
        //       .then((value) => value == true
        //       ? moveToRouteEngine(context)
        //       : // not connected
        //   moveToConnectionErrorScreen(context)));
        // }
      });
    });

    ///
    ///
    ///
    ///
    ///
    super.initState();
  }

  // Future<void> videoControl() async {
  //   _controller = VideoPlayerController.asset('assets/video/mena2.mp4',
  //
  //       videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,));
  //   await Future.delayed(const Duration(seconds: 1));
  //   _controller.initialize().then((_) async {
  //     _controller.setVolume(0.0);
  //     // _controller.seekTo(Duration.zero);
  //     // _controller.setLooping(false);
  //     // _controller.setPlaybackSpeed(1);
  //     logg('play');
  //
  //     ///
  //     ///
  //     await Future.delayed(const Duration(seconds: 1));
  //     logg('playyy');
  //     _controller.play().then((value) => logg('started'));
  //     // _controller.value.isInitialized?
  //     // _controller.value.isPlaying?_controller.pause():
  //     //
  //     // Future.delayed(Duration(milliseconds: 50)).then((value) => _controller.play())
  //     //     :_controller.initialize();
  //     setState(() {});
  //
  //     ///
  //     _controller.addListener(() async {
  //       // String currentVidPosition=  _controller.position..toString();
  //       // Implement your calls inside these conditions' bodies :
  //       if (_controller.value.position ==
  //           Duration(seconds: 1, minutes: 0, hours: 0)) {
  //         print('video Started');
  //       }
  //       if (_controller.value.position == _controller.value.duration) {
  //         print('video Ended');
  //         if (MainCubit.get(context).configModel != null) {
  //           logg('MainCubit.get(context).configModel != null');
  //           return Future.delayed(const Duration(milliseconds: 10)).then(
  //               (value) =>
  //
  //                   /// set minimum duration to complete splash continue
  //                   ///
  //                   /// get config data
  //                   ///
  //                   ///
  //                   MainCubit.get(context)
  //                       .checkConnectivity()
  //                       .then((value) => value == true
  //                           ? moveToRouteEngine(context)
  //                           : // not connected
  //                           moveToConnectionErrorScreen(context)));
  //         } else {
  //           logg('else :: MainCubit.get(context).configModel != null');
  //           _controller.value.isInitialized
  //               ? _controller.value.isPlaying
  //                   ? _controller.pause()
  //                   : _controller.play()
  //               : _controller.initialize();
  //           setState(() {});
  //         }
  //         setState(() {});
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    logg('dispose splash');
    // _controller.dispose().then((value) => logg('video player disposed'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     if (_controller.value.isInitialized) {
        //       logg('isInitialized');
        //       if (_controller.value.isPlaying) {
        //         logg('playing');
        //         _controller.pause();
        //       } else {
        //         logg('paused');
        //         _controller.play();
        //       }
        //     } else {
        //       logg('not isInitialized');
        //       _controller.initialize();
        //     }
        //
        //     setState(() {});
        //   },
        // ),
        body: Center(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(defaultHorizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/video/pre.json', height: 0.25.sh),
                        SvgPicture.asset(
                          'assets/svg/mena8.svg',
                          width: 0.6.sw,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'COPYRIGHT @2022 MENA PLATFORMS TECHNOLOGY',
                    style: mainStyle(
                      context,
                      11,
                      color: newDarkGreyColor,
                      weight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

/// test it
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
