import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WatcherScreen(),
    );
  }
}

class WatcherScreen extends StatefulWidget {
  const WatcherScreen({super.key});

  @override
  State<WatcherScreen> createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late IO.Socket socket;
  RTCPeerConnection? _peerConnection;

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  _initSocket() async {
    await _remoteRenderer.initialize();

    socket = IO.io('http://20.0.0.97:8000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on("connect", (data) {
      socket.emit("watcher");
    });

    socket.on("broadcaster", (data) {
      socket.emit("watcher");
    });
    socket.on("offer", (data) async {

      print('offer');
      print(data);
      _peerConnection = await cpc();
      RTCSessionDescription x =
          RTCSessionDescription(data[1]['sdp'], data[1]["type"]);
      _peerConnection?.setRemoteDescription(x).then((value) async {
        await _peerConnection?.createAnswer().then((sdp) {
          _peerConnection?.setLocalDescription(sdp).then((_) async {
            var x = await _peerConnection?.getLocalDescription();
            socket.emit("answer", [data[0], x!.toMap()]);
          });
        });
      });

      _peerConnection?.onTrack = (event) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      };

      _peerConnection?.onIceCandidate = (event) {
        if (event.candidate != null) {
          socket.emit("candidate", [data[0], event.toMap()]);
        }
      };
    });

    socket.on("candidate", (data) {
      print("candidate");
      print(data);
      if (_peerConnection != null) {
        print('ininininininininininin');
        _peerConnection?.addCandidate(RTCIceCandidate(
            data[1]["candidate"], data[1]["sdpMid"], data[1]["sdpMLineIndex"]));
      }
    });

    socket.on("disconnectPeer", (id) {
      print("disconnectPeer");
      _peerConnection?.close();
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.close();
    _peerConnection?.close();
  }

  Future<RTCPeerConnection> cpc() async {
    final Map<String, dynamic> config = {
      'iceServers': [
        {
          "urls": "stun:stun.l.google.com:19302",
        },
      ],
    };

    final peerConnection = await createPeerConnection(config, {});
    return peerConnection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watcher'),
      ),
      body: Center(
        child: RTCVideoView(
          _remoteRenderer,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class WatcherScreen extends StatefulWidget {
//   const WatcherScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WatcherScreen> createState() => _WatcherScreenState();
// }
//
// class _WatcherScreenState extends State<WatcherScreen> {
//   List<RTCPeerConnection?> _peerConnections = [];
//   List<RTCVideoRenderer> _rendererList = [];
//   late IO.Socket socket;
//
//   @override
//   void initState() {
//     super.initState();
//     _initSocket();
//   }
//
//   _initSocket() async {
//     await _remoteRenderer.initialize();
//
//     socket = IO.io('http://20.0.0.189:8000/56789', {
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });
//
//     socket.on("connect", (data) {
//       socket.emit("watcher");
//     });
//
//     socket.on("broadcaster", (data) {
//       socket.emit("watcher");
//     });
//     socket.on("offer", (data) async {
//       _peerConnections.add(await cpc());
//       RTCSessionDescription offerSdp =
//       RTCSessionDescription(data[1]['sdp'], data[1]["type"]);
//       await _peerConnections.last!.setRemoteDescription(offerSdp);
//       final answerSdp = await _peerConnections.last!.createAnswer();
//       await _peerConnections.last!.setLocalDescription(answerSdp);
//
//       var localSdp = await _peerConnections.last!.getLocalDescription();
//       Map<String, dynamic> answerPayload = {
//         "id": _peerConnections.length - 1,
//         "answer": localSdp!.toMap()
//       };
//       socket.emit("answer", [data[0], answerPayload]);
//
//       _peerConnections.last!.onTrack = (event) {
//         final rendererIndex = _peerConnections.indexOf(_peerConnections.last!);
//         if (rendererIndex != -1) {
//           setState(() {
//             _rendererList[rendererIndex].srcObject = event.streams[0];
//           });
//         }
//       };
//
//       _peerConnections.last!.onIceCandidate = (event) {
//         socket.emit("candidate", [data[0], event.toMap()]);
//       };
//     });
//
//     socket.on("candidate", (data) {
//       if (_peerConnections[data[0]] != null) {
//         _peerConnections[data[0]]!.addCandidate(RTCIceCandidate(
//             data[1]["candidate"], data[1]["sdpMid"], data[1]["sdpMLineIndex"]));
//       }
//     });
//
//     socket.on("disconnectPeer", (id) {
//       _peerConnections[id]!.close();
//       _peerConnections.removeAt(id);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     socket.close();
//     _remoteRenderer.dispose();
//     _peerConnections.forEach((peerConnection) {
//       peerConnection!.close();
//     });
//   }
//
//   Future<RTCPeerConnection> cpc() async {
//     final Map<String, dynamic> config = {
//       'iceServers': [
//         {
//           "urls": "stun:stun.l.google.com:19302",
//         },
//       ],
//     };
//
//     final peerConnection = await createPeerConnection(config, {});
//     return peerConnection;
//   }
//
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Watcher'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             for (var renderer in _rendererList)
//               Container(
//                 height: 200,
//                 child: RTCVideoView(
//                   renderer,
//                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: WatcherScreen(),
//     );
//   }
// }