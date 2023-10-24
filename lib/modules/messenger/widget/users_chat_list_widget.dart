import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/messenger_cubit.dart';
import 'user_chat_icon_widget.dart';

class ChatUsersListWidget extends StatefulWidget {
  const ChatUsersListWidget({
    super.key,
  });

  @override
  State<ChatUsersListWidget> createState() => _ChatUsersProvidersState();
}

class _ChatUsersProvidersState extends State<ChatUsersListWidget> {
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
      },
      builder: (context, state) {
        return state is GettingUsersData
            ? DefaultLoaderGrey()
            : messengerCubit.usersChatModel == null
                ? SizedBox()
                : messengerCubit.usersChatModel!.data!.users.isEmpty
                    ? EmptyListLayout()
                    : ListView.separated(
                        itemBuilder: (context, index) => UserChatIconWidget(
                            user: messengerCubit
                                .usersChatModel!.data!.users[index]),
                        separatorBuilder: (_, i) => Divider(),
                        itemCount:
                            messengerCubit.usersChatModel!.data!.users.length,
                      );
      },
    );
  }
}
