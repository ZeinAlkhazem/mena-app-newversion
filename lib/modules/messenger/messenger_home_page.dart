import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/modules/messenger/widget/messenger_chat_screen.dart';
import 'package:mena/modules/messenger/widget/messenger_empty_widget.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'cubit/messenger_cubit.dart';
import 'users_to_start_chat.dart';
import 'widget/icon_button_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessengerHomePage extends StatefulWidget {
  const MessengerHomePage({super.key});

  @override
  State<MessengerHomePage> createState() => _MessengerHomePageState();
}

class _MessengerHomePageState extends State<MessengerHomePage> {
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
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
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
                                  "assets/icons/messenger/icon_mena_messenger_white.svg",
                                  height: 25.h,
                                ),
                              ),
                              elevation: 0,
                              flexibleSpace: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        const Color(0xFF1c5580),
                                        const Color(0xFF4480c2),
                                      ]),
                                ),
                              ),
                              actions: [
                                IconButtonWidget(
                                    iconUrl:
                                        "assets/icons/messenger/icon_video_call_white.svg",
                                    btnClick: () {}),
                                IconButtonWidget(
                                    iconUrl:
                                        "assets/icons/messenger/icon_search_white.svg",
                                    btnClick: () {}),
                                IconButtonWidget(
                                    iconUrl:
                                        "assets/icons/messenger/icon_menu_white.svg",
                                    btnClick: () {}),
                              ],
                              bottom: TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        width: 4.h, color: Colors.white)),
                                isScrollable: false,
                                tabs: [
                                  Tab(text: "Chat"),
                                  Tab(text: "Chat Groups"),
                                  Tab(text: "Channels"),
                                  Tab(text: "Calls"),
                                ],
                              ),
                            ),
                            body: TabBarView(
                              children: [
                                MessengerChatScreen(),
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
                                Container(
                                  child: Lottie.asset(
                                    'assets/json/coming soon.json',
                                  ),
                                ),
                              ],
                            ),
                            floatingActionButton: Container(
                              width: 45.w,
                              height: 45.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                // color: primaryColor,
                                borderRadius: BorderRadius.circular(10.h),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      const Color(0xFF1c5580),
                                      const Color(0xFF4480c2),
                                    ]),
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateTo(context, UsersToStartChatLayout());
                                },
                                child: SizedBox(
                                  child: SvgPicture.asset(
                                    "assets/icons/messenger/icon_chat_3_dots.svg",
                                    color: Colors.white,
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
