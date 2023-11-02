import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BroadcastScreen(),
    );
  }
}

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  late IO.Socket socket;
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  _initSocket() async {
    await _localRenderer.initialize();

    final stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    _localRenderer.srcObject = stream;

    setState(() {});

    socket = IO.io('https://live.menaaii.com:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.emit("broadcaster");

    socket.on("answer", (data) async {
      print("answer");
      print(data);
      RTCSessionDescription x =
          RTCSessionDescription(data[1]['sdp'], data[1]["type"]);
      _peerConnection.setRemoteDescription(x);
    });

    socket.on("watcher", (data) async {
      print("watcher");

      _peerConnection = await cpc();
      final stream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': true});

      _localRenderer.srcObject = stream;

      stream.getTracks().forEach((track) {
        _peerConnection.addTrack(track, stream);
      });

      setState(() {});
      _peerConnection.onIceCandidate = (event) {
        if (event.candidate != null) {
          Map<String, dynamic> payload = {
            "id": data,
            "candidate": event.toMap()
          };
          socket.emit("candidate", payload);
        }
      };

      _peerConnection.createOffer().then((sdp) {
        _peerConnection.setLocalDescription(sdp);
      }).then((_) async{
        var x = await _peerConnection.getLocalDescription();
        Map<String, dynamic> payload = {
          "id": data,
          "offer": x!.toMap()
        };
        socket.emit("offer", [data,x.toMap()]);
      });
    });

    socket.on("candidate", (data) {
      print("candidate");
      print(data);
      _peerConnection.addCandidate(RTCIceCandidate(
          data[1]["candidate"], data[1]["sdpMid"], data[1]["sdpMLineIndex"]));
    });

    socket.on("disconnectPeer", (id) {
      print("disconnectPeer");
      _peerConnection.close();
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.close();
  }

  Future<RTCPeerConnection> cpc() async {
    final Map<String, dynamic> config = {
      'iceServers': [
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

    final peerConnection = await createPeerConnection(config, {});
    return peerConnection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcaster'),
      ),
      body: Center(
        child: RTCVideoView(
          _localRenderer,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// const MAX_RENDERERS = 5;
//
// class BroadcastWatcherScreen extends StatefulWidget {
//   const BroadcastWatcherScreen({super.key});
//
//   @override
//   State<BroadcastWatcherScreen> createState() => _BroadcastWatcherScreenState();
// }
//
// class _BroadcastWatcherScreenState extends State<BroadcastWatcherScreen> {
//   List<RTCPeerConnection?> _peerConnections = [];
//   List<RTCVideoRenderer?> _rendererList = [];
//   late IO.Socket socket;
//   bool isBroadcaster = true;
//   late RTCVideoRenderer _localRenderer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initRenderers();
//     _initSocket();
//
//     if (isBroadcaster) {
//       _initBroadcast();
//     }
//   }
//
//   void _initRenderers() {
//     _localRenderer = RTCVideoRenderer();
//     _localRenderer.initialize();
//     _rendererList.add(_localRenderer);
//
//     for (int i = 1; i < MAX_RENDERERS; i++) {
//       final newRenderer = RTCVideoRenderer();
//       newRenderer.initialize();
//       _rendererList.add(newRenderer);
//     }
//   }
//
//   _initSocket() async {
//     await _localRenderer.initialize();
//
//     socket = IO.io('http://20.0.0.189:8000', {
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });
//
//     socket.on("broadcaster", (data) {
//       // if (!isBroadcaster) {
//       //   isBroadcaster = true;
//       //   _initBroadcast();
//       // }
//       socket.emit("watcher");
//     });
//
//     socket.on("watcher", (data) async {
//       final emptyRenderer = _rendererList.firstWhere(
//           (renderer) => renderer!.srcObject == null,
//           orElse: () => null);
//
//       print('watcher');
//       print(data);
//
//       if (emptyRenderer != null) {
//         final stream = await navigator.mediaDevices
//             .getUserMedia({'video': true, 'audio': true});
//         emptyRenderer.srcObject = stream;
//
//         final peerConnection = await _createPeerConnection();
//         _configurePeerConnection(peerConnection, stream, data);
//         print("watcherrrrrrrrrrr");
//         print(peerConnection.signalingState);
//         _peerConnections.add(peerConnection);
//
//         setState(() {});
//       }
//     });
//
// // Handle incoming offer from the remote peer
//     socket.on("offer", (data) async {
//       final emptyPeerConnectionIndex = _peerConnections.indexWhere(
//               (pc) => pc == null || pc.signalingState == RTCSignalingState.RTCSignalingStateClosed);
//
//       print('offer');
//       print(data);
//       if (emptyPeerConnectionIndex != -1) {
//         print('ttttttttttttttt');
//         final peerConnection = await _createPeerConnection();
//         final stream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true}); // Define stream here
//         _configurePeerConnection(peerConnection, stream,data); // Pass the stream to _configurePeerConnection
//         _peerConnections[emptyPeerConnectionIndex] = peerConnection;
//
//         final offer = RTCSessionDescription(data[1]['sdp'], data[1]['type']);
//         await peerConnection.setRemoteDescription(offer);
//
//         final answer = await peerConnection.createAnswer();
//         await peerConnection.setLocalDescription(answer);
//
//         // Send the answer to the remote peer via signaling server
//         socket.emit("answer", {
//           'sdp': answer.sdp,
//           'type': answer.type,
//         });
//
//         setState(() {});
//       }
//     });
//
//
//     // Handle incoming answer from the remote peer
//     socket.on("answer", (data) {
//       final peerConnectionIndex = _peerConnections.indexWhere(
//               (pc) => pc == null || pc.signalingState == RTCSignalingState.RTCSignalingStateClosed);
//
//       print('answer');
//       print(data);
//
//       if (peerConnectionIndex != -1) {
//         print("yyyyyyyyyyyyyy");
//         final answer = RTCSessionDescription(data[1]['sdp'], data[1]['type']);
//         _peerConnections[peerConnectionIndex]!.setRemoteDescription(answer);
//       }
//     });
//
//     // Handle incoming ICE candidate from the remote peer
//     socket.on("candidate", (data) {
//       final peerConnection = _peerConnections.firstWhere(
//           (pc) =>
//               pc != null &&
//               pc.signalingState != RTCSignalingState.RTCSignalingStateClosed,
//           orElse: () => null);
//
//       if (peerConnection != null) {
//         final candidate = RTCIceCandidate(
//             data[1]['candidate'], data[1]['sdpMid'], data[1]['sdpMLineIndex']);
//         peerConnection.addCandidate(candidate);
//       }
//     });
//
//     // Handle peer disconnection
//     socket.on("disconnectPeer", (data) {
//       final peerConnection = _peerConnections.firstWhere(
//           (pc) =>
//               pc != null &&
//               pc.signalingState != RTCSignalingState.RTCSignalingStateClosed,
//           orElse: () => null);
//
//       if (peerConnection != null) {
//         peerConnection.close();
//       }
//
//       final index = _peerConnections.indexWhere(
//           (pc) =>
//               pc != null &&
//               pc.signalingState != RTCSignalingState.RTCSignalingStateClosed,
//           );
//
//       if (index != -1) {
//         _removePeer(index);
//         setState(() {});
//       }
//     });
//
//     // Rest of the code...
//   }
//
//   void _removePeer(int index) {
//     _peerConnections[index]?.close();
//     _peerConnections[index] = null;
//     _rendererList[index]?.srcObject = null;
//   }
//
//   _initBroadcast() async {
//     final stream = await navigator.mediaDevices
//         .getUserMedia({'video': true, 'audio': true});
//     _localRenderer.srcObject = stream;
//
//     final peerConnection = await _createPeerConnection();
//     _configurePeerConnection(peerConnection, stream, null);
//     _peerConnections.add(peerConnection);
//
//     socket.emit("broadcaster"); // Notify the server that this is a broadcaster
//
//     setState(() {});
//   }
//
//   Future<RTCPeerConnection> _createPeerConnection() async {
//     final Map<String, dynamic> config = {
//       'iceServers': [
//         {
//           "urls": "stun:stun.l.google.com:19302",
//         },
//       ],
//     };
//     final peerConnection = await createPeerConnection(config, {});
//
//     // Configure peer connection
//     peerConnection.onIceConnectionState = (state) {
//       // Handle ICE connection state changes
//       // ...
//     };
//
//     peerConnection.onDataChannel = (channel) {
//       // Handle data channel events if needed
//       // ...
//     };
//
//     // Add video and audio tracks to the peer connection
//     final stream = await navigator.mediaDevices.getUserMedia({
//       'video': true,
//       'audio': true,
//     });
//
//     // Add video track
//     final videoTrack = stream.getVideoTracks().first;
//     peerConnection.addTrack(videoTrack, stream);
//
//     // Add audio track
//     final audioTrack = stream.getAudioTracks().first;
//     peerConnection.addTrack(audioTrack, stream);
//
//     return peerConnection;
//   }
//
//   void _configurePeerConnection(
//       RTCPeerConnection peerConnection, MediaStream stream, data) {
//     // Set up event handlers for the peer connection
//     peerConnection.onIceCandidate = (event) {
//       // Handle ICE candidate events
//       // ...
//     };
//
//     peerConnection.onIceConnectionState = (state) {
//       // Handle ICE connection state changes
//       // ...
//       print('stateeeee');
//       print(state);
//     };
//
//     peerConnection.onAddStream = (mediaStream) {
//       // Handle incoming media stream
//       // ...
//     };
//
//     // Create and set local description
//     peerConnection.createOffer().then((sdp) {
//       // Set local description with the offer
//       return peerConnection.setLocalDescription(sdp);
//     }).then((_) async {
//       // Send the offer to the remote peer via signaling server
//       // ...
//       print('ddddddddddddddddddd');
//       var x = await peerConnection.getLocalDescription();
//       socket.emit("offer", [data, x!.toMap()]);
//     }).catchError((error) {
//       // Handle any errors that occur during offer creation
//       // ...
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     socket.close();
//     _localRenderer.dispose();
//     for (var renderer in _rendererList) {
//       renderer!.dispose();
//     }
//     _peerConnections.forEach((peerConnection) {
//       peerConnection!.close();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Broadcast and Watch'),
//       ),
//       body: Center(
//         child: GridView.builder(
//           itemCount: _rendererList.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
//           itemBuilder: (BuildContext context, int index) {
//             return RTCVideoView(
//               _rendererList[index]!,
//               objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// //
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BroadcastWatcherScreen(),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final IO.Socket socket =
//   IO.io('http://10.0.2.2:3000', <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': false,
//   });
//
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//
//   bool _isBroadcaster = false;
//   bool _isViewer = false;
//   bool _isConnected = true;
//   String _broadcasterId = '';
//   late RTCPeerConnection _peerConnection;
//
//   @override
//   void initState() {
//     super.initState();
//     initRenderers();
//     socket.connect();
//     socket.onConnect((_) {
//       print('Connected to server');
//       setState(() {
//         _isConnected = true;
//       });
//     });
//
//     socket.on('broadcaster-ready', (_) {
//       print('broadcaster-ready');
//       setState(() {
//         _isBroadcaster = true;
//       });
//     });
//
//     socket.on('viewer-ready', (_) {
//       setState(() {
//         _isViewer = true;
//       });
//     });
//
//     socket.on('viewer-joined', (data) {
//       print('Viewer joined. Viewer count: ${data['viewerCount']}');
//     });
//
//     socket.on('viewer-left', (data) {
//       print('Viewer left. Viewer count: ${data['viewerCount']}');
//     });
//
//     socket.on('broadcaster-not-found', (_) {
//       print('Broadcaster not found.');
//     });
//
//     socket.on('broadcaster-disconnected', (_) {
//       print('Broadcaster disconnected.');
//     });
//
//     socket.on('offer', (data) async {
//       // Handle offer and create answer
//       final Map<String, dynamic> offerData = data['offer'];
//       final RTCSessionDescription offer = RTCSessionDescription(
//         offerData['sdp'],
//         offerData['type'],
//       );
//
//       _peerConnection = await createPeerConnection({'iceServers': <dynamic>[]}, {});
//
//       try {
//         await _peerConnection.setRemoteDescription(offer);
//
//         final RTCSessionDescription answer = await _peerConnection.createAnswer({});
//         await _peerConnection.setLocalDescription(answer);
//
//         socket.emit('answer', {
//           'socketId': data['socketId'],
//           'answer': {
//             'type': answer.type,
//             'sdp': answer.sdp,
//           },
//         });
//       } catch (e) {
//         print('Error handling offer: $e');
//       }
//     });
//
//     socket.on('answer', (data) async {
//       // Handle answer
//       final Map<String, dynamic> answerData = data['answer'];
//       final RTCSessionDescription answer = RTCSessionDescription(
//         answerData['sdp'],
//         answerData['type'],
//       );
//
//       try {
//         await _peerConnection.setRemoteDescription(answer);
//       } catch (e) {
//         print('Error handling answer: $e');
//       }
//     });
//
//     socket.on('ice-candidate', (data) async {
//       // Handle ICE candidate
//       final Map<String, dynamic> iceCandidateData = data['iceCandidate'];
//       final RTCIceCandidate iceCandidate = RTCIceCandidate(
//         iceCandidateData['candidate'],
//         iceCandidateData['sdpMid'],
//         iceCandidateData['sdpMLineIndex'],
//       );
//
//       try {
//         if (_peerConnection != null) {
//           await _peerConnection.addCandidate(iceCandidate);
//         }
//       } catch (e) {
//         print('Error handling ICE candidate: $e');
//       }
//     });
//   }
//
//   Future<void> initRenderers() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }
//
//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _peerConnection.close();
//     socket.disconnect();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WebRTC Flutter Client'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // _isConnected
//             //     ? Text(_isBroadcaster
//             //     ? 'You are the broadcaster.'
//             //     : (_isViewer ? 'You are a viewer.' : 'Connecting...'))
//             //     : CircularProgressIndicator(),
//             if (_isConnected)
//               ElevatedButton(
//                 onPressed: () {
//                   socket.emit('new-broadcaster');
//                 },
//                 child: Text('Become Broadcaster'),
//               ),
//              if (_isConnected)
//               ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text('Enter Broadcaster ID'),
//                         content: TextField(
//                           onChanged: (value) {
//                             setState(() {
//                               _broadcasterId = value;
//                             });
//                           },
//                         ),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               socket.emit('new-viewer', _broadcasterId);
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Join as Viewer'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Join as Viewer'),
//               ),
//             Container(
//               width: 200,
//               height: 150,
//               child: RTCVideoView(_localRenderer),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 200,
//               height: 150,
//               child: RTCVideoView(_remoteRenderer),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
