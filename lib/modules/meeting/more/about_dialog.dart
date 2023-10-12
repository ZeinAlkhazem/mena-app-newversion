import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/functions/main_funcs.dart';

class AboutMeetDialog extends StatelessWidget {
  AboutMeetDialog({super.key});

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'About Meeting',
              textAlign: TextAlign.center,
              style: mainStyle(context, 16.sp,
                  color: Colors.black,
                  isBold: true,
                  weight: FontWeight.w600,
                  textHeight: 2),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
        RowRomAbout(
            name: "Meeting ID", subName: "852 852 8520", isCoped: false),
        RowRomAbout(name: "Host", subName: "Host Name", isCoped: false),
        RowRomAbout(name: "Passcode", subName: "kjuw654", isCoped: false),
        RowRomAbout(
            name: "Invitation link",
            subName: "https://kasik.mena.com/d/56449646546",
            isCoped: true),
        RowRomAbout(name: "Participant", subName: "987546", isCoped: false),
        RowRomAbout(name: "Encryption", subName: "Enabled", isCoped: false),
      ],
    );
  }
}

class RowRomAbout extends StatelessWidget {
  RowRomAbout(
      {super.key,
      required this.name,
      required this.subName,
      required this.isCoped});
  final String name;
  final String subName;
  final bool isCoped;

  final TextStyle? style = TextStyle(
    color: const Color(0xFF1A1A1A),
    fontSize: 14.sp,
    fontFamily: 'Visby CF',
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0.01,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: style),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Text(subName, style: style),
          ),
          if (isCoped)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Clipboard.setData(ClipboardData(text: subName)).then(
                      (value) => viewMySnackBar(context,
                          "The code $subName has been copied", "", () {},
                          customColor: Colors.amber));
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.blue,
                )),
        ],
      ),
    );
  }
}
