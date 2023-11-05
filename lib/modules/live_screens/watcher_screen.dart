import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'services/signalling.service.dart';
class WatcherScreen extends StatefulWidget {
 const WatcherScreen({super.key});

  @override
  State<WatcherScreen> createState() => _WatcherScreenState();
}

class _WatcherScreenState extends State<WatcherScreen> {
 
final _remoteRenderer = RTCVideoRenderer();
      @override
  void initState() {
    super.initState();
    initRenderers();
    connectToSocket();
  }
  void initRenderers() async {
    await _remoteRenderer.initialize();
  }
 void connectToSocket() {
     // Replace 'https://your_socket_server_url' with the URL of your Socket.IO server.
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
         
          break;
      }
    });
   }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Watcher Screen"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
               Container(
                child: Center(
                  child: Text('Test'),
                ),
               )
              ]),
            ),
           
          ],
        ),
      ),
    );
  }

}
