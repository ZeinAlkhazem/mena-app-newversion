import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import 'package:mena/core/constants/Colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/messenger_cubit.dart';
import '../widget/archived_button_widget.dart';
import '../widget/chat_user_item_widget.dart';
import '../widget/my_store_widget.dart';

class MessengerChatScreen extends StatefulWidget {
  const MessengerChatScreen({super.key});

  @override
  State<MessengerChatScreen> createState() => _MessengerChatScreenState();
}

class _MessengerChatScreenState extends State<MessengerChatScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    var messengerCubit = MessengerCubit.get(context);
    messengerCubit
      ..fetchMyMessages()
      ..fetchOnlineUsers();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    var messengerCubit = MessengerCubit.get(context);
    messengerCubit
      ..fetchMyMessages()
      ..fetchOnlineUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return

        messengerCubit.myMessagesModel == null
          ? DefaultLoaderGrey()
          : messengerCubit.myMessagesModel!.data.myChats == null
              ? DefaultLoaderGrey()
              : messengerCubit.myMessagesModel!.data.myChats!.isEmpty
                  ?

                  ///
                  ///
                  ///  Empty Messages
                  ///
                  ///
                  Container(
                      height: 0.9.sh,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///
                          /// body of chat
                          ///
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyStoryWidget(count: 1),
                                SizedBox(
                                  height: 100.h,
                                ),
                                SizedBox(
                                  width: 73.w,
                                  height: 73.h,
                                  child: SvgPicture.asset(
                                    "$messengerAssets/icon_circle_plus.svg",
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 22.5.w),
                                  child: Text(
                                    getTranslatedStrings(context)
                                        .messengerEmptyChatText,
                                    textAlign: TextAlign.center,
                                    style: mainStyle(context, 11.sp,
                                        weight: FontWeight.normal,
                                        fontFamily: AppFonts.interFont,
                                        color: AppColors.textGray,
                                        textHeight: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  :

                  ///
                  ///
                  ///
                  ///
                  ///
                  SmartRefresher(
                      enablePullDown: true,
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              MyStoryWidget(count: 10),
                              SizedBox(
                                height: 10.h,
                              ),

                              ///
                              ///  Archive Section
                              ///
                              ArchivedButtonWidget(),
                              SizedBox(
                                height: 10.h,
                              ),

                              ///
                              ///  chats Section
                              ///

                              ListView.separated(
                                shrinkWrap: true,
                                primary: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return ChatUserItemWidget(
                                      index: index,
                                      chatItem: messengerCubit.myMessagesModel!
                                          .data.myChats![index]);
                                },
                                separatorBuilder: (_, i) => heightBox(0.h),
                                itemCount: messengerCubit
                                    .myMessagesModel!.data.myChats!.length,
                              ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
    });
  }
}
