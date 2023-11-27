// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

class CardCommentsItems extends StatelessWidget {
  const CardCommentsItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showMyAlertDialog(context, "Alert",
                alertDialogContent: const Text(
                    "Do you want to block the user from sending messages to the live?"),
                actions: [
                  DefaultButton(
                    backColor: Colors.white,
                    borderColor: mainBlueColor,
                    width: double.infinity,
                    titleColor: mainBlueColor,
                    text: "Ok",
                    onClick: () => Navigator.pop(context),
                  ),
                  heightBox(10.h),
                  DefaultButton(
                    width: double.infinity,
                    text: "Cancel",
                    onClick: () => Navigator.pop(context),
                  ),
                ]);
          },
          child: Row(children: [
            CircleAvatar(
              radius: 18.sp,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.sp,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.sp),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: DefaultImage(
                      backGroundImageUrl:
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      backColor: newLightGreyColor,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            widthBox(10.w),
            Text(
              "Dr.NaKaren A",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ]),
        ),
        heightBox(5.h),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ellentesque maecenas donec duis aliquam. tristique bibendum vitae.",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        heightBox(20.h)
      ],
    );
  }
}
