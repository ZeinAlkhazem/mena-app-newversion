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
import 'package:mena/modules/start_live/widget/comments_live_list.dart';
import 'package:mena/modules/start_live/widget/header_live_screen.dart';
import 'package:mena/modules/start_live/widget/live_message_inputfield.dart';
import 'package:mena/modules/start_live/widget/paused_live.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import 'cubit/start_live_cubit.dart';

class StartLivePage extends StatefulWidget {
  const StartLivePage({Key? key, this.goal, this.title, this.topic})
      : super(key: key);

  final String? title;
  final String? goal;
  final String? topic;

  @override
  State<StartLivePage> createState() => _StartLivePageState();
}

class _StartLivePageState extends State<StartLivePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final RTCVideoRenderer _remoteVideoRenderer = RTCVideoRenderer();
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  int count = 5;
  bool get _isRec => _mediaRecorder != null;

  List<MediaDeviceInfo>? _mediaDevicesList;
  RTCPeerConnection? _peerConnection;
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
    logg('the room id : ${roomId}');
    Socket socket = mainCubit.socket;
    socket.onAny((event, data) => logg('anyyy ${event}    ${data}'));
    socket.on('message', (data) {
      switch (jsonDecode(data)['type']) {
        case 'join':
          handleJoin(jsonDecode(data), mainCubit);
          break;
        case 'candidate':
          handleCandidate(jsonDecode(data));
          break;

        case 'checkMeetingResult':
          if (jsonDecode(data)['result']) {
            logg('true');
          } else {
            logg('false');
          }
          if (jsonDecode(data)['result']) {
            _makeCall(mainCubit, roomId);
          }
          break;
      }
      if (mounted) {
        StartLiveCubit pros = StartLiveCubit.get(context);
        pros.getProviders();
        logg('providerssss :" ${pros.providers}');
      }
    });

    mainCubit.sendMessage({
      'type': 'checkMeeting',
      'username': 'ZainStreamer',
      'meetingId': roomId,
      'moderator': true,
      'authMode': 'disabled',
      'moderatorRights': 'disabled',
      'watch': false,
      'micMuted': false,
      'videoMuted': false,
    });
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

  void handleCandidate(data) {
    var currentConnection = connections[data['fromSocketId']];

    if (data['candidate']['sdpMLineIndex'] == null) {
      int candidateIndex = int.parse(data['sdpMLineIndex']);
      currentConnection.addCandidate(new RTCIceCandidate(
          data['candidate'], data['sdpMid'], candidateIndex));
    } else {
      int candidateIndex = data['candidate']['sdpMLineIndex'];
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
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  List<UserName> usernames = [];
  List<String> eventss = [];
  Map<String, dynamic> connections = {};
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
    await _remoteVideoRenderer.initialize();
  }

  void _makeCall(MainCubit mainCubit, String roomId) async {
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
      logg('send join');
      if (!_inCalling) {
        mainCubit.sendMessage({
          'type': 'join',
          'username': "ZainStreamer",
          'meetingId': roomId,
          'moderator': true,
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
    // _createOffer(mainCubit, _peerConnection);
    setState(() {
      _inCalling = true;
    });
  }

  handleJoin(data, MainCubit mainCubit) async {
    Socket socket = mainCubit.socket;
    logg('handleeeeeeeeeeeeee joiiiiiiiiin');
    // usernames[data['socketId']].username = data['username'];
    // usernames[data['socketId']].micMuted = data['micMuted'];
    // usernames[data['socketId']].watch = data['watch'];
    // usernames[data['socketId']].videoMuted = data['videoMuted'];

    RTCPeerConnection connection = await createPeerConnection(configuration);

    connections[data['socketId']] = connection;
    setupListeners(
        connection, data['socketId'], data['uuid'], data['watch'], mainCubit);
    connection.createOffer({'OfferToReceiveVideo': true}).then((offer) {
      return connection.setLocalDescription(offer);
    }).then((value) async {
      logg('sending: ${connection.getLocalDescription()}');
      connection.getLocalDescription().then((localDesc) {
        RTCSessionDescriptionSerializer serializer =
            RTCSessionDescriptionSerializer();
        socket.emit(
            'message',
            json.encode({
              'type': 'offer',
              'sdp': serializer.serialize(localDesc),
              'username': "Zain",
              'fromSocketId': socket.id,
              'toSocketId': data['socketId'],
              'uuid': "234234234",
              'watch': true,
              'micMuted': false,
              'videoMuted': false,
            }));
      });
    });
  }

  handleAnswer(data) {
    logg('handleAnswer ssssssssss ${data['fromSocketId']}');
    var currentConnection = connections[data['fromSocketId']];
    if (currentConnection) {
      currentConnection.setRemoteDescription(data['answer']);
    }
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
      _remoteVideoRenderer.srcObject = _remoteStream;
      connection.onAddStream = (stream) {
        _remoteVideoRenderer.srcObject = _remoteStream;
        setState(() {});
      };

      List<MediaStreamTrack> videoTracks = event.streams[0].getVideoTracks();
      if (videoTracks.isNotEmpty) {
        logg('asdasdasdasdasda s  ' + videoTracks[0].toString());
        setState(() {});
      } else {
        logg('the trackssssssss are not empty');
      }
      setState(() {});
    };
  }

  void _createOffer(MainCubit mainCubit, _peerConnection) async {
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});

    _peerConnection!.setLocalDescription(description);
  }

  bool isFrontCamera = true;

  void switchCamera() async {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      ;
      // while (value == this.isFrontCamera)
      //   value = await Helper.switchCamera(_localStream!.getVideoTracks()[0]); ;
      // this.isFrontCamera = value;
    }
  }

  void flipCamera() {
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
        body: Stack(
          children: [
            RTCVideoView(_localRenderer,
                mirror: true,
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

class RTCSessionDescriptionSerializer {
  Map<String, dynamic> serialize(RTCSessionDescription? sessionDescription) {
    return {
      'type': sessionDescription?.type,
      'sdp': sessionDescription?.sdp,
    };
  }
}
