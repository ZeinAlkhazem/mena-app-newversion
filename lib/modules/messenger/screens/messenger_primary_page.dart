import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/messenger/widget/empty_new_message_widget.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/functions/main_funcs.dart';

class MessengerPrimaryPage extends StatelessWidget {
  const MessengerPrimaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 25.h,width: 25.w,
                    child: SvgPicture.asset("$messengerAssets/icon_archived.svg")),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  getTranslatedStrings(context).messengerArchived,
                  style: mainStyle(context, 10.sp,
                      weight: FontWeight.w700,
                      color: Color(0xFF5B5C5E),
                      fontFamily: AppFonts.openSansFont,
                      textHeight: 1.1),
                ),
              ],
            ),
          ),
          EmptyNewMessageWidget(content: getTranslatedStrings(context).messengerPrimaryEmptyText),
        ],
      ),
    );
  }
}
