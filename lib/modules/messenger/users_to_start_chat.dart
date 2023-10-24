import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/messenger/chat_layout.dart';
import 'package:mena/modules/messenger/cubit/messenger_cubit.dart';
import 'package:mena/modules/messenger/widget/user_chat_icon_widget.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import 'widget/messenger_chat_item_widget.dart';
import 'widget/users_chat_list_widget.dart';

class UsersToStartChatLayout extends StatelessWidget {
  const UsersToStartChatLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF205986),
                Color(0xFF4480c2),
              ],
            ),
          ),
        ),
        title: Text(
          getTranslatedStrings(context)
              .newMessage,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: mainStyle(context, 14.sp, isBold: true,color: Colors.white),
        ),
        leading: InkWell(
          onTap: ()=>Navigator.of(context).pop(),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset("assets/icons/messenger/icon_back_white.svg",width: 10.w),
          ),
        ),
        actions: [
          InkWell(
            onTap: (){

            },
            child: SvgPicture.asset("assets/icons/messenger/icon_search_white.svg",width: 40.w),
          ),
        ],
      ),
      body: BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              // /// if provider
              // if (MainCubit.get(context).isUserProvider())
              //   Padding(
              //     padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              //     child: Row(
              //       children: [
              //         TabItem(
              //             text: getTranslatedStrings(context).providers,
              //             isSelected: messengerCubit.selectedMessengerNewMessageLayout == 0,
              //             callBack: () {
              //               messengerCubit.changeMessengerNewMessageLayout(0);
              //             }),
              //         TabItem(
              //             text: getTranslatedStrings(context).clients,
              //             isSelected: messengerCubit.selectedMessengerNewMessageLayout == 1,
              //             callBack: () {
              //               messengerCubit.changeMessengerNewMessageLayout(1);
              //             }),
              //         TabItem(
              //             text: getTranslatedStrings(context).students,
              //             isSelected: messengerCubit.selectedMessengerNewMessageLayout == 2,
              //             callBack: () {
              //               messengerCubit.changeMessengerNewMessageLayout(2);
              //             }),
              //       ],
              //     ),
              //   ),

              /// chat group and chat channel
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessengerChatItemWidget(
                    title:  getTranslatedStrings(context)
                        .chatGroups,
                    icon: "assets/icons/messenger/icon_messenger.svg",
                    btnClick: (){},
                  ),
                  MessengerChatItemWidget(
                    title:  getTranslatedStrings(context)
                        .chatChannels,
                    icon: "assets/icons/messenger/icon_messenger.svg",
                    btnClick: (){},
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ChatUsersListWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
