import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/modules/messenger/screens/messenger_new_message_page.dart';
import 'package:mena/modules/messenger/widget/chat_user_item_widget.dart';
import 'package:mena/modules/messenger/screens/messenger_chat_screen.dart';
import 'package:mena/modules/messenger/widget/my_store_widget.dart';
import 'package:mena/modules/messenger/widget/tab_item_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/messenger_cubit.dart';
import '../widget/icon_button_widget.dart';
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
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Color selectedColor = Color(0xff202226);
  Color unSelectedColor = Color(0xff999B9D);
  Color indicatorColor = Color(0xff2788E8);
  Color iconColor = Color(0xff2788E8);

  @override
  void initState() {
    // TODO: implement initState
    var messengerCubit = MessengerCubit.get(context);
    _tabController = new TabController(vsync: this, length: 4)
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

  void _onRefresh() async {
    var messengerCubit = MessengerCubit.get(context);
    messengerCubit
      ..fetchMyMessages()
      ..fetchOnlineUsers();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {},
      builder: (context, state) {
        var messengerCubit = MessengerCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFFDFDFD),
                // leading: SizedBox(),
                // leadingWidth: 0,
                // titleSpacing: 0,
                leading: Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 5.w),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: SvgPicture.asset(
                      "$messengerAssets/icon_messenger_user.svg",
                    ),
                  ),
                ),
                titleSpacing: 0,
                title: Text(
                  "Messenger",
                  style: mainStyle(
                    context,
                    18.sp,
                    fontFamily: AppFonts.interFont,
                    weight: FontWeight.w500,
                    color: Color(0xFF444444),
                    textHeight: 0,
                    letterSpacing: 0.33,
                  ),
                ),
                elevation: 1,
                actions: [
                  IconButtonWidget(
                    iconUrl: "$messengerAssets/icon_video_call.svg",
                    btnClick: () {},
                    iconWidth: 31.w,
                    iconHeight: 31.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButtonWidget(
                    iconUrl: "$messengerAssets/icon_search.svg",
                    btnClick: () {},
                    iconWidth: 25.w,
                    iconHeight: 25.h,
                  ),
                  SizedBox(
                    width: 5.w,
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
                bottom: TabBar(
                  padding: EdgeInsets.zero,
                  unselectedLabelColor: unSelectedColor,
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2.w, color: indicatorColor),
                      borderRadius: BorderRadius.circular(5.r),
                      insets: EdgeInsets.symmetric(horizontal: 15.w)),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      height: 15.h,
                      child: Text(
                        getTranslatedStrings(context).messengerChat,
                        style: mainStyle(
                          context,
                          12.sp,
                          fontFamily: AppFonts.interFont,
                          weight: FontWeight.w600,
                          color: _tabController!.index == 0
                              ? selectedColor
                              : unSelectedColor,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        getTranslatedStrings(context).messengerChatGroups,
                        style: mainStyle(
                          context,
                          12.sp,
                          fontFamily: AppFonts.interFont,
                          weight: FontWeight.w600,
                          color: _tabController!.index == 1
                              ? selectedColor
                              : unSelectedColor,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        getTranslatedStrings(context).messengerChannels,
                        style: mainStyle(
                          context,
                          12.sp,
                          fontFamily: AppFonts.interFont,
                          weight: FontWeight.w600,
                          color: _tabController!.index == 2
                              ? selectedColor
                              : unSelectedColor,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        getTranslatedStrings(context).messengerCalls,
                        style: mainStyle(
                          context,
                          12.sp,
                          fontFamily: AppFonts.interFont,
                          weight: FontWeight.w600,
                          color: _tabController!.index == 3
                              ? selectedColor
                              : unSelectedColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  // Divider(color: Color(0xffF2F2F2)),

                  // Divider(color: Color(0xffF2F2F2)),
                  // Container(
                  //   height: 65.h,
                  //   width: 1.sw,
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 5.w
                  //   ),
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         TabItemWidget(
                  //             title: getTranslatedStrings(context).messengerChat,
                  //             btnClick: () {
                  //               _tabController!.index = 0;
                  //             },
                  //             isSelected:
                  //                 _tabController!.index == 0 ? true : false),
                  //         TabItemWidget(
                  //             title: getTranslatedStrings(context)
                  //                 .messengerChatGroups,
                  //             btnClick: () {
                  //               _tabController!.index = 1;
                  //             },
                  //             isSelected:
                  //                 _tabController!.index == 1 ? true : false),
                  //         TabItemWidget(
                  //             title:
                  //                 getTranslatedStrings(context).messengerChannels,
                  //             btnClick: () {
                  //               _tabController!.index = 2;
                  //             },
                  //             isSelected:
                  //                 _tabController!.index == 2 ? true : false),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // MessengerChatScreen(),
                        /// chat page
                        messengerCubit.myMessagesModel == null
                            ? DefaultLoaderGrey()
                            : messengerCubit.myMessagesModel!.data.myChats ==
                                    null
                                ? DefaultLoaderGrey()
                                : messengerCubit
                                        .myMessagesModel!.data.myChats!.isEmpty
                                    ? MessengerChatScreen()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.w),
                                        child: Column(
                                          children: [
                                            MyStoryWidget(count: 10),
                                            SizedBox(
                                              height: 10.h,
                                            ),

                                            ///
                                            ///  Archive Section
                                            ///
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 19.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 20.w,
                                                    width: 20.w,
                                                    child: SvgPicture.asset(
                                                      "$messengerAssets/icon_archived.svg",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Text(
                                                    getTranslatedStrings(
                                                            context)
                                                        .messengerArchived,
                                                    style: mainStyle(
                                                        context, 14.sp,
                                                        fontFamily:
                                                            AppFonts.interFont,
                                                        weight: FontWeight.w600,
                                                        color:
                                                            Color(0xFF19191A),
                                                        textHeight: 1.1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),

                                            ///
                                            ///  chats Section
                                            ///

                                            Expanded(
                                              child:
                                              SmartRefresher(
                                                enablePullDown: true,
                                                controller: _refreshController,
                                                onRefresh: _onRefresh,
                                                child:

                                              ListView.separated(
                                                shrinkWrap: true,
                                                primary: true,
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  return ChatUserItemWidget(
                                                      index: index,
                                                      chatItem: messengerCubit
                                                          .myMessagesModel!
                                                          .data
                                                          .myChats![index]);
                                                },
                                                separatorBuilder: (_, i) =>
                                                    heightBox(0.h),
                                                itemCount: messengerCubit
                                                    .myMessagesModel!
                                                    .data
                                                    .myChats!
                                                    .length,
                                              ),),
                                            ),
                                          ],
                                        ),
                                      ),
                        ComingSoonWidget(),
                        ComingSoonWidget(),
                        ComingSoonWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: Container(
                width: 48.w,
                height: 48.w,
                margin: EdgeInsets.symmetric(vertical: 25.h, horizontal: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(50.h),
                ),
                child: InkWell(
                  onTap: () {
                    // navigateTo(context, UsersToStartChatLayout());
                    navigateTo(context, MessengerNewMessagePage());
                  },
                  child: SizedBox(
                    child: _tabController!.index == 0
                        ? SvgPicture.asset(
                            "$messengerAssets/icon_message.svg",
                          )
                        : SvgPicture.asset(
                            color: AppColors.iconsColor,
                            "$messengerAssets/icon_plus_blue.svg",
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
