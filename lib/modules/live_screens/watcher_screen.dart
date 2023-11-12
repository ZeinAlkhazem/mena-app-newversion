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
import 'package:mena/modules/create_live/cubit/create_live_cubit.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/start_live/cubit/start_live_cubit.dart';
import 'package:mena/modules/start_live/widget/comments_live_list.dart';
import 'package:mena/modules/start_live/widget/header_live_screen.dart';
import 'package:mena/modules/start_live/widget/live_message_inputfield.dart';
import 'package:mena/modules/start_live/widget/paused_live.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';

class WatcherScreen extends StatefulWidget {
  const WatcherScreen(
      {Key? key, this.goal, this.title, this.topic, this.remoteRoomId})
      : super(key: key);

  final String? title;
  final String? goal;
  final String? topic;
  final String? remoteRoomId;

  @override
  State<WatcherScreen> createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen>
    with TickerProviderStateMixin {
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  late final AnimationController animationController;

  final _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteVideoRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  int count = 5;
  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo>? _mediaDevicesList;
  RTCPeerConnection? _peerConnection;
  @override
  void initState() {
    _remoteVideoRenderer.initialize();
    Timer.periodic(Duration(milliseconds: 16), (_) {
      _remoteVideoRenderer.renderVideo;
    });
    super.initState();
    MainCubit mainCubit = MainCubit.get(context);
    LiveCubit liveCubit = LiveCubit.get(context);
    String? roomId = widget.remoteRoomId;
    Socket socket = mainCubit.socket;
    socket.onAny((event, data) => logg('anyyy ${event}    ${data}'));
    socket.on('message', (data) {
      switch (jsonDecode(data)['type']) {
        case 'join':
          handleJoin(jsonDecode(data), mainCubit);
          break;
        case 'offer':
          handleOffer(jsonDecode(data), mainCubit);
          break;
        case 'answer':
          handleAnswer(jsonDecode(data));
          break;
        case 'candidate':
          handleCandidate(jsonDecode(data));
          break;
        case 'checkMeetingResult':
          if (jsonDecode(data)['result']) {
            _makeCall(mainCubit, roomId);
          }
          break;
      }
      // StartLiveCubit pros = StartLiveCubit.get(context);
      // pros.getProviders();
    });
    mainCubit.sendMessage({
      'type': 'checkMeeting',
      'username': 'ZainTest',
      'meetingId': roomId,
      'moderator': false,
      'authMode': 'disabled',
      'moderatorRights': 'disabled',
      'watch': true,
      'micMuted': false,
      'videoMuted': false,
    });

    animationController = AnimationController(vsync: this);

    animationController.duration = const Duration(milliseconds: 1500);

    animationController.forward();
  }

  handleAnswer(data) {
    logg('handleAnswer ssssssssss ${data.fromSocketId}');
    var currentConnection = connections[data.fromSocketId];
    if (currentConnection) {
      currentConnection.setRemoteDescription(data.answer);
    }
  }

  Map<String, dynamic> configuration = {
    "iceServers": [
      {
        "url": "stun:3.28.124.112:3478",
      },
      {
        "url": "turn:3.28.124.112:3478",
        "username": "ubuntu",
        "credential": "\$#@ubuntu\$#@",
      }
    ],
  };
  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  List<UserName> usernames = [];
  List<String> eventss = [];
  Map<String, dynamic> connections = {};
  handleJoin(data, MainCubit mainCubit) async {
    Socket socket = mainCubit.socket;
    logg('handleeeeeeeeeeeeee joiiiiiiiiin');
    usernames[data.socketId].username = data.username;
    usernames[data.socketId].micMuted = data.micMuted;
    usernames[data.socketId].watch = data.watch;
    usernames[data.socketId].videoMuted = data.videoMuted;

    RTCPeerConnection connection = await createPeerConnection(configuration);

    connections[data.socketId] = connection;
    setupListeners(connection, data.socketId, data.uuid, data.watch, mainCubit);
    connection.createOffer({'offerToReceiveVideo': true}).then((offer) {
      return connection.setLocalDescription(offer);
    }).then((value) => {
          mainCubit.sendMessage({
            'type': 'offer',
            'sdp': connection.getLocalDescription(),
            'username': "Zain",
            'fromSocketId': socket.id,
            'toSocketId': data.socketId,
            'uuid': "234234234",
            'watch': true,
            'micMuted': false,
            'videoMuted': false,
          })
        });
  }

  setupListeners(
      connection, socketId, opponentUuid, watch, MainCubit mainCubit) {
    _localStream
        ?.getTracks()
        .forEach((track) => connection.addTrack(track, _localStream));
    Socket socket = mainCubit.socket;

    connection.onIceCandidate = (event) {
      if (event.candidate != "") {
        logg('event.candidate ${event.candidate}');
        Map<String, dynamic> candiadte = {
          'candidate': event.candidate,
          'sdpMid': event.sdpMid.toString(),
          'sdpMLineIndex': event.sdpMLineIndex.toString(),
        };
        mainCubit.sendMessage({
          'type': 'candidate',
          'candidate': candiadte,
          'fromSocketId': socket.id,
          'toSocketId': socketId,
        });
      }
    };
    connection.onTrack = (event) {
      _remoteStream = event.streams[0];
      _remoteVideoRenderer.srcObject = event.streams[0];

      connection.onAddStream = (stream) {
        var tracks = _remoteStream?.getTracks();
        logg('the tracks are : ${tracks}');
        setState(() {});
      };

      List<MediaStreamTrack> videoTracks = _remoteStream!.getVideoTracks();
      videoTracks.forEach((element) {
        logg('the track is : ${element}');
        element.enabled = true;
      });
      if (videoTracks.isNotEmpty) {
        logg('asdasdasdasdasda s  ' + videoTracks[0].toString());
        setState(() {});
      } else {
        logg('the trackssssssss are not empty');
      }
      setState(() {});
    };
    connection.getStats().then((stats) {
      for (StatsReport stat in stats) {
        // Check if the statistic is a candidate pair statistic.
        if (stats.isNotEmpty) {
          // Get the first candidate pair.

          for (var statss in stats) {
            logg("candidatePair.values  :   ${statss.type.toString()}");
          }

          // Check if the candidate pair is succeeded.

          // The STUN and TURN servers are working.
        } else {
          // Log that the STUN and TURN servers are not working.
          logg("The STUN and TURN servers are not working.");
        }
      }
      // if (stats['stunIceCandidatePairs'].isNotEmpty) {
      //   logg("The STUN and TURN servers are working.");
      // } else {
      //   logg("The STUN and TURN servers are not working.");
      // }
    });
  }

  handleCandidate(data) {
    var currentConnection = connections[data['fromSocketId']];
    if (data['candidate'] != null && currentConnection != null) {
      logg('check nulllllllllls :${data}');
      MainCubit mainCubit = MainCubit.get(context);
      logg('check nulllllllllls :${mainCubit.socket.id}');
      int candidateIndex;
      if (data['candidate']['sdpMLineIndex'] == null) {
        int candidateIndex = int.parse(data['sdpMLineIndex']);
        currentConnection.addCandidate(new RTCIceCandidate(
            data['candidate'], data['sdpMid'], candidateIndex));
      } else {
        if (data['candidate']['sdpMLineIndex'] is String) {
          candidateIndex = int.parse(data['candidate']['sdpMLineIndex']);
        } else {
          candidateIndex = data['candidate']['sdpMLineIndex'];
        }
        currentConnection.addCandidate(new RTCIceCandidate(
            data['candidate']['candidate'],
            data['candidate']['sdpMid'],
            candidateIndex));
      }
      // RTCIceConnectionState iceConnectionState =
      //     currentConnection.iceConnectionState;

      // if (iceConnectionState ==
      //     RTCIceConnectionState.RTCIceConnectionStateConnected) {
      //   logg('ice is connected');
      // } else {
      //   logg('ice is not connected');
      // }
    }
  }

  handleOffer(data, MainCubit mainCubit) async {
    logg('offer data is ${data['sdp']['type']}');
    logg('offer data is ${data}');

    //initialize a new connection
    RTCPeerConnection connection = await createPeerConnection(configuration);
    logg('cccc : ${configuration}');
    connections[data['fromSocketId']] = connection;

    connection.setRemoteDescription(
        RTCSessionDescription(data['sdp']['sdp'], data['sdp']['type']));

    setupListeners(connection, data['fromSocketId'], data['uuid'],
        data['watch'], mainCubit);

    connection.createAnswer(offerSdpConstraints).then((answer) {
      setDescriptionAndSendAnswer(answer, data['fromSocketId'], mainCubit);
    });
  }

  setDescriptionAndSendAnswer(answer, fromSocketId, MainCubit mainCubit) {
    connections[fromSocketId].setLocalDescription(answer);
    Socket socket = mainCubit.socket;
    logg('the answer : ${answer}');

    mainCubit.sendMessage({
      'type': 'answer',
      'answer': {'sdp': answer.sdp, 'type': answer.type},
      'fromSocketId': socket.id,
      'toSocketId': fromSocketId,
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _remoteVideoRenderer.dispose();
    _localRenderer.dispose();
    _localStream?.dispose();
    super.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  void _makeCall(MainCubit mainCubit, String? roomId) async {
    try {
      if (!_inCalling) {
        mainCubit.sendMessage({
          'type': 'join',
          'username': "ZainJoin",
          'meetingId': roomId,
          'moderator': false,
          'watch': true
        });
        setState(() {
          _inCalling = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
  }

  bool isFrontCamera = true;

  void switchCamera() async {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void flipCamera() {}
  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            RTCVideoView(_remoteVideoRenderer,
                mirror: false,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
            Container(
              height: 1.sh,
              width: 1.sw,
              child: Column(children: [
                heightBox(10.h),
                Visibility(
                    visible: !keyboardVisible, child: const HeaderLiveScreen()),
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
                    return BlocConsumer<StartLiveCubit, StartLiveState>(
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
                                  onPressed: () =>
                                      startLiveCubit.onShowDescription(context),
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
                        child: BlocConsumer<StartLiveCubit, StartLiveState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return LiveMessageInputField(
                              suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  style: const ButtonStyle(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  onPressed: () => keyboardVisible
                                      ? startLiveCubit.sendComment()
                                      : startLiveCubit.emojiPicker(context),
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
                            color: isLiked ? alertRedColor : newLightGreyColor,
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

class UserName {
  UserName({
    this.username,
    this.micMuted,
    this.watch,
    this.videoMuted,
  });

  String? username;
  bool? micMuted;
  bool? videoMuted;
  bool? watch;
}
