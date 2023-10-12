import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/meeting/whiteboard/whiteboard_view.dart';

import '../widget/appbar_for_meeting.dart';

class WhiteboardPage extends StatefulWidget {
  const WhiteboardPage({super.key});

  @override
  State<WhiteboardPage> createState() => _WhiteboardPageState();
}

class _WhiteboardPageState extends State<WhiteboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0.h),
        child: defaultAppBarForMeeting(context),
      ),
      body: const WhiteboardView(),
    );
  }
}
