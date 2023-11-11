

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/home_section_model.dart';
import '../chat_layout.dart';

class ChatUserItemWidget extends StatelessWidget {
  final User user;
  final String type;

  const ChatUserItemWidget({super.key, required this.user, this.type = "send"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logg('on click on chat user');
        navigateTo(
            context,
            ChatLayout(
              user: user,
            ));
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            ProfileBubble(
              isOnline: false,
              pictureUrl: user.personalPicture,
            ),
            widthBox(7.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        constraints: BoxConstraints(maxWidth: 200.w),
                        child: Text(
                          getFormattedUserName(user),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 12, isBold: true),
                        ),
                      ),
                      (user.verified == '1')
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.verified,
                                color: Color(0xff01BC62),
                                size: 16.sp,
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                  // Text(
                  //   user.fullName ?? '--',
                  //   style: mainStyle(context, 14, color: mainBlueColor),
                  // ),
                  // if(user.roleName)

                  /// if provider
                  // if (MainCubit.get(context).isUserProvider())
                  //   Column(
                  //     children: [
                  //       heightBox(5.h),
                  //       Text(
                  //         user.speciality ?? (user.specialities == null || user.specialities!.isEmpty)
                  //             ? '-'
                  //             : user.specialities![0].name ?? '',
                  //         style: mainStyle(context, 12.sp, color: mainBlueColor, weight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),

                  /// last message with user
                  Row(
                    children: [
                      Icon(
                        type == "send"
                            ? Icons.check
                            : type == "receive"
                                ? Icons.done_all
                                : Icons.done_all,
                        color: type == "send"
                            ? Colors.grey
                            : type == "receive"
                                ? Colors.grey
                                : AppColors.lineBlue,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          "last message with this user",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 10.sp,
                              fontFamily: AppFonts.openSansFont,
                              weight: FontWeight.w400,
                              color: AppColors.grayDarkColor),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          "10/10/2023",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 8.sp,
                              fontFamily: AppFonts.openSansFont,
                              weight: FontWeight.w400,
                              color: AppColors.lineGray),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
