import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/messenger/cubit/messenger_cubit.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/api_model/my_messages_model.dart';
import '../screens/user_profile_request_page.dart';

class ChatRequestItemWidget extends StatelessWidget {
  final bool showSelected;
  final bool isChecked;
  final ChatItem chatItem;
  final Function(bool?)? checkFunction;
  const ChatRequestItemWidget({
    super.key,
    required this.chatItem,
    required this.showSelected,
    required this.isChecked,
    required this.checkFunction,
  });

  @override
  Widget build(BuildContext context) {
    Color fontColor = Color(0xff979797);
    return Row(
      children: [
        showSelected
            ? Checkbox(
                value:  isChecked,
                activeColor: Color(0xFF2788E8),
                shape: CircleBorder(),
                onChanged:checkFunction)
            : SizedBox(),
        Expanded(
          child: GestureDetector(
            onTap: () {
              logg('on click on chat user');
              navigateTo(
                context,
                UserProfileRequestPage(
                  user:chatItem.user!,
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              // color: Colors.red,
              height: 76.h,
              padding: EdgeInsets.only(left: 12.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 53.w,
                    height: 53.w,
                    child: ProfileBubble(
                      isOnline: false,
                      pictureUrl: chatItem.user?.personalPicture,
                      radius: 53.r,
                    ),
                  ),
                  widthBox(7.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // color: Colors.red,
                              constraints: BoxConstraints(maxWidth: 200.w),
                              child: Text(
                                getFormattedUserName(chatItem.user!),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: mainStyle(context, 14.sp, isBold: true),
                              ),
                            ),
                            (chatItem.user!.verified == '1')
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
///
                        /// last message with user
                        ///
                        Row(
                          children: [
                            chatItem.lastMessageFrom != chatItem.user!.fullName
                                ? SizedBox(
                                    height: 19.w,
                                    width: 19.w,
                                    child: int.parse(chatItem.receiveType!) == 0
                                        ? SvgPicture.asset(
                                            "$messengerAssets/chat/icon_chat_check_send.svg",
                                            color: Colors.grey,
                                          )
                                        : int.parse(chatItem.receiveType!) == 1
                                            ? SvgPicture.asset(
                                                "$messengerAssets/chat/icon_chat_double_check_unread.svg",
                                                color: Colors.grey,
                                              )
                                            : SvgPicture.asset(
                                                "$messengerAssets/chat/icon_chat_double_check_read.svg",
                                              ),
                                  )
                                : SizedBox(),
                            SizedBox(width: 2.5.w),
                            checkMessageType(
                                messageType: chatItem.messageType ?? "text"),
                            // checkMessageType(
                            //     messageType: index == 1
                            //         ? "image"
                            //         : chatItem.messageType!),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: Text(
                                chatItem.lastMessage ?? "",
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: mainStyle(context, 11.sp,
                                    fontFamily: AppFonts.interFont,
                                    weight: FontWeight.normal,
                                    color: fontColor),
                              ),
                            ),
                          ],
                        ),
                        ///
                        /// follower number
                        ///
                        Text(
                          "2k followers ",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 11.sp,
                              fontFamily: AppFonts.interFont,
                              weight: FontWeight.normal,
                              color: fontColor),
                        ),
                      ],
                    ),
                  ),
                  widthBox(5.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 85.w,
                        child: Text(
                          getChatTime(chatTime: chatItem.createdAt!),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 10.sp,
                              fontFamily: AppFonts.interFont,
                              weight: FontWeight.w400,
                              color: fontColor),
                        ),
                      ),
                      chatItem.numOfUnread != 0
                          ? Container(
                              height: 19.w,
                              width: 19.w,
                              margin: EdgeInsets.only(
                                  top: 5.h, left: 10.w, right: 10.w),
                              decoration: BoxDecoration(
                                  color: Color(0xFF2788E8),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                child: Text(
                                  chatItem.numOfUnread.toString(),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: mainStyle(context, 12.sp,
                                      fontFamily: AppFonts.interFont,
                                      weight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //
          //   },
          //   child: Container(
          //     color: Colors.transparent,
          //     child: Row(
          //       children: [
          //         ProfileBubble(
          //           isOnline: false,
          //           pictureUrl: user.personalPicture,
          //         ),
          //         widthBox(7.w),
          //         Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Container(
          //                     // color: Colors.red,
          //                     constraints: BoxConstraints(maxWidth: 200.w),
          //                     child: Text(
          //                       getFormattedUserName(user),
          //                       maxLines: 1,
          //                       softWrap: true,
          //                       overflow: TextOverflow.ellipsis,
          //                       style: mainStyle(context, 14.sp,
          //                           color: Color(0xFF19191A),
          //                           fontFamily: AppFonts.interFont,
          //                           weight: FontWeight.w500),
          //                     ),
          //                   ),
          //                   (user.verified == '1')
          //                       ? Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 4.0),
          //                           child: Icon(
          //                             Icons.verified,
          //                             color: Color(0xff01BC62),
          //                             size: 16.sp,
          //                           ),
          //                         )
          //                       : SizedBox()
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: 2.h,
          //               ),
          //
          //               /// last message with user
          //               Text(
          //                 "last message with this user",
          //                 maxLines: 1,
          //                 softWrap: true,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: mainStyle(context, 10.sp,
          //                     fontFamily: AppFonts.openSansFont,
          //                     weight: FontWeight.w400,
          //                     color: AppColors.grayDarkColor),
          //               ),
          //               SizedBox(
          //                 height: 2.h,
          //               ),
          //
          //               /// followers number
          //               Text(
          //                 "120 " + getTranslatedStrings(context).follower,
          //                 maxLines: 1,
          //                 softWrap: true,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: mainStyle(context, 10.sp,
          //                     fontFamily: AppFonts.openSansFont,
          //                     weight: FontWeight.w400,
          //                     color: AppColors.lineGray),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           width: 60.w,
          //           child: Text(
          //             "10/10/2023",
          //             maxLines: 1,
          //             softWrap: true,
          //             overflow: TextOverflow.ellipsis,
          //             style: mainStyle(context, 8.sp,
          //                 fontFamily: AppFonts.openSansFont,
          //                 weight: FontWeight.w400,
          //                 color: AppColors.lineGray),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}
