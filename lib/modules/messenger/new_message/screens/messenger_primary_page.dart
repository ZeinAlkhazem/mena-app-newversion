import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../chat/widget/empty_new_message_widget.dart';
import '../cubit/new_message_cubit.dart';
import '../cubit/new_message_state.dart';
import '../widgets/primary_list_widget.dart';

class MessengerPrimaryPage extends StatelessWidget {
  const MessengerPrimaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var primaryMessageCubit = NewMessageCubit.get(context);
    primaryMessageCubit.fetchPrimaryMessages();
    return BlocConsumer<NewMessageCubit, NewMessageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: state is GettingPrimaryMessagesData
                ? DefaultLoaderGrey()
                : state is SuccessGettingPrimaryMessagesDataState
                    ? Column(
                        children: [
                          primaryMessageCubit.primaryMessagesModel == null
                              ? DefaultLoaderGrey()
                              : primaryMessageCubit
                                          .primaryMessagesModel!.data.myChats ==
                                      null
                                  ? DefaultLoaderGrey()
                                  : primaryMessageCubit.primaryMessagesModel!
                                          .data.myChats!.isEmpty
                                      ? EmptyNewMessageWidget(
                                          content: getTranslatedStrings(context)
                                              .messengerPrimaryEmptyText)
                                      : PrimaryMessageListWidget(
                                          primaryMessage: primaryMessageCubit
                                              .primaryMessagesModel!,
                                        )
                        ],
                      )
                    : state is ErrorGettingPrimaryMessagesDataState
                        ? Container(
                            width: 1.sw,
                            height: 0.75.sh,
                            child: Text("Error"),
                          )
                        : SizedBox(),
          );
        });
  }
}
