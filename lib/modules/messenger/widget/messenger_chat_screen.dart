import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../cubit/messenger_cubit.dart';

class MessengerChatScreen extends StatelessWidget {
  const MessengerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.w
                ),
                child: Text(
                  "Chat",
                  style: mainStyle(
                      context, 14.sp, isBold: true,
                      // color: primaryColor
                  ),
                ),
              ),

              /// body of chat
              Container(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 40.w),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/icons/messenger/chat_welcome.json',
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      "Welcome to the messenger! It looks like you don't have any chats yet. You can start by writing messages, sending and sharing media and files, including high-resolution images and videos. To begin, simply click on the button at the bottom of this page",
                      textAlign: TextAlign.justify,
                      style:
                      mainStyle(
                          context, 10, isBold: true,
                          // color: hintTitleColor
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}