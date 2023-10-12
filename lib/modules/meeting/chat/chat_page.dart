import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/meeting/chat/widget/divider_with_padding.dart';

import '../../../core/functions/main_funcs.dart';
import '../../start_live/widget/live_message_inputfield.dart';
import '../cubit/meeting_cubit.dart';
import 'widget/chat_items.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    return Container(
      height: 0.9.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat",
                  style: mainStyle(context, 16.sp, isBold: true),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          ),
          const DividerWithPadding(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return const ChatItems(
                      userName: "name",
                      userImage:
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      userMessage: "test massage");
                }),
          ),
          Container(
            color: Colors.white.withOpacity(0.5),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: LiveMessageInputField(
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () => meetingCubit.sendMessage(),
                icon: SvgPicture.asset(
                  'assets/live_icon/send_chat.svg',
                ),
              ),
              prefixIcon: IconButton(
                padding: EdgeInsets.zero,
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () => meetingCubit.emojiPicker(context),
                icon: SvgPicture.asset(
                  'assets/live_icon/chat_smile.svg',
                ),
              ),
              controller: meetingCubit.chatMessageText,
            ),
          ),
        ],
      ),
    );
  }
}
