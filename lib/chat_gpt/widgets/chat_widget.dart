import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/chat_gpt/widgets/text_widget.dart';

import '../../../core/functions/main_funcs.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.role,
      required this.onFinished});

  final String msg;
  final String role;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: role == "user" ? chatGreyColor : chatBlueColor,
              borderRadius: BorderRadius.circular(10.r)),
          margin: EdgeInsets.only(top: 8.0.h, right: 10.w, left: 10.w),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                role == "user"
                    ? "assets/images/person2.png"
                    : "assets/images/chat.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: role == "user"
                    ? TextWidget(
                        color: Colors.black,
                        label: msg.substring(85),
                      )
                    : DefaultTextStyle(
                        style: mainStyle(context, 14),
                        child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                msg.trim(),
                              ),
                            ]),
                      ),
              ),
              // role == "user"
              //     ? const SizedBox.shrink()
              //     : Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         mainAxisSize: MainAxisSize.min,
              //         children: const [
              //           Icon(
              //             Icons.thumb_up_alt_outlined,
              //             color: Colors.white,
              //           ),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Icon(
              //             Icons.thumb_down_alt_outlined,
              //             color: Colors.white,
              //           )
              //         ],
              //       ),
            ],
          ),
        ),
      ],
    );
  }
}
