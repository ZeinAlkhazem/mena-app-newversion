import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/functions/main_funcs.dart';
import 'about_dialog.dart';
import 'more_card.dart';

class MoreDialog extends StatelessWidget {
  MoreDialog({super.key});

  final TextStyle? styleText = TextStyle(
      color: const Color(0xFF1A1A1A),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.01,
      height: 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        MoreCard(
          title: "Speaker",
          trailingIcon: "assets/live_icon/Speaker.svg",
          onTap: () {},
        ),
        MoreCard(
          title: "Gallery",
          trailingIcon: "assets/live_icon/Gallery.svg",
          onTap: () {},
        ),
        MoreCard(
          title: "Immersive",
          trailingIcon: "assets/live_icon/Immersive.svg",
          onTap: () {},
        ),
        const Divider(),
        MoreCard(
          title: "About Meeting",
          trailingIcon: "assets/live_icon/About Meeting.svg",
          onTap: () {
            Navigator.of(context).pop();
            showMyAlertDialog(
              context,
              '',
              dismissible: false,
              alertDialogContent: AboutMeetDialog(),
            );
          },
        ),
      ],
    );
  }
}
