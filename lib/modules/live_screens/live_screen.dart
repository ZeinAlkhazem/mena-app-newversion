// import 'dart:math';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
// import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/network/network_constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final String liveTitle;
  final String liveGoal;
  final String liveTopic;
  final bool isHost;


  const LivePage({
    Key? key,
    required this.liveID,
    required this.liveTitle,
    required this.liveGoal,
    required this.liveTopic,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(),
//       body: ZegoUIKitPrebuiltLiveStreaming(
//         // designSize: const Size(360, 770),
//         appID: zegoAppId,
//
//         // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign: zegoAppSign,
//         // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: MainCubit.get(context).userInfoModel != null
//             ? MainCubit.get(context).userInfoModel!.data.user.id.toString()
//             : generateRandUserID,
//         userName: MainCubit.get(context).userInfoModel != null
//             ? '${MainCubit.get(context).userInfoModel!.data.user.abbreviation ?? ''} ${MainCubit.get(context).userInfoModel!.data.user.fullName}'
//             : generateRandUserID,
//         liveID: widget.liveID,
//         secondaryBar: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               LiveTitleWidget(text: 'Title: ${widget.liveTitle}'),
//               LiveTitleWidget(text: 'Goal: ${widget.liveGoal}'),
//               LiveTitleWidget(text: 'Topic: ${widget.liveTopic}'),
//               // DefaultContainer(
//               //   backColor: Colors.white.withOpacity(0.8),
//               //   borderColor: Colors.white.withOpacity(0.7),
//               //   radius: 35.sp,
//               //   width: 0.25.sw,
//               //   childWidget: Padding(
//               //     padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8),
//               //     child: Center(
//               //       child: Text(
//               //         widget.liveTopic,
//               //         style: mainStyle(context, 14),
//               //         maxLines: 2,
//               //         textAlign: TextAlign.center,
//               //         overflow: TextOverflow.ellipsis,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // DefaultContainer(
//               //   backColor: Colors.white.withOpacity(0.8),
//               //   borderColor: Colors.white.withOpacity(0.7),
//               //   radius: 35.sp,
//               //   width: 0.25.sw,
//               //   childWidget: Padding(
//               //     padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8),
//               //     child: Center(
//               //       child: Text(
//               //         widget.liveGoal,
//               //         style: mainStyle(context, 14),
//               //         maxLines: 2,
//               //         textAlign: TextAlign.center,
//               //         overflow: TextOverflow.ellipsis,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
// // secondaryBar: R,
//         config: widget.isHost
//             ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
//             : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
// //         ..onLeaveLiveStreaming = () {
// //           if (widget.isHost) {
// //             liveCubit.setLiveStatusToServer(isStart: false);
// //           Navigator.pop(context);
// //             /// host
// //             logg('host live ended2');
// //           } else {
// //             /// audience
// //             logg('audience live ended2');
// //           }
// //         }
//           ..startLiveButtonBuilder = (context, startLive) {
//             return DefaultButton(
//               onClick: () {
//                 log('live started');
//                 if (widget.isHost) {
//                   liveCubit.setLiveStatusToServer(isStart: true);
//                 }
//                 startLive();
//               },
//               text: 'Start',
//               width: 0.3.sw,
//               height: 55.h,
//               fontSize: 22,
//             );
//             // null;
//           }
//           ..onLiveStreamingEnded = () {
//             if (widget.isHost) {
//               liveCubit.setLiveStatusToServer(isStart: false);
//               Navigator.pop(context);
//               ///
//               ///
//               /// host
//               ///
//               ///
//               logg('host live ended3');
//             } else {
//               /// audience
//               logg('audience live ended3');
//             }
//           },
//
//         // onLiveStart: () {
//         //   log('live started');
//         //   if (widget.isHost) {
//         //     liveCubit.setLiveStatusToServer(isStart: true);
//         //   }
//         // },
//
//         // onLiveEnd: () async {
//         //   if (widget.isHost) {
//         //     liveCubit.setLiveStatusToServer(isStart: false);
//         //
//         //     /// host
//         //     logg('host live ended');
//         //   } else {
//         //     /// audience
//         //     logg('audience live ended');
//         //   }
//         // },
//       ),
    );
  }
}

class LiveTitleWidget extends StatefulWidget {
  const LiveTitleWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<LiveTitleWidget> createState() => _LiveTitleWidgetState();
}

class _LiveTitleWidgetState extends State<LiveTitleWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      backColor: Colors.white.withOpacity(0.8),
      borderColor: Colors.white.withOpacity(0.7),
      radius: 35.sp,
      width: 0.29.sw,
      childWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.text,
                  style: mainStyle(context, 44.sp),
                  maxLines: isExpanded ? 9 : 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                  // color: Colors.white.withOpacity(0.8),
                  child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_sharp
                      : Icons.keyboard_arrow_down_sharp,
                  size: 18.sp,
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}

/// Note that the userID needs to be globally unique,
/// this demo use a random userID for test.
String generateRandUserID = math.Random().nextInt(10000).toString();
