import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/messenger/cubit/messenger_cubit.dart';
import 'package:mena/modules/messenger/users_to_start_chat.dart';

import '../../core/constants/constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../models/api_model/home_section_model.dart';
import '../../models/api_model/my_messages_model.dart';
import '../../models/api_model/online_users.dart';
import 'chat_layout.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'widget/messenger_empty_widget.dart';

class MessengerLayout extends StatefulWidget {
  const MessengerLayout({Key? key}) : super(key: key);

  @override
  State<MessengerLayout> createState() => _MessengerLayoutState();
}

class _MessengerLayoutState extends State<MessengerLayout> {
  IO.Socket? socket;

  @override
  void initState() {
    // TODO: implement initState
    var messengerCubit = MessengerCubit.get(context);

    messengerCubit
      ..fetchMyMessages()
      ..fetchOnlineUsers();

    socket = MainCubit.get(context).socket;
    socket?.on('new-message', (data) {
      logg('new message socket: $data');
      messengerCubit
        ..fetchMyMessages()
        ..fetchOnlineUsers();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket?.off('new-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: Responsive.isMobile(context)
            ? kBottomNavigationBarHeight * 0
            : kBottomNavigationBarHeight * 0,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<MessengerCubit, MessengerState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return  messengerCubit.myMessagesModel == null
                ? DefaultLoaderGrey()
                : messengerCubit.myMessagesModel!.data.myChats == null
                    ? DefaultLoaderGrey()
                    : messengerCubit.myMessagesModel!.data.myChats!.isEmpty
                        ? MessengerEmptyWidget()
                        : SafeArea(
                            child: Container(
                              color: newLightGreyColor,
                              child: Column(
                                children: [
                                  ///
                                  ///
                                  /// message header
                                  ///
                                  ///
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(defaultRadiusVal),
                                        bottomLeft:
                                            Radius.circular(defaultRadiusVal),
                                      ),
                                      // border: Border.all(width: 3,color: Colors.green,style: BorderStyle.solid)
                                    ),
                                    child: Column(
                                      children: [
                                        NewMessengerHeader(),
                                        heightBox(10.h),
                                        messengerCubit.onlineUsersModel == null
                                            ? DefaultLoaderGrey()
                                            : messengerCubit.onlineUsersModel!
                                                    .data!.onlineUsers!.isEmpty
                                                ? Text('No one online')
                                                : SizedBox(
                                                    height: 66.h,
                                                    child: ListView.separated(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding: EdgeInsets.symmetric(
                                                          vertical:
                                                              defaultHorizontalPadding /
                                                                  24,
                                                          horizontal:
                                                              defaultHorizontalPadding),
                                                      itemBuilder:
                                                          (context, index) {
                                                        List<OnlineUser?>?
                                                            onlineUsers =
                                                            messengerCubit
                                                                .onlineUsersModel!
                                                                .data!
                                                                .onlineUsers;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            navigateTo(
                                                                context,
                                                                ChatLayout(
                                                                  user: onlineUsers![
                                                                          index]!
                                                                      .user,
                                                                ));
                                                            logg('chat layout');
                                                          },
                                                          child:
                                                              ProfileBubbleWithName(
                                                            isOnline: true,
                                                            radius: 22.sp,
                                                            pictureUrl:
                                                                onlineUsers![
                                                                        index]!
                                                                    .personalPicture!,
                                                            name:
                                                                '${onlineUsers[index]!.abbreviation ?? ''}${onlineUsers[index]!.fullName!.split(' ')[0]}',
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (_, i) => SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      itemCount: messengerCubit
                                                          .onlineUsersModel!
                                                          .data!
                                                          .onlineUsers!
                                                          .length,
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  ),

                                  ///
                                  ///
                                  /// message header
                                  ///
                                  ///
                                  heightBox(7.h),
                                  state is GettingMyMessagesData
                                      ? LinearProgressIndicator(
                                          minHeight: 1.h,
                                        )
                                      : heightBox(1.h),
                                  heightBox(4.h),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: defaultHorizontalPadding),
                                              //   child: Text(
                                              //     'Messages',
                                              //     style: mainStyle(context, 14),
                                              //   ),
                                              // ),
                                              // heightBox(5.h),

                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return MsgSummaryItem(
                                                      chat: messengerCubit
                                                          .myMessagesModel!
                                                          .data
                                                          .myChats![index],
                                                      user: messengerCubit
                                                          .myMessagesModel!
                                                          .data
                                                          .myChats![index]
                                                          .user,
                                                    );
                                                  },
                                                  separatorBuilder: (_, i) =>
                                                      heightBox(5.h),
                                                  itemCount: messengerCubit
                                                      .myMessagesModel!
                                                      .data
                                                      .myChats!
                                                      .length,
                                                ),
                                              ),
                                              heightBox(15.h),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     // borderRadius:
                                        //     // BorderRadius
                                        //     //     .only(
                                        //     //   topLeft: Radius
                                        //     //       .circular(
                                        //     //       12.sp),
                                        //     //   // bottomLeft: Radius.circular(10.sp),
                                        //     // ),
                                        //
                                        //     // border: Border.all(
                                        //     //     width: 1.0,
                                        //     //     color:
                                        //     //         .withOpacity(
                                        //     //         0.4)),
                                        //   ),
                                        //   child: Padding(
                                        //     padding: EdgeInsets.only(
                                        //         bottom:
                                        //             defaultHorizontalPadding * 1.0),
                                        //     child: Column(
                                        //       children: [
                                        //         Expanded(
                                        //           child: Stack(
                                        //             children: [
                                        //               SizedBox(
                                        //                 // height:0.75.sh,
                                        //                 child: Padding(
                                        //                   padding: EdgeInsets.only(
                                        //                       bottom: 0.22.sw * 0.5),
                                        //                   child: Container(
                                        //                       width: 78.w,
                                        //                       decoration:
                                        //                           BoxDecoration(
                                        //                         border: Border(
                                        //                           left: getTranslatedStrings(
                                        //                                           context)
                                        //                                       .currentLanguageDirection ==
                                        //                                   'ltr'
                                        //                               ? BorderSide(
                                        //                                   width: 1.0,
                                        //                                   color: softGreyColor
                                        //                                       .withOpacity(
                                        //                                           0.4))
                                        //                               : BorderSide
                                        //                                   .none,
                                        //                           right: getTranslatedStrings(
                                        //                                           context)
                                        //                                       .currentLanguageDirection ==
                                        //                                   'rtl'
                                        //                               ? BorderSide(
                                        //                                   width: 1.0,
                                        //                                   color: softGreyColor
                                        //                                       .withOpacity(
                                        //                                           0.4))
                                        //                               : BorderSide
                                        //                                   .none,
                                        //                           // top: BorderSide(
                                        //                           //     width: 1.0,
                                        //                           //     color: softGreyColor.withOpacity(0.4)),
                                        //                         ),
                                        //                       ),
                                        //                       child: messengerCubit
                                        //                                   .onlineUsersModel ==
                                        //                               null
                                        //                           ? DefaultLoaderGrey()
                                        //                           : messengerCubit
                                        //                                   .onlineUsersModel!
                                        //                                   .data!
                                        //                                   .onlineUsers!
                                        //                                   .isEmpty
                                        //                               ? Text(
                                        //                                   'No one online')
                                        //                               : Column(
                                        //                                   children: [
                                        //                                     Padding(
                                        //                                       padding: EdgeInsets.symmetric(
                                        //                                           horizontal:
                                        //                                               defaultHorizontalPadding),
                                        //                                       child: Text(
                                        //                                           'Online',
                                        //                                           style: mainStyle(
                                        //                                               context,
                                        //                                               14)),
                                        //                                     ),
                                        //                                     heightBox(
                                        //                                         5.h),
                                        //                                     Expanded(
                                        //                                       child: ListView
                                        //                                           .separated(
                                        //                                         physics:
                                        //                                             BouncingScrollPhysics(),
                                        //                                         padding:
                                        //                                             EdgeInsets.symmetric(vertical: defaultHorizontalPadding / 24),
                                        //                                         itemBuilder:
                                        //                                             (context, index) {
                                        //                                           List<OnlineUser?>?
                                        //                                               onlineUsers =
                                        //                                               messengerCubit.onlineUsersModel!.data!.onlineUsers;
                                        //                                           return GestureDetector(
                                        //                                             onTap: () {
                                        //                                               navigateTo(
                                        //                                                   context,
                                        //                                                   ChatLayout(
                                        //                                                     // chatId: onlineUsers![index]!.chatId,
                                        //                                                     user: onlineUsers![index]!.user,
                                        //                                                     // userName: onlineUsers[index]!.fullName,
                                        //                                                     // userPic: onlineUsers[index]!.personalPicture,
                                        //                                                   ));
                                        //                                               logg('caht layoiut');
                                        //                                             },
                                        //                                             child: ProfileBubbleWithName(
                                        //                                               isOnline: true,
                                        //                                               radius: 25.w,
                                        //                                               pictureUrl: onlineUsers![index]!.personalPicture!,
                                        //                                               name: '${onlineUsers[index]!.abbreviation ?? ''} ${onlineUsers[index]!.fullName ?? ''}',
                                        //                                             ),
                                        //                                           );
                                        //                                         },
                                        //                                         separatorBuilder: (_, i) =>
                                        //                                             SizedBox(),
                                        //                                         itemCount: messengerCubit
                                        //                                             .onlineUsersModel!
                                        //                                             .data!
                                        //                                             .onlineUsers!
                                        //                                             .length,
                                        //                                       ),
                                        //                                     ),
                                        //                                   ],
                                        //                                 )),
                                        //                 ),
                                        //               ),
                                        //               Positioned(
                                        //                 bottom: 0,
                                        //                 child: SizedBox(
                                        //                   width: 0.2.sw,
                                        //                   height: 0.2.sw,
                                        //                   child: Row(
                                        //                     mainAxisAlignment:
                                        //                         MainAxisAlignment
                                        //                             .center,
                                        //                     children: [
                                        //                       GestureDetector(
                                        //                         onTap: () {
                                        //                           navigateTo(context,
                                        //                               UsersToStartChatLayout());
                                        //                         },
                                        //                         child: Container(
                                        //                           color: Colors.white,
                                        //                           width: 68.sp,
                                        //                           child: Center(
                                        //                             child: SvgPicture
                                        //                                 .asset(
                                        //                               'assets/svg/icons/addcircle.svg',
                                        //                               height: 55.sp,
                                        //                               width: 55.sp,
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
          },
        ),
      ),
    );
  }
}

class WelcomeToMenaChatLayout extends StatelessWidget {
  const WelcomeToMenaChatLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(56.0.h),
        //   child: const DefaultBackTitleAppBar(
        //     title: '',
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateTo(context, UsersToStartChatLayout());
          },
          child: SvgPicture.asset(
            'assets/svg/icons/icons8_pencil 1.svg',
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MessengerHeader(isSearchBarVisible: false),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslatedStrings(context).welcomeToMEnaChat,
                        style: mainStyle(context, 14,
                            weight: FontWeight.w600, color: mainBlueColor),
                      ),
                      heightBox(33.h),
                      Text(
                        getTranslatedStrings(context).startByTapping,
                        textAlign: TextAlign.center,
                        style: mainStyle(context, 13, color: mainBlueColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class MsgSummaryItem extends StatefulWidget {
  const MsgSummaryItem({
    Key? key,
    required this.chat,
    required this.user,
    this.isNotRead = true,
  }) : super(key: key);
  final ChatItem chat;
  final User? user;
  final bool? isNotRead;

  @override
  State<MsgSummaryItem> createState() => _MsgSummaryItemState();
}

class _MsgSummaryItemState extends State<MsgSummaryItem> {
  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return widget.user == null
        ? Text('null user')
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal)),
            ),
            child: GestureDetector(
              onTap: () {
                navigateTo(
                    context,
                    ChatLayout(
                      chatId: widget.chat.id.toString(),
                      user: widget.user,
                    ));
              },
              child: Slidable(
                key: const ValueKey(0),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),
                  // A pane can dismiss the Slidable.
                  // dismissible: DismissiblePane(onDismissed: () {}),
                  extentRatio: 0.7,
                  openThreshold: 0.2,
                  // dismissible: DismissiblePane(
                  //   closeOnCancel: true,
                  //   dismissThreshold: 0.9,
                  //   confirmDismiss: () async {
                  //     // always returning false so it doesn't get dismissed
                  //     return false;
                  //   },
                  //   onDismissed: () {
                  //     // perform your action here
                  //   },
                  // ),
                  children: [
                    CustomSlidableAction(
                      fn: () {
                        logg('delete');
                        showAlertConfirmDialog(context,
                            customTitle:
                                getTranslatedStrings(context).confirmChatDelete,
                            customSubTitle: getTranslatedStrings(context)
                                .youAreAboutDeletingChat, confirmCallBack: () {
                          messengerCubit
                              .deleteChat(
                            chatId: widget.chat.id.toString(),
                          )
                              .then((value) {
                            setState(() {});
                            messengerCubit.fetchMyMessages();
                            Navigator.pop(context);
                          });
                        });
                      },
                      text: getTranslatedStrings(context).delete,
                      svgPic: 'assets/svg/icons/remove.svg',
                    ),
                    CustomSlidableAction(
                      fn: () {
                        logg('As read');
                        showAlertConfirmDialog(context,
                            customTitle:
                                getTranslatedStrings(context).markAsRead,
                            customSubTitle: getTranslatedStrings(context)
                                .youAboutMarkREad, confirmCallBack: () {
                          messengerCubit
                              .markAsRead(
                            chatId: widget.chat.id.toString(),
                          )
                              .then((value) async {
                            messengerCubit.fetchMyMessages();

                            Navigator.pop(context);
                            await Future.delayed(Duration(seconds: 10));
                            logg('unfocus');
                            FocusScope.of(context).unfocus();
                          });
                        });
                      },
                      text: getTranslatedStrings(context).asRead,
                      svgPic: 'assets/svg/icons/asread.svg',
                    ),
                    CustomSlidableAction(
                      fn: () {
                        logg('Mute');
                        // showAlertConfirmDialog(context,
                        //     customTitle: 'Confirm chat deletion',
                        //     customSubTitle: 'You are about deleting this chat..', confirmCallBack: () {
                        //   messengerCubit
                        //       .deleteChat(
                        //     chatId: widget.chat.id.toString(),
                        //   )
                        //       .then((value) {
                        //     setState(() {});
                        //     messengerCubit
                        //       .fetchMyMessages();
                        //     Navigator.pop(context);
                        //   });
                        // });
                      },
                      text: getTranslatedStrings(context).mute,
                      svgPic: 'assets/svg/icons/mute.svg',
                    ),
                    // SlidableAction(
                    //   onPressed: (context){},
                    //   backgroundColor: Color(0xFFFE4A49),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.delete,
                    //   label: 'Delete',
                    // ),
                    // SlidableAction(
                    //   onPressed: (context){},
                    //   backgroundColor: Color(0xFF21B7CA),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.share,
                    //   label: 'As read',
                    // ),
                    // SlidableAction(
                    //   onPressed: (context){},
                    //   backgroundColor: Color(0xFF21B7CA),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.share,
                    //   label: 'Mute',
                    //
                    // ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding / 10),
                  child: Container(
                    /// to be clickable
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileBubble(
                            isOnline: true,
                            radius: 17.sp,
                            pictureUrl: widget.chat.user!.personalPicture,
                          ),
                          widthBox(8.w),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    constraints:
                                        BoxConstraints(maxWidth: 200.w),
                                    child: Text(
                                      getFormattedUserName(widget.chat.user!),
                                      // '${widget.chat.user!.abbreviation == null ? '' : widget.chat.user!.abbreviation!.name == '' ? '' : widget.chat.user!.abbreviation!.name! + ' '}${widget.chat.user!.fullName}',
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          mainStyle(context, 12, isBold: true),
                                    ),
                                  ),
                                  (widget.chat.user!.verified == '1')
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
                              // Text.rich(
                              //   maxLines: 2,softWrap: true,
                              //   overflow: TextOverflow.ellipsis,
                              //   TextSpan(
                              //     children: [
                              //       TextSpan(
                              //         text:
                              //             "${chat.user!.abbreviation == null ? '' : chat.user!.abbreviation!.name} ${chat.user!.fullName}",
                              //         style:
                              //             mainStyle(context, 13, weight: FontWeight.w600),
                              //         // spellOut: false
                              //       ),
                              //       if (chat.user!.verified == '1')
                              //         WidgetSpan(
                              //           child: Padding(
                              //             padding:
                              //                 const EdgeInsets.symmetric(horizontal: 3.0),
                              //             child: Icon(
                              //               Icons.verified,
                              //               color: Color(0xff01BC62),
                              //               size: 16.sp,
                              //             ),
                              //           ),
                              //         ),
                              //     ],
                              //   ),
                              // ),
                              // Text(
                              //   chat.user!.fullName.toString(),
                              //   style: mainStyle(
                              //       context, 14, weight: FontWeight.w800),
                              // ),
                              heightBox(5.h),
                              Text(
                                widget.chat.lastMessage != null
                                    ? widget.chat.lastMessage!.isEmpty
                                        ? 'last message'
                                        : widget.chat.lastMessage!
                                    : 'last message',
                                style: mainStyle(context, 12,
                                    weight: widget.isNotRead!
                                        ? FontWeight.w900
                                        : FontWeight.normal,
                                    textHeight: 1.2,
                                    color: newLightTextGreyColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              heightBox(5.h),
                              Text(
                                getFormattedDate(widget.chat.createdAt!),
                                style: mainStyle(
                                  context,
                                  9,
                                  weight: FontWeight.w600,
                                  color: const Color.fromRGBO(111, 111, 111, 1),
                                ),
                              ),
                            ],
                          )),
                          if (widget.chat.numOfUnread! > 0) widthBox(5.w),
                          if (widget.chat.numOfUnread! > 0)
                            Center(
                                child: CircleAvatar(
                              radius: 5.sp,
                              backgroundColor: mainBlueColor,
                            ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class CustomSlidableAction extends StatelessWidget {
  const CustomSlidableAction({
    Key? key,
    required this.fn,
    required this.svgPic,
    required this.text,
  }) : super(key: key);
  final Function() fn;
  final String svgPic;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(svgPic),
              heightBox(4.h),
              Text(
                text,
                style: mainStyle(context, 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBubbleWithName extends StatelessWidget {
  const ProfileBubbleWithName({
    Key? key,
    required this.isOnline,
    required this.pictureUrl,
    required this.name,
    this.radius,
  }) : super(key: key);
  final bool isOnline;
  final double? radius;
  final String pictureUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ProfileBubble(
        isOnline: isOnline,
        radius: radius,
        pictureUrl: pictureUrl,
      ),
      heightBox(4.h),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 0.13.sw),
            child: Text(
              name,
              style: mainStyle(context, 9, weight: FontWeight.w900),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ]);
  }
}

class MessengerHeader extends StatelessWidget {
  const MessengerHeader({
    Key? key,
    this.isSearchBarVisible = true,
  }) : super(key: key);

  final bool isSearchBarVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
      ),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/back.svg',
                color: mainBlueColor,
                height: 20.h,
              )),
          widthBox(10.w),
          isSearchBarVisible
              ? Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                      border: Border.all(
                        color: const Color.fromRGBO(1, 112, 204, 1),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [SvgPicture.asset('assets/svg/search.svg')],
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class NewMessengerHeader extends StatelessWidget {
  const NewMessengerHeader({
    Key? key,
    this.isSearchBarVisible = true,
  }) : super(key: key);

  final bool isSearchBarVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // widthBox(0.02.sw),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/icons/back.svg',
                        color: mainBlueColor,
                      ),
                    ),
                  ),
                ),
              ),
              // widthBox(0.02.sw),
              ProfileBubble(
                isOnline: true,
                pictureUrl: MainCubit.get(context)
                    .userInfoModel!
                    .data
                    .user
                    .personalPicture,
                radius: 17.sp,
              ),
              widthBox(7.w),
              SvgPicture.asset('assets/svg/icons/menamessengerlogo.svg'),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  navigateTo(context, UsersToStartChatLayout());
                },
                child: SvgPicture.asset(
                  'assets/svg/icons/edit.svg',
                  color: mainBlueColor,
                  width: 25.sp,
                ),
              ),
              widthBox(7.w),
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/svg/icons/searchFilled.svg',
                  // color: mainBlueColor,
                  width: 28.sp,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> showAlertConfirmDialog(BuildContext context,
    {String? customTitle,
    String? customSubTitle,
    Function()? confirmCallBack}) {
  return showMyAlertDialog(
      context, customTitle ?? getTranslatedStrings(context).areYouSure,
      alertDialogContent: Text(
        customSubTitle ?? getTranslatedStrings(context).confirmAction,
        textAlign: TextAlign.center,
        style: mainStyle(context, 13, color: Colors.black),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(getTranslatedStrings(context).cancel)),
        TextButton(
            onPressed: confirmCallBack ??
                () {
                  logg('confirm callback');
                },
            child: Text(getTranslatedStrings(context).confirm)),
      ]);
}
