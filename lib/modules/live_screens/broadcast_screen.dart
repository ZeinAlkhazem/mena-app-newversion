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
      }).then((_) async {
        var x = await _peerConnection.getLocalDescription();
        Map<String, dynamic> payload = {"id": data, "offer": x!.toMap()};
        socket.emit("offer", [data, x.toMap()]);
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
