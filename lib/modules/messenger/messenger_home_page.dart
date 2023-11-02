import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/modules/messenger/widget/messenger_chat_screen.dart';
import 'package:mena/modules/messenger/widget/messenger_empty_widget.dart';
import 'package:mena/modules/messenger/widget/tab_item_widget.dart';
import '../../core/constants/Colors.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'cubit/messenger_cubit.dart';
import 'messenger_layout.dart';
import 'users_to_start_chat.dart';
import 'widget/icon_button_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessengerHomePage extends StatefulWidget {
  const MessengerHomePage({super.key});

  @override
  State<MessengerHomePage> createState() => _MessengerHomePageState();
}

class _MessengerHomePageState extends State<MessengerHomePage>
    with SingleTickerProviderStateMixin {
  IO.Socket? socket;
  TabController? _tabController;
  int index = 0;

  // final List<Widget> myTabs = [
  //   TabItemWidget(
  //       title: "Chat",
  //       iconBlueUrl: "assets/icons/messenger/icon_chat_blue.svg",
  //       iconGrayUrl: "assets/icons/messenger/icon_chat_grey.svg",
  //       btnClick: () {},
  //       isSelected:index == 0?true:false ),
  //   TabItemWidget(
  //       title: "Chat Groups",
  //       iconBlueUrl: "assets/icons/messenger/icon_chat_group_blue.svg",
  //       iconGrayUrl: "assets/icons/messenger/icon_chat_group_grey.svg",
  //       btnClick: () {},
  //       isSelected: false),
  //   TabItemWidget(
  //       title: "Channels",
  //       iconBlueUrl: "assets/icons/messenger/icon_channel_blue.svg",
  //       iconGrayUrl: "assets/icons/messenger/icon_channel_grey.svg",
  //       btnClick: () {},
  //       isSelected: false),
  //   TabItemWidget(
  //       title: "Calls",
  //       iconBlueUrl: "assets/icons/messenger/icon_channel_blue.svg",
  //       iconGrayUrl: "assets/icons/messenger/icon_channel_grey.svg",
  //       btnClick: () {},
  //       isSelected: false),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    var messengerCubit = MessengerCubit.get(context);
    _tabController = new TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          index = _tabController!.index;
        });
      });

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
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return
            //   MessengerEmptyWidget(
            //   title: getTranslatedStrings(context)
            //       .welcomeToMenaMessenger,
            //   description: getTranslatedStrings(context)
            //       .startMessagingWithProvidersClients,
            //   imageUrl:
            //   "assets/icons/messenger/icon_mena_messenger_colors.svg",
            //   btnClick: () {
            //     navigateTo(context, UsersToStartChatLayout());
            //   },
            // );

            Scaffold(
          body: messengerCubit.myMessagesModel == null
              ? DefaultLoaderGrey()
              : messengerCubit.myMessagesModel!.data.myChats == null
                  ? DefaultLoaderGrey()
                  : messengerCubit.myMessagesModel!.data.myChats!.isEmpty
                      ? MessengerEmptyWidget(
                          title: getTranslatedStrings(context)
                              .welcomeToMenaMessenger,
                          description: getTranslatedStrings(context)
                              .startMessagingWithProvidersClients,
                          imageUrl:
                              "assets/icons/messenger/icon_mena_messenger_colors.svg",
                          btnClick: () {
                            navigateTo(context, UsersToStartChatLayout());
                          },
                        )
                      : DefaultTabController(
                          length: 4,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: AppBar(
                              leading: SizedBox(),
                              leadingWidth: 0,
                              titleSpacing: 0,
                              title: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: SvgPicture.asset(
                                  "assets/icons/messenger/icon_mena_messenger_color_hor.svg",
                                  height: 25.h,
                                ),
                              ),
                              elevation: 0,
                              flexibleSpace: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                              actions: [
                                IconButtonWidget(
                                  iconUrl:
                                      "assets/icons/messenger/icon_new_call.svg",
                                  btnClick: () {},
                                  iconWidth: 30.w,
                                  iconHeight: 25.h,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                IconButtonWidget(
                                  iconUrl:
                                      "assets/icons/messenger/icon_search.svg",
                                  btnClick: () {},
                                  iconWidth: 20.w,
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: AppColors.iconsColor,
                                    size: 30.h,
                                  ),
                                ),
                              ],
                            ),
                            body: Column(
                              children: [
                                Divider(color: Color(0xffF2F2F2)),
                                SizedBox(
                                  height: 50.h,
                                  child: TabBar(
                                    // indicator: UnderlineTabIndicator(
                                    //     borderSide: BorderSide(
                                    //         width: 4.h, color: Colors.white)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.w, vertical: 5.h),
                                    indicatorColor: Colors.transparent,
                                    isScrollable: true,
                                    labelPadding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    controller: _tabController,
                                    tabs: [
                                      TabItemWidget(
                                          title: getTranslatedStrings(context)
                                              .messengerChat,
                                          iconBlueUrl:
                                              "assets/icons/messenger/icon_chat_blue.svg",
                                          iconGrayUrl:
                                              "assets/icons/messenger/icon_chat_grey.svg",
                                          btnClick: () {},
                                          isSelected: _tabController!.index == 0
                                              ? true
                                              : false),
                                      TabItemWidget(
                                          title: getTranslatedStrings(context)
                                              .messengerChatGroups,
                                          iconBlueUrl:
                                              "assets/icons/messenger/icon_chat_group_blue.svg",
                                          iconGrayUrl:
                                              "assets/icons/messenger/icon_chat_group_grey.svg",
                                          btnClick: () {},
                                          isSelected: _tabController!.index == 1
                                              ? true
                                              : false),
                                      TabItemWidget(
                                          title: getTranslatedStrings(context)
                                              .messengerChannels,
                                          iconBlueUrl:
                                              "assets/icons/messenger/icon_channel_blue.svg",
                                          iconGrayUrl:
                                              "assets/icons/messenger/icon_channel_grey.svg",
                                          btnClick: () {},
                                          isSelected: _tabController!.index == 2
                                              ? true
                                              : false),
                                      // TabItemWidget(
                                      //     title: getTranslatedStrings(context)
                                      //         .messengerCalls,
                                      //     iconBlueUrl:
                                      //         "assets/icons/messenger/icon_channel_blue.svg",
                                      //     iconGrayUrl:
                                      //         "assets/icons/messenger/icon_channel_grey.svg",
                                      //     btnClick: () {},
                                      //     isSelected: _tabController!.index == 3
                                      //         ? true
                                      //         : false),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      /// chat page
                                      messengerCubit.myMessagesModel == null
                                          ? DefaultLoaderGrey()
                                          : messengerCubit.myMessagesModel!.data
                                                      .myChats ==
                                                  null
                                              ? DefaultLoaderGrey()
                                              : messengerCubit.myMessagesModel!
                                                      .data.myChats!.isEmpty
                                                  ? MessengerChatScreen()
                                                  : Expanded(
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(
                                                          horizontal: 10.w
                                                        ),
                                                        child: ListView.separated(
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.zero,
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
                                                          separatorBuilder:
                                                              (_, i) =>
                                                                  heightBox(5.h),
                                                          itemCount: messengerCubit
                                                              .myMessagesModel!
                                                              .data
                                                              .myChats!
                                                              .length,
                                                        ),
                                                      ),
                                                    ),
                                      Container(
                                        child: Lottie.asset(
                                          'assets/json/coming soon.json',
                                        ),
                                      ),
                                      Container(
                                        child: Lottie.asset(
                                          'assets/json/coming soon.json',
                                        ),
                                      ),
                                      // Container(
                                      //   child: Lottie.asset(
                                      //     'assets/json/coming soon.json',
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            floatingActionButton: Container(
                              width: 55.w,
                              height: 55.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h),
                                // gradient: LinearGradient(
                                //     begin: Alignment.topCenter,
                                //     end: Alignment.bottomCenter,
                                //     colors: <Color>[
                                //       const Color(0xFF1c5580),
                                //       const Color(0xFF4480c2),
                                //     ]),
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateTo(context, UsersToStartChatLayout());
                                },
                                child: SizedBox(
                                  child: SvgPicture.asset(
                                    _tabController!.index == 0 ?
                                    "assets/icons/messenger/icon_new_message.svg":"assets/icons/messenger/icon_plus_blue.svg",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
        );
      },
    );
  }
}
