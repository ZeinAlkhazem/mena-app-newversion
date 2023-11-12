import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class HeaderLiveBubble extends StatelessWidget {
   HeaderLiveBubble({
    Key? key,
    this.radius,
    this.pictureUrl,
  }) : super(key: key);
  final double? radius;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius != null ? radius! + 1.sp : 30.sp,
      backgroundColor: alertRedColor,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: radius == null ? 28.sp : (radius! - (radius! * 0.001)),
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius:
                    (radius == null ? 28.sp : (radius! - (radius! * 0.001))) -
                        1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      radius == null ? 28.sp : (radius! - (radius! * 0.01))),
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
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              width: 30.w,
              height: 15.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xffd51925),
                  width: 0.50,
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 2.h,
              ),
              child: Text(
                "LIVE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xffd51925),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.03,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
