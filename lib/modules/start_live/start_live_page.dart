import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/start_live/widget/comments_live_list.dart';
import 'package:mena/modules/start_live/widget/header_live_screen.dart';
import 'package:mena/modules/start_live/widget/live_message_inputfield.dart';
import 'package:mena/modules/start_live/widget/paused_live.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import 'cubit/start_live_cubit.dart';

class StartLivePage extends StatefulWidget {
  const StartLivePage({Key? key,this.goal,this.title,this.topic}):super(key:key);

 final  String? title;
 final  String? goal;
 final  String? topic;

  @override
  State<StartLivePage> createState() => _StartLivePageState();
}

class _StartLivePageState extends State<StartLivePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  int count = 5;
  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo>? _mediaDevicesList;
  void startCountdown() {
    // Create a periodic timer that fires every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          // When count reaches zero, navigate to the next page
          timer.cancel(); // Cancel the timer
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // startCountdown();
    animationController = AnimationController(vsync: this);

    animationController.duration = const Duration(milliseconds: 1500);

    animationController.forward();

    initRenderers();

    MainCubit mainCubit = MainCubit.get(context);
    LiveCubit liveCubit = LiveCubit.get(context);
    String roomId = liveCubit.goLiveModel!.data.roomId.toString();
    Socket socket = mainCubit.socket;
    socket.onAny((event, data) => logg('anyyy ${event}    ${data}'));
    socket.on('message', (data) {
      jsonDecode(data);

      logg(
          'this is the data returned from server : ${jsonDecode(data)['type']}');
      switch (jsonDecode(data)['type']) {
        case 'join':
          mainCubit.handleJoin(jsonDecode(data));
          break;
        case 'checkMeetingResult':
          if (jsonDecode(data)['result']) {
            logg('true');
          } else {
            logg('false');
          }
          if (jsonDecode(data)['result']) {
            _makeCall();
          }
          break;
      }
    });

    mainCubit.sendMessage({
      'type': 'checkMeeting',
      'username': 'ZainTest',
      'meetingId': roomId,
      'moderator': true,
      'authMode': 'disabled',
      'moderatorRights': 'disabled',
      'watch': true,
      'micMuted': false,
      'videoMuted': false,
    });

    Map<String,dynamic> configuration = {
                        "iceServers": [
                            {
                                "urls": "stun:3.28.124.112:3478",
                            },
                            {
                                "urls": "turn:3.28.124.112:3478",
                                "username": "ubuntu",
                                "credential": "\$#@ubuntu\$#@",
                            }
                        ],
                    };
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
Future<void> stopLocalVideoStreamTracks() async {
    print("stopLocalVideoStreamTracks");
    await Future.forEach<MediaStreamTrack>(_localStream?.getVideoTracks() ?? [],
            (track) async {
          try {
            await track.stop();
            print("stopped track ${track.kind}");
          } catch (e, s) {
            print("stopLocalVideoStreamTracks: $e\n$s");
          }
        });
  }
  void initRenderers() async {
    await _localRenderer.initialize();
  }
 
  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'environment': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

   bool isFrontCamera = true;

  void switchCamera() async {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]); ;
      // while (value == this.isFrontCamera)
      //   value = await Helper.switchCamera(_localStream!.getVideoTracks()[0]); ;
      // this.isFrontCamera = value;
    }
  }
  void flipCamera(){
    // _localRenderer.v
  }
  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return SafeArea(
      child: Scaffold(
        body: 
           Stack(
                children: [
                  RTCVideoView(_localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  Container(
                    height: 1.sh,
                    width: 1.sw,
                    child: Column(children: [
                      heightBox(10.h),
                      Visibility(
                          visible: !keyboardVisible,
                          child: const HeaderLiveScreen()),
                      const Spacer(),
                      BlocConsumer<StartLiveCubit, StartLiveState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return startLiveCubit.isLivePaused
                              ? const PausedLive()
                              : const SizedBox();
                        },
                      ),
                      const Spacer(),
                      BlocConsumer<StartLiveCubit, StartLiveState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Visibility(
                                visible: !keyboardVisible &&
                                    !animationController.isCompleted,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  width: double.infinity,
                                  child: ShaderMask(
                                    shaderCallback: (Rect rect) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          mainBlueColor,
                                          mainBlueColor,
                                          Colors.transparent,
                                          Colors.transparent
                                        ],
                                        stops: const [0.0, 0.1, 0.9, 1.0],
                                      ).createShader(rect);
                                    },
                                    blendMode: BlendMode.dstOut,
                                    child: Lottie.asset(
                                      'assets/lottie/hearts-feedback.json',
                                      height: 200.h,
                                      fit: BoxFit.contain,
                                      repeat: false,
                                      controller: animationController,
                                    ),
                                  ),
                                ),
                              ),
                              
                              CommentsLiveList(
                                height: keyboardVisible
                                    ? 0.15.sh
                                    : startLiveCubit.heightComments,
                              ),
                              
                              Visibility(
                                visible: !keyboardVisible,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  height: 40.h,
                                  child: IconButton(
                                    onPressed: () => startLiveCubit
                                        .onShowDescription(context),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_up_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                              ),
                              child:
                                  BlocConsumer<StartLiveCubit, StartLiveState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return LiveMessageInputField(
                                    suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        style: const ButtonStyle(
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap),
                                        onPressed: () => keyboardVisible
                                            ? startLiveCubit.sendComment()
                                            : startLiveCubit
                                                .emojiPicker(context),
                                        icon: SvgPicture.asset(
                                          color: newLightGreyColor,
                                          keyboardVisible
                                              ? 'assets/svg/icons/shareLocation.svg'
                                              : 'assets/svg/vmoji_outline.svg',
                                        )),
                                    controller: startLiveCubit.liveMessageText,
                                  );
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !keyboardVisible,
                            child: IconButton(
                              onPressed: () {
                                switchCamera();
                              },
                              icon: SvgPicture.asset(
                                'assets/svg/camera_outline_gray.svg',
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !keyboardVisible,
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/svg/user_add_gray.svg',
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !keyboardVisible,
                            child: LikeButton(
                              size: 25.sp,
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              onTap: (isLiked) async {
                                isLiked ? null : animationController.reset();

                                animationController.duration =
                                    const Duration(milliseconds: 1500);

                                isLiked ? null : animationController.forward();

                                startLiveCubit.onLikeButtonTapped(isLiked);

                                return !isLiked;
                              },
                              likeBuilder: (bool isLiked) {
                                return SvgPicture.asset(
                                  isLiked
                                      ? 'assets/svg/icons/love heart.svg'
                                      : 'assets/svg/icons/loveHeart.svg',
                                  color: isLiked
                                      ? alertRedColor
                                      : newLightGreyColor,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      heightBox(10.h)
                    ]),
                  ),
                ],
              ),
      ),
    );
  }
}
