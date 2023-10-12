import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/meeting/participants/widget/items_participants.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../chat/widget/divider_with_padding.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.9.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(
            30.r,
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 50.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Participants",
                  style: mainStyle(context, 16.sp, isBold: true),
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
          ),
          const DividerWithPadding(),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return const ItemsParticipants(
                      userName: "jon",
                      userImage:
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                    );
                  }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DefaultButton(
                    radius: 60.r,
                    borderColor: mainBlueColor,
                    titleColor: Colors.white,
                    backColor: mainBlueColor,
                    text: "+ Add Participants",
                    onClick: () {},
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: DefaultButton(
                    customChild: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/linked_outline.svg",
                            width: 15.w,
                          ),
                          Text(
                            "Copy Invite Link",
                            textAlign: TextAlign.center,
                            style: mainStyle(
                                context,
                                isBold: true,
                                14.sp,
                                color: mainBlueColor),
                          ),
                        ]),
                    radius: 60.r,
                    text: "Copy Invite Link",
                    onClick: () {},
                    backColor: Colors.white,
                    borderColor: mainBlueColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
