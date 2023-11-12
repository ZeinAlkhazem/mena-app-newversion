import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/home_section_model.dart';
import '../screens/user_profile_request_page.dart';

class ChatRequestItemWidget extends StatelessWidget {
  final User user;
  final bool showSelected;
  const ChatRequestItemWidget({super.key, required this.user, required this.showSelected,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        showSelected?
        Checkbox(
            value: false,
            activeColor: Colors.green,
            onChanged: (bool? newValue) {
              // checkBoxValue = newValue;
            }):SizedBox(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              logg('on click on chat user');
              navigateTo(
                context,
                UserProfileRequestPage(
                  user: user,
                ),
              );
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Icon(
                                      Icons.verified,
                                      color: Color(0xff01BC62),
                                      size: 16.sp,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        /// last message with user
                        Text(
                          "last message with this user",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 10.sp,
                              fontFamily: AppFonts.openSansFont,
                              weight: FontWeight.w400,
                              color: AppColors.grayDarkColor),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        /// followers number
                        Text(
                          "120 " + getTranslatedStrings(context).follower,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 10.sp,
                              fontFamily: AppFonts.openSansFont,
                              weight: FontWeight.w400,
                              color: AppColors.lineGray),
                        ),
                      ],
                    ),
                  ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
