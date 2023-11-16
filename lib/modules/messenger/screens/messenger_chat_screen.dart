import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import 'package:mena/core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../cubit/messenger_cubit.dart';
import '../widget/my_store_widget.dart';

class MessengerChatScreen extends StatelessWidget {
  const MessengerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return Container(
        height: 0.9.sh,
        color: Colors.white,
        child: Column(
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
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyStoryWidget(count: 1),
                  SizedBox(
                    height: 100.h,
                  ),
                  SizedBox(
                    width: 73.w,
                    height: 73.h,
                    child:SvgPicture.asset(
                      "$messengerAssets/icon_circle_plus.svg",
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 22.5.w
                        ),
                    child: Text(
                      getTranslatedStrings(context).messengerEmptyChatText,
                      textAlign: TextAlign.center,
                      style: mainStyle(context, 11.sp,
                          weight: FontWeight.normal,
                          fontFamily: AppFonts.interFont,
                          color: AppColors.textGray,
                          textHeight: 1.4
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
