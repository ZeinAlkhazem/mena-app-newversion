import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:locale_plus/locale_plus.dart';
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
            logg("# config model :${MainCubit.get(context).configModel}");
            await HomeScreenCubit.get(context)
              ..changeSelectedHomePlatform(MainCubit.get(context).configModel!.data.platforms[0].id!).then((value) async{
            await    MainCubit.get(context).checkSetUpData().then((value) async{
              await Future.delayed(Duration(milliseconds: 2000));
              moveToRouteEngine(context);
              // Future.delayed(const Duration(seconds: 4), () {
              //   moveToRouteEngine(context);
              // });
            });
              });
          } else
          // not connected
          {
            moveToConnectionErrorScreen(context);
          }
        });

        ///

      });
    });

    ///
    ///
    ///
    ///
    ///
    super.initState();
  }



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
                        SvgPicture.asset(
                          'assets/new_icons/mena_black.svg',
                          width: 110.w,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/new_icons/copyright_outline_20.svg',
                          width: 20.w,
                        ),
                        widthBox(4.w),
                        Text(
                          'MenaAi information Technology 2023',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff565656),
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Inter'
                          ),

                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
