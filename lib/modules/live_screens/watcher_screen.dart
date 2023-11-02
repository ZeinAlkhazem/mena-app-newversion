import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
 

      @override
  void initState() {
    super.initState();
    connectToSocket();
  }
 
 void connectToSocket() {
     // Replace 'https://your_socket_server_url' with the URL of your Socket.IO server.
     final socket = io.io('https://live.menaaii.com:3000', <String, dynamic>{
       'transports': ['websocket'],
       'autoConnect': true,
     });

     socket.connect();

     socket.onConnect((_) {
       print('Connected to the socket server');
     });
     socket.onError((data) {
      print('errorsssss   : ${data}');
     });

     socket.onDisconnect((_) {
       print('Disconnected from the socket server');
     });

     socket.on('message', (data) {
       print('Received message: $data');
     });

     // Add more event listeners and functionality as needed.

     // To send a message to the server, use:
     // socket.emit('eventName', 'message data');
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
