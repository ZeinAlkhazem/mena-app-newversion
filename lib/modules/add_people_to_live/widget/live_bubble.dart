import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
class ProfileBubble extends StatelessWidget {
  const ProfileBubble(
      {Key? key,
      required this.isOnline,
      this.radius,
      this.pictureUrl,
      this.onlyView = true,
      this.customRingColor})
      : super(key: key);
  final bool isOnline;
  final double? radius;
  final Color? customRingColor;
  final String? pictureUrl;
  final bool onlyView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onlyView ? null : () {},
      child: CircleAvatar(
        radius: radius != null ? radius! + 1.sp : 30.sp,
        backgroundColor:
            isOnline ? customRingColor ?? mainGreenColor : Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: CircleAvatar(
                radius: radius ?? 30.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: (radius ?? 30.sp) - 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isOnline
                        ? radius == null
                            ? 26.sp
                            : (radius! - (radius! * 0.01))
                        : radius ?? 30.sp),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: DefaultImage(
                        backGroundImageUrl: pictureUrl ?? '',
                        backColor: newLightGreyColor,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: NotificationCounterBubble(isOnline: isOnline),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCounterBubble extends StatelessWidget {
  const NotificationCounterBubble({
    Key? key,
    required this.isOnline,
  }) : super(key: key);
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 15.sp,
            minHeight: 15.sp,
            maxWidth: 15.sp,
            maxHeight: 15.sp,
          ),
          decoration: BoxDecoration(
              color: isOnline ? mainGreenColor : newLightTextGreyColor,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}
