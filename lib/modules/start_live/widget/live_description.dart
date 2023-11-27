// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import '../../add_people_to_live/widget/add_people_card.dart';
import '../../create_live/widget/radius_20_container.dart';

class LiveDescription extends StatelessWidget {
  const LiveDescription(
      {super.key,
      required this.liveTitle,
      required this.targetDescription,
      required this.goalDescription});

  final String liveTitle;
  final String targetDescription;
  final String goalDescription;

  @override
  Widget build(BuildContext context) {
    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              liveTitle,
              style: TextStyle(
                color: const Color(0xff1a1a1a),
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            heightBox(20.h),
            Text(
              "Target:",
              style: TextStyle(
                color: const Color(0xff1a1a1a),
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            heightBox(5.h),
            Text(
              targetDescription,
              style: TextStyle(
                color: const Color(0xff1a1a1a),
                fontSize: 10.sp,
              ),
            ),
            heightBox(20.h),
            Text(
              "Goal:",
              style: TextStyle(
                color: const Color(0xff1a1a1a),
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            heightBox(5.h),
            Text(
              goalDescription,
              style: TextStyle(
                color: const Color(0xff1a1a1a),
                fontSize: 10.sp,
              ),
            ),
            heightBox(20.h),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            heightBox(20.h),
            Text(
              "Live Streamers:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 0.25.sh,
              child: RawScrollbar(
                thumbColor: mainBlueColor,
                radius: Radius.circular(20.r),
                thickness: 5,
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    itemCount: 5,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return const AddPeopleCard(
                          name: "Dr.NaKaren A",
                          subName: "Specialist",
                          pictureUrl:
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                          isOnline: true,
                          isCoHost: true,
                          isverified: true);
                    }),
              ),
            ),
            DefaultButton(
              text: "Back",
              onClick: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
