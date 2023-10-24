import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/functions/main_funcs.dart';

class MessengerChatItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback btnClick;

  const MessengerChatItemWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.btnClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,vertical: 10.h
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon,width: 40.w,),
          SizedBox(
            width: 25.w,
          ),
          Text(
            title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: mainStyle(context, 12.sp, isBold: true,color: Colors.black),
          ),
        ],
      ),
    );
  }
}
