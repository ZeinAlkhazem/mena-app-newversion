import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';

class ItemsParticipants extends StatelessWidget {
  const ItemsParticipants(
      {super.key, required this.userName, required this.userImage});

  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    double iconSize = 40.h;

    double size = 18.sp;

    BoxConstraints? constraints = BoxConstraints(
      maxHeight: iconSize,
      maxWidth: iconSize,
      minHeight: iconSize,
      minWidth: iconSize,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F4F4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
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
          SizedBox(width: 10.w),
          Text(
            userName,
            style: TextStyle(
              color: const Color(0xFF1A1A1A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            isSelected: true,
            constraints: constraints,
            iconSize: size,
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            selectedIcon: Icon(
              Icons.mic_off_outlined,
              size: size,
              color: alertRedColor,
            ),
            icon: Icon(
              Icons.mic_none_outlined,
              size: size,
              color: mainBlueColor,
            ),
          ),
          IconButton(
            constraints: constraints,
            iconSize: size,
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            icon: Icon(
              Icons.videocam_outlined,
              color: mainBlueColor,
              size: size,
            ),
          ),
          IconButton(
            constraints: constraints,
            iconSize: size,
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: size,
              color: mainBlueColor,
            ),
          ),
        ],
      ),
    );
  }
}
