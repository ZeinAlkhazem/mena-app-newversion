import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/models/api_model/my_messages_model.dart';

import '../../../../core/functions/main_funcs.dart';
import '../../chat/widget/archived_button_widget.dart';
import '../../chat/widget/chat_user_item_widget.dart';

class PrimaryMessageListWidget extends StatelessWidget {
  final MyMessagesModel primaryMessage;
  const PrimaryMessageListWidget({super.key,required this.primaryMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w
      ),
      child:    Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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

          Container(
            height: 0.69.sh,
            child: ListView.separated(
              shrinkWrap: true,
              primary: true,
              padding: EdgeInsets.zero,
              itemCount: primaryMessage.data.myChats!.length,
              itemBuilder: (context, index) {
                return ChatUserItemWidget(
                    index: index,
                    chatType: "primary",
                    chatItem: primaryMessage
                        .data.myChats![index]);
              },
              separatorBuilder: (_, i) => heightBox(0.h),
            ),
          ),
        ],
      ),
    );
  }
}
