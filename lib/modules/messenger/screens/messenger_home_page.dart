import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/modules/messenger/screens/messenger_new_message_page.dart';
import 'package:mena/modules/messenger/widget/chat_user_item_widget.dart';
import 'package:mena/modules/messenger/screens/messenger_chat_screen.dart';
import 'package:mena/modules/messenger/widget/my_store_widget.dart';
import 'package:mena/modules/messenger/widget/tab_item_widget.dart';
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
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {},
      builder: (context, state) {
        var messengerCubit = MessengerCubit.get(context);
        return Scaffold(
          body: DefaultTabController(
            length: 3,
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
                    iconUrl: "assets/icons/messenger/icon_phone_call.svg",
                    btnClick: () {},
                    iconWidth: 26.w,
                    iconHeight: 30.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  IconButtonWidget(
                    iconUrl: "assets/icons/messenger/icon_search.svg",
                    btnClick: () {},
                    iconWidth: 26.w,
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
                  MyStoryWidget(),
                  Divider(color: Color(0xffF2F2F2)),
                  Container(
                    height: 65.h,
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TabItemWidget(
                              title: getTranslatedStrings(context).messengerChat,
                              btnClick: () {
                                _tabController!.index = 0;
                              },
                              isSelected:
                                  _tabController!.index == 0 ? true : false),
                          TabItemWidget(
                              title: getTranslatedStrings(context)
                                  .messengerChatGroups,
                              btnClick: () {
                                _tabController!.index = 1;
                              },
                              isSelected:
                                  _tabController!.index == 1 ? true : false),
                          TabItemWidget(
                              title:
                                  getTranslatedStrings(context).messengerChannels,
                              btnClick: () {
                                _tabController!.index = 2;
                              },
                              isSelected:
                                  _tabController!.index == 2 ? true : false),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
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
                                            horizontal: 10.w),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return ChatUserItemWidget(
                                                type: index == 0
                                                    ? "send"
                                                    : index == 1
                                                        ? "receive"
                                                        : "done",
                                                user: messengerCubit
                                                    .myMessagesModel!
                                                    .data
                                                    .myChats![index]
                                                    .user!);
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
                        ComingSoonWidget(),
                        ComingSoonWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: Container(
                width: 65.w,
                height: 65.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: InkWell(
                  onTap: () {
                    // navigateTo(context, UsersToStartChatLayout());
                    navigateTo(context, MessengerNewMessagePage());
                  },
                  child: SizedBox(
                    child: _tabController!.index == 0
                        ? SvgPicture.asset(
                            "assets/icons/messenger/icon_write_message.svg",
                          )
                        : SvgPicture.asset(
                            color: AppColors.iconsColor,
                            "assets/icons/messenger/icon_plus_blue.svg",
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
