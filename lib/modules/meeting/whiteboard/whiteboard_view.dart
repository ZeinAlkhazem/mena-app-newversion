import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/constants.dart';
import '../cubit/meeting_cubit.dart';

class WhiteboardView extends StatelessWidget {
  const WhiteboardView({super.key});

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            WebViewWidget(controller: meetingCubit.webViewController),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              height: 60.h,
              child: TextButton.icon(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(120.r),
                      ),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(mainBlueColor),
                ),
                onPressed: () {
                  meetingCubit.emitInitial();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 15.sp,
                  color: Colors.white,
                ),
                label: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
