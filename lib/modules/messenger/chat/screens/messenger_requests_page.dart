import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/my_messages_model.dart';

import '../../../../models/api_model/home_section_model.dart';
import '../../messenger_constant.dart';
import '../cubit/messenger_cubit.dart';
import '../dialogs/delete_bottom_sheet_dialog.dart';
import '../widget/back_button_widget.dart';
import '../widget/chat_request_item_widget.dart';
import '../widget/empty_new_message_widget.dart';
import '../widget/icon_button_widget.dart';

class MessengerRequestPage extends StatefulWidget {
  const MessengerRequestPage({super.key});

  @override
  State<MessengerRequestPage> createState() => _MessengerRequestPageState();
}

class _MessengerRequestPageState extends State<MessengerRequestPage> {
  @override
  Widget build(BuildContext context) {
    bool isHaveData = true;

    List<ChatItem> userList = [
      ChatItem(
        id: 0,
        numOfUnread: 1,
        lastMessage: "test message",
        messageType: "text",
        receiveType: "1",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
      ChatItem(
        id: 1,
        numOfUnread: 3,
        lastMessage: "test message",
        messageType: "text",
        receiveType: "1",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
      ChatItem(
        id: 2,
        numOfUnread: 0,
        lastMessage: "test message",
        messageType: "file",
        receiveType: "1",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
      ChatItem(
        id: 3,
        numOfUnread: 0,
        lastMessage: "test message",
        messageType: "video",
        receiveType: "3",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
      ChatItem(
        id: 4,
        numOfUnread: 0,
        lastMessage: "test message",
        messageType: "voice",
        receiveType: "2",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
      ChatItem(
        id: 5,
        numOfUnread: 0,
        lastMessage: "test message",
        messageType: "text",
        receiveType: "1",
        lastMessageFrom: '',
        createdAt: DateTime.now(),
        user: User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg",
        ),
      ),
    ];

    return BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {},
        builder: (context, state) {
          var messengerCubit = MessengerCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              centerTitle: false,
              leading: BackButtonWidget(),
              titleSpacing: 0,
              title: Text(
                messengerCubit.requestedMessages.isNotEmpty?
                  "${messengerCubit.requestedMessages.length} Selected"
                    :
                  getTranslatedStrings(context).messageRequests,
                style: MessengerConstant().titleStyle(context),
              ),
              actions: [
                IconButtonWidget(
                  iconUrl: "$messengerAssets/icon_multi_selection.svg",
                  btnClick: () {
                    MessengerCubit.get(context).changeShowSelectedState();
                  },
                  iconWidth: 30.w,
                  iconHeight: 30.h,
                ),
              ],
            ),
            body: !isHaveData
                ? EmptyNewMessageWidget(
                    content: getTranslatedStrings(context).requestEmptyText)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 0.w),
                          decoration: BoxDecoration(
                              color: AppColors.lineGray.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(0.r)),
                          child: SizedBox(
                            width: 387.w,
                            child: Text(
                              "Initiate a chat to gain more info about the sender's message.\nThey will not know that you've seen it until you accept their message",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: Color(0xFF999B9D),
                                fontSize: 10.sp,
                                fontFamily: AppFonts.interFont,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                          // Text(
                          //   "Initiate a chat to gain more info about the sender's message.\nThey will not know that you've seen it until you accept their message",
                          //   maxLines: 2,
                          //   softWrap: true,
                          //   overflow: TextOverflow.ellipsis,
                          //   textAlign: TextAlign.center,
                          //   style: mainStyle(context, 9.sp,
                          //       fontFamily: AppFonts.interFont,
                          //       weight: FontWeight.w400,
                          //       color: Color(0xff999B9D)),
                          // ),
                          ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: ListView.separated(
                            shrinkWrap: true,
                            primary: true,
                            padding: EdgeInsets.zero,
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return ChatRequestItemWidget(
                                showSelected: messengerCubit.showSelected,
                                chatItem: userList[index],
                                isChecked: messengerCubit
                                    .checkMessage(userList[index]),
                                checkFunction: (bool? newValue) {
                                  messengerCubit.addMessageToList(
                                      newValue!, userList[index]);
                                },
                              );
                            },
                            separatorBuilder: (_, i) => heightBox(5.h),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 125.h,
                      ),
                    ],
                  ),
            bottomSheet: isHaveData
                ? SizedBox(
                    height: 125.h,
                    child: Column(
                      children: [
                        Center(
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                getTranslatedStrings(context)
                                    .messengerRequestedShowMore,
                                style: TextStyle(
                                  color: Color(0xFF2788E8),
                                  fontSize: 15.sp,
                                  fontFamily: AppFonts.interFont,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: 0.23,
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: DefaultButton(
                            onClick: () {
                              deleteBottomSheetDialog(
                                  context: context,
                                  btnDelete: () {
                                    Navigator.pop(context);
                                  });
                              // blockUserBottomSheetWidget(context);
                            },
                            text: getTranslatedStrings(context)
                                .messengerDeleteAll,
                            width: 281.w,
                            height: 38.h,
                            radius: 10.r,
                            backColor: AppColors.lineGray.withOpacity(0.2),
                            borderColor: Colors.white,
                            customChild: Center(
                              child: Text(
                                getTranslatedStrings(context)
                                    .messengerDeleteAll,
                                style: mainStyle(context, 12.sp,
                                    color: AppColors.textRed,
                                    fontFamily: AppFonts.openSansFont,
                                    weight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          );
        });
  }
}
