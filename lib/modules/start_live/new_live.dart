// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:mena/core/functions/main_funcs.dart';
// import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
// import 'package:mena/modules/start_live/ser_sok.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// class StartLivePage extends StatefulWidget {
//   const StartLivePage({
//     super.key,
//   });

//   @override
//   State<StartLivePage> createState() => _StartLivePageState();
// }

// class _StartLivePageState extends State<StartLivePage> {
//   static const String _webSocketServerUrl = 'https://live.menaaii.com:3000';

//   late final Socket? socket = SignallingService.instance.socket;
//   late final RTCVideoRenderer _localRTCVideoRenderer = RTCVideoRenderer();
//   late final RTCVideoRenderer _remoteRTCVideoRenderer = RTCVideoRenderer();
//   MediaStream? _localStream;
//   RTCPeerConnection? _rtcPeerConnection;
//   List<RTCIceCandidate> rtcIceCandidates = [];

//   bool isAudioOn = true;
//   bool isVideoOn = true;
//   bool isFrontCameraSelected = true;
//   late String roomId;
//   @override
//   void initState() {
//     super.initState();

//     LiveCubit liveCubit = LiveCubit.get(context);

//     roomId = liveCubit.goLiveModel!.data.roomId.toString();

//     SignallingService.instance.init(
//       websocketUrl: _webSocketServerUrl,
//     );
//     socket?.onAny((event, data) => logg('anyyy $event    $data'));

//     _localRTCVideoRenderer.initialize();
//     _remoteRTCVideoRenderer.initialize();
//     _setupPeerConnection();

//     logg('the room id : $roomId');
//   }

//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   Future<void> _setupPeerConnection() async {
//     _rtcPeerConnection = await createPeerConnection({
//       'iceServers': [
//         {
//           'urls': ['stun:3.28.124.112:3478', 'turn:3.28.124.112:3478']
//         }
//       ]
//     });

//     _rtcPeerConnection!.onTrack = (event) {
//       _remoteRTCVideoRenderer.srcObject = event.streams[0];
//       setState(() {});
//     };

//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': isAudioOn,
//       'video': isVideoOn
//           ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
//           : false,
//     });

//     _localStream!.getTracks().forEach((track) {
//       _rtcPeerConnection!.addTrack(track, _localStream!);
//     });

//     _localRTCVideoRenderer.srcObject = _localStream;
//     setState(() {});

//     socket?.on('message', (data) {
//       _handleIncomingCall(data);
//     });
//   }

//   Future<void> _handleIncomingCall(data) async {
//     socket?.on('IceCandidate', _handleIceCandidate);

//     await _rtcPeerConnection!.setRemoteDescription(
//       RTCSessionDescription(data['answer']['sdp'], data['answer']['type']),
//     );

//     final answer = await _rtcPeerConnection!.createAnswer();
//     await _rtcPeerConnection!.setLocalDescription(answer);

//     socket?.emit(
//         'message',
//         jsonEncode({
//           'type': 'checkMeeting',
//           'username': 'ZainStreamer',
//           'meetingId': roomId,
//           'moderator': true,
//           'authMode': 'disabled',
//           'moderatorRights': 'disabled',
//           'watch': false,
//           'micMuted': false,
//           'videoMuted': false,
//         }));
//   }

//   void _handleIceCandidate(data) {
//     final candidate = data['iceCandidate']['candidate'];
//     final sdpMid = data['iceCandidate']['id'];
//     final sdpMLineIndex = data['iceCandidate']['label'];

//     _rtcPeerConnection!.addCandidate(
//       RTCIceCandidate(
//         candidate,
//         sdpMid,
//         sdpMLineIndex,
//       ),
//     );
//   }

//   void _leaveCall() {
//     Navigator.pop(context);
//   }

//   void _toggleMic() {
//     isAudioOn = !isAudioOn;
//     _localStream?.getAudioTracks().forEach((track) {
//       track.enabled = isAudioOn;
//     });
//     setState(() {});
//   }

//   void _toggleCamera() {
//     isVideoOn = !isVideoOn;
//     _localStream?.getVideoTracks().forEach((track) {
//       track.enabled = isVideoOn;
//     });
//     setState(() {});
//   }

//   void _switchCamera() {
//     isFrontCameraSelected = !isFrontCameraSelected;
//     _localStream?.getVideoTracks().forEach((track) {
//       // ignore: deprecated_member_use
//       track.switchCamera();
//     });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: const Text('P2P Call App'),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   RTCVideoView(
//                     _remoteRTCVideoRenderer,
//                     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         IconButton(
//                           icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
//                           onPressed: _toggleMic,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.call_end),
//                           iconSize: 30,
//                           onPressed: _leaveCall,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.cameraswitch),
//                           onPressed: _switchCamera,
//                         ),
//                         IconButton(
//                           icon: Icon(
//                               isVideoOn ? Icons.videocam : Icons.videocam_off),
//                           onPressed: _toggleCamera,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _localRTCVideoRenderer.dispose();
//     _remoteRTCVideoRenderer.dispose();
//     _localStream?.dispose();
//     _rtcPeerConnection?.dispose();
//     super.dispose();
//   }
// }
