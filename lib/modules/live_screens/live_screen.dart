// import 'dart:math';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/network/network_constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class LivePage extends StatefulWidget {
  final String liveID;
  final String liveTitle;
  final String liveGoal;
  final String liveTopic;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.liveTitle,
    required this.liveGoal,
    required this.liveTopic,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  

  @override
  void initState() {
    super.initState();
    logg('asdasdasdasd');
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
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: LiveTitleWidget(text:"test"),
      )
    );
  }
}

class LiveTitleWidget extends StatefulWidget {
  const LiveTitleWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<LiveTitleWidget> createState() => _LiveTitleWidgetState();
}

class _LiveTitleWidgetState extends State<LiveTitleWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      backColor: Colors.white.withOpacity(0.8),
      borderColor: Colors.white.withOpacity(0.7),
      radius: 35.sp,
      width: 0.29.sw,
      childWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.text,
                  style: mainStyle(context, 44.sp),
                  maxLines: isExpanded ? 9 : 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                  // color: Colors.white.withOpacity(0.8),
                  child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_sharp
                      : Icons.keyboard_arrow_down_sharp,
                  size: 18.sp,
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}

/// Note that the userID needs to be globally unique,
/// this demo use a random userID for test.
String generateRandUserID = math.Random().nextInt(10000).toString();
