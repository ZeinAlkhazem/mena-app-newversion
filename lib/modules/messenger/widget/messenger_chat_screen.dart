import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/Colors.dart';
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
    }, builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
          //   child: Text(
          //     "Chat",
          //     style: mainStyle(
          //       context,
          //       14.sp,
          //       isBold: true,
          //     ),
          //   ),
          // ),

          /// body of chat
          Container(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 40.w),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  width: ScreenUtil().screenWidth * 0.6,
                  height: ScreenUtil().screenHeight * 0.25,
                  child: Lottie.asset(
                    'assets/icons/messenger/chat_welcome.json',
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  getTranslatedStrings(context).messengerWelcomeText,
                  textAlign: TextAlign.justify,
                  style: mainStyle(context, 10.sp,
                      weight: FontWeight.w400,
                      fontFamily: AppFonts.openSansFont,
                      color: AppColors.grayGreenColor),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
