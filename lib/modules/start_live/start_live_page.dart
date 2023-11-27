// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Project imports:
import 'package:mena/modules/start_live/cubit/start_live_cubit.dart';
import 'package:mena/modules/start_live/model_live_user.dart';
import 'package:mena/modules/start_live/stack_live.dart';

// ignore: library_prefixes

Map<String, dynamic> configuration = {
  "iceServers": [
    {'url': 'stun:3.28.124.112:3478'},
    {
      "url": "turn:3.28.124.112:3478",
      "username": "ubuntu",
      "credential": r'$#@ubuntu$#@',
    },
  ],
};

Map<String, dynamic> offerSdpConstraints = {
  "mandatory": {
    "OfferToReceiveAudio": true,
    "OfferToReceiveVideo": true,
  },
  "optional": [],
};

class StartLivePage extends StatefulWidget {
  const StartLivePage({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<StartLivePage> createState() => _StartLivePageState();
}

class _StartLivePageState extends State<StartLivePage> {
  MediaStream? _remoteStream;
  late final RTCVideoRenderer _remoteVideoRenderer = RTCVideoRenderer();
  // ignore: unused_field
  final _localRTCVideoRenderer = RTCVideoRenderer();
  List<RTCIceCandidate> rtcIceCadidates = [];

  bool _inCalling = false;
  RTCPeerConnection? _peerConnection;
  var logger = Logger();
  Map<String, dynamic> connections = {};

  @override
  void initState() {
    super.initState();
    String roomId = widget.roomId;
    initRenderers();
    startSocket(roomId);
  }

  void createAndSetupPeerConnection() async {
    RTCPeerConnection? peerConnection =
        await createPeerConnection(configuration);

    _peerConnection = peerConnection;
    _peerConnection!.getTransceivers();
  }

  Future<void> startSocket(String roomId) async {
    var startLiveCubit = StartLiveCubit.get(context);

    await startLiveCubit.socketInitial(context);

    startLiveCubit.socket
        ?.on('message', (data) => handleMessage(data, startLiveCubit.socket));

    startLiveCubit.socket?.emit(
      'message',
      jsonEncode({
        'type': 'checkMeeting',
        'username': 'ZainStreamer',
        'meetingId': roomId,
        'moderator': true,
        'authMode': 'disabled',
        'moderatorRights': 'disabled',
        'watch': false,
        'micMuted': false,
        'videoMuted': false,
      }),
    );

    createAndSetupPeerConnection();
  }

  void handleMessage(data, socket) {
    switch (jsonDecode(data)['type']) {
      case 'join':
        handleJoin(jsonDecode(data), socket!);
        break;
      case 'candidate':
        handleCandidate(jsonDecode(data));
        break;
      case 'answer':
        handleAnswer(jsonDecode(data));
        break;
      case 'checkMeetingResult':
        handleMeetingResult(jsonDecode(data), socket);
        break;
    }
  }

  void handleMeetingResult(data, socket) {
    if (data['result']) {
      _makeCall(socket!, widget.roomId);
    } else {
      logger.wtf('false');
    }
  }

  void handleCandidate(data) {
    RTCPeerConnection? currentConnection = connections[data['fromSocketId']];
    if (data['sdpMLineIndex'] != null) {
      try {
        int candidateIndex = int.parse(data['sdpMLineIndex']);

        var candidate =
            RTCIceCandidate(data['candidate'], data['sdpMid'], candidateIndex);

        currentConnection?.addCandidate(candidate);
      } catch (e) {
        logger.i('Error parsing sdpMLineIndex: $e');
      }
    }
  }

  handleAnswer(data) {
    try {
      RTCPeerConnection? currentConnection = connections[data['fromSocketId']];
      var answer =
          RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);

      currentConnection?.setRemoteDescription(answer);
    } catch (e) {
      logger.i("handle answer error : $e");
    }
  }

  void addTrackSafely(MediaStream? remoteStream) {
    if (_peerConnection != null && remoteStream != null) {
      List<MediaStreamTrack> videoTracks = remoteStream.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        _peerConnection?.addTrack(videoTracks[0], remoteStream);
      } else {
        logger.i('Error: No video tracks available in the MediaStream.');
      }
    } else {
      logger.i('Error: MediaStream or peer connection is null.');
    }
  }

  void initRenderers() async {
    await _remoteVideoRenderer.initialize();
  }

  void _makeCall(IO.Socket socket, String roomId) async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'environment': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _remoteStream = stream;
      _remoteVideoRenderer.srcObject = _remoteStream;
      logger.wtf('send join');
      if (!_inCalling) {
        socket.emit(
            'message',
            jsonEncode({
              'type': 'join',
              'username': "ZainStreamer",
              'meetingId': roomId,
              'moderator': true,
              'watch': true
            }));

        setState(() {
          _inCalling = true;
        });
      }
    } catch (e) {
      logger.i(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _inCalling = true;
    });
  }

  handleJoin(data, IO.Socket socket) async {
    connections[data['socketId']] = _peerConnection;
    setupListeners(data['socketId'], data['uuid'], data['watch'], socket);
    _peerConnection?.createOffer({'OfferToReceiveVideo': true}).then((offer) {
      return _peerConnection?.setLocalDescription(offer);
    }).then((value) async {
      logger.wtf('sending: ${_peerConnection?.getLocalDescription()}');
      _peerConnection?.getLocalDescription().then((localDesc) {
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
              'watch': false,
              'micMuted': false,
              'videoMuted': false,
            }));
      });
    });
  }

  setupListeners(socketId, opponentUuid, watch, IO.Socket socket) {
    addTrackSafely(_remoteStream);

    _peerConnection?.onIceCandidate = (event) {
      if (event.candidate != "") {
        logger.wtf('event.candidate ${event.candidate}');
        Map<String, dynamic> candiadte = {
          'candidate': event.candidate,
          'sdpMid': event.sdpMid.toString(),
          'sdpMLineIndex': event.sdpMLineIndex.toString(),
        };

        socket.emit(
            'message',
            json.encode({
              'type': 'candidate',
              'candidate': candiadte,
              'fromSocketId': socket.id,
              'toSocketId': socketId,
            }));
      }
    };

    _peerConnection?.onTrack = (event) {
      _remoteStream = event.streams[0];
      initRenderers();
      _remoteVideoRenderer.srcObject = _remoteStream;
      _peerConnection?.onAddStream = (stream) {
        _remoteVideoRenderer.srcObject = _remoteStream;
        setState(() {});
      };

      List<MediaStreamTrack> videoTracks = event.streams[0].getVideoTracks();
      if (videoTracks.isNotEmpty) {
        logger.wtf('asdasdasdasdasda s  ${videoTracks[0]}');
        setState(() {});
      } else {
        logger.wtf('the trackssssssss are not empty');
      }
      setState(() {});
    };
  }

  bool isFrontCamera = true;

  Future<void> switchCamera() async {
    try {
      if (_remoteStream != null) {
        var videoTracks = _remoteStream!.getVideoTracks();
        if (videoTracks.isNotEmpty) {
          // ignore: deprecated_member_use
          await videoTracks[0].switchCamera();
        }
      }
    } catch (e) {
      logger.i('Camera switch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            RTCVideoView(
              _remoteVideoRenderer,
              placeholderBuilder: (context) => const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
            StackLive(
              switchCamera: () => switchCamera(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remoteVideoRenderer.dispose();
    _remoteStream?.dispose();
    super.dispose();
  }
}
