import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'add_default_button.dart';

class AddPeopleCard extends StatelessWidget {
  const AddPeopleCard(
      {super.key,
      required this.name,
      required this.subName,
      required this.pictureUrl,
      required this.isOnline,
      required this.isCoHost,
      required this.isverified});

  final String name;
  final String subName;
  final String pictureUrl;
  final bool isOnline;
  final bool isCoHost;
  final bool isverified;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileBubble(
              isOnline: isOnline,
              pictureUrl: pictureUrl,
            ),
            widthBox(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  subName,
                  style: TextStyle(
                    color: const Color(0xff818c99),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            widthBox(10.w),
            isverified
                ? Icon(
                    Icons.verified,
                    color: mainGreenColor,
                    size: 18.sp,
                  )
                : const SizedBox(),
            const Spacer(),
            AddDefaultButton(
              isCoHost: isCoHost,
              titleColor: isCoHost ? alertRedColor : mainBlueColor,
              onClick: () {},
            )
          ]),
    );
  }
}
