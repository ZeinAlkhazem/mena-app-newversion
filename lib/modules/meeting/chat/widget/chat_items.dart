import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';

class ChatItems extends StatelessWidget {
  const ChatItems(
      {super.key,
      required this.userName,
      required this.userImage,
      required this.userMessage});

  final String userName;
  final String userImage;
  final String userMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
            child: CircleAvatar(
              radius: 24.sp,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24.sp,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.sp),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: DefaultImage(
                      backGroundImageUrl: userImage,
                      backColor: newLightGreyColor,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ChatBublle(
                  userMessage: userMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatBublle extends StatelessWidget {
  const ChatBublle({super.key, required this.userMessage});
  final String userMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F4F4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Text(
        userMessage,
        style: TextStyle(
          color: const Color(0xFF1A1A1A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
