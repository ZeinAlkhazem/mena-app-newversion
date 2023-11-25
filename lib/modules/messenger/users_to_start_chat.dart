import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/messenger/chat_layout.dart';


import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import 'chat/cubit/messenger_cubit.dart';

class UsersToStartChatLayout extends StatelessWidget {
  const UsersToStartChatLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: DefaultBackTitleAppBar(
            title: getTranslatedStrings(context).newMessage,
            suffix: Padding(
              padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: SvgPicture.asset('assets/svg/search.svg'),
            ),
            // suffix: GestureDetector(
            //   onTap: () {},
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //     child: SvgPicture.asset('assets/svg/icons/search.svg'),
            //   ),
            // ),
          ),
        ),
        body: BlocConsumer<MessengerCubit, MessengerState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              children: [
                // TabBar(
                //   tabs: [
                //     Tab(child:
                //     DefaultContainer(
                //       childWidget: Center(child: Text('Providers')),
                //       width: double.maxFinite,
                //       height: double.maxFinite,
                //       backColor: Colors.red,
                //       withoutBorder: true,
                //       radius: 11.sp,
                //       withBoxShadow: false,
                //     )
                //     ),
                //     Tab(text: 'Clients'),
                //     Tab(text: 'Students'),
                //   ],
                //   labelColor: mainBlueColor,
                //   // labelColor: const Color(0xff000000),
                //   labelPadding:
                //   const EdgeInsets.only(left: 0, right: 0),
                //   indicator: BoxDecoration(
                //       borderRadius:
                //       BorderRadius.circular(11.sp), // Creates border
                //       color: const Color(0xff77e8d9)),
                //   unselectedLabelColor: Colors.black,
                // ),

                /// if provider
                if (MainCubit.get(context).isUserProvider())
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                    child: Row(
                      children: [
                        TabItem(
                            text: getTranslatedStrings(context).providers,
                            isSelected: messengerCubit.selectedMessengerNewMessageLayout == 0,
                            callBack: () {
                              messengerCubit.changeMessengerNewMessageLayout(0);
                            }),
                        TabItem(
                            text: getTranslatedStrings(context).clients,
                            isSelected: messengerCubit.selectedMessengerNewMessageLayout == 1,
                            callBack: () {
                              messengerCubit.changeMessengerNewMessageLayout(1);
                            }),
                        TabItem(
                            text: getTranslatedStrings(context).students,
                            isSelected: messengerCubit.selectedMessengerNewMessageLayout == 2,
                            callBack: () {
                              messengerCubit.changeMessengerNewMessageLayout(2);
                            }),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: selectedTab(messengerCubit.selectedMessengerNewMessageLayout),
                  ),
                ),
              ],
            );
          },
        ));
  }
}

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.text,
    required this.isSelected,
    this.callBack,
  });

  final String text;
  final bool isSelected;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: callBack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: DefaultContainer(
            childWidget: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                  child: Text(
                text,
                style: mainStyle(context, 14, color: isSelected ? Colors.white : newDarkGreyColor, isBold: true),
              )),
            ),
            width: double.maxFinite,
            backColor: isSelected ? mainBlueColor : chatGreyColor,
            withoutBorder: true,
            radius: 11.sp,
            withBoxShadow: false,
          ),
        ),
      ),
    );
  }
}

Widget selectedTab(int index) {
  switch (index) {
    case 0:
      return ChatUsersProviders();
    case 1:
      return ChatUsersClients();
    case 2:
      return ChatUsersStudents();
    default:
      return ChatUsersProviders();
  }
}

class ChatUsersProviders extends StatefulWidget {
  const ChatUsersProviders({
    super.key,
  });

  @override
  State<ChatUsersProviders> createState() => _ChatUsersProvidersState();
}

class _ChatUsersProvidersState extends State<ChatUsersProviders> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MessengerCubit.get(context).getUsers(usersType: 'provider');
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return state is GettingUsersData
            ? DefaultLoaderGrey()
            : messengerCubit.usersChatModel == null
                ? SizedBox()
                : messengerCubit.usersChatModel!.data!.users.isEmpty
                    ? EmptyListLayout()
                    : ListView.separated(
                        itemBuilder: (context, index) =>
                            ChatUser(user: messengerCubit.usersChatModel!.data!.users[index]),
                        separatorBuilder: (_, i) => Divider(),
                        itemCount: messengerCubit.usersChatModel!.data!.users.length,
                      );
      },
    );
  }
}

class ChatUsersClients extends StatefulWidget {
  const ChatUsersClients({
    super.key,
  });

  @override
  State<ChatUsersClients> createState() => _ChatUsersClientsState();
}

class _ChatUsersClientsState extends State<ChatUsersClients> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MessengerCubit.get(context).getUsers(usersType: 'client');
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return state is GettingUsersData
            ? DefaultLoaderGrey()
            : messengerCubit.usersChatModel == null
                ? SizedBox()
                : messengerCubit.usersChatModel!.data!.users.isEmpty
                    ? EmptyListLayout()
                    : ListView.separated(
                        itemBuilder: (context, index) =>
                            ChatUser(user: messengerCubit.usersChatModel!.data!.users[index]),
                        separatorBuilder: (_, i) => Divider(),
                        itemCount: messengerCubit.usersChatModel!.data!.users.length,
                      );
      },
    );
  }
}

class ChatUsersStudents extends StatefulWidget {
  const ChatUsersStudents({
    super.key,
  });

  @override
  State<ChatUsersStudents> createState() => _ChatUsersStudentsState();
}

class _ChatUsersStudentsState extends State<ChatUsersStudents> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MessengerCubit.get(context).getUsers(usersType: 'student');
  }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return state is GettingUsersData
            ? DefaultLoaderGrey()
            : messengerCubit.usersChatModel == null
                ? SizedBox()
                : messengerCubit.usersChatModel!.data!.users.isEmpty
                    ? EmptyListLayout()
                    : ListView.separated(
                        itemBuilder: (context, index) =>
                            ChatUser(user: messengerCubit.usersChatModel!.data!.users[index]),
                        separatorBuilder: (_, i) => Divider(),
                        itemCount: messengerCubit.usersChatModel!.data!.users.length,
                      );
      },
    );
  }
}

class ChatUser extends StatelessWidget {
  const ChatUser({
    super.key,
    required this.user,
  });

  final User user;

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
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                  if (MainCubit.get(context).isUserProvider())
                    Column(
                      children: [
                        heightBox(5.h),
                        Text(
                          user.speciality ?? (user.specialities == null || user.specialities!.isEmpty)
                              ? '-'
                              : user.specialities![0].name ?? '',
                          style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
