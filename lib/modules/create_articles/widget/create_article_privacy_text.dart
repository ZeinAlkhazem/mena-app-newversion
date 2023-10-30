import 'package:flutter/material.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';

class PrivacyText extends StatelessWidget {
  const PrivacyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: mainStyle(context, 12, color: AppColors.textGray),
          children: <TextSpan>[
            TextSpan(text: 'By tapping  Publish'),
            // TextSpan(
            //   text: ' Publish ',
            //   style: mainStyle(context, 13,
            //       color: Colors.grey, weight: FontWeight.w700),
            // ),
            TextSpan(text: 'you consist to abide by'),
            TextSpan(
              onEnter: (v){},
              text: ' Mena\'s\n',
              style: mainStyle(context, 13,
                  color: AppColors.lineBlue, weight: FontWeight.w700),
            ),
            TextSpan(
              onEnter: (v){},
              text: 'Blog Terms and Conditions',
              style: mainStyle(context, 13,
                  color: AppColors.lineBlue, weight: FontWeight.w700),
            ),
            TextSpan(text: ' when publishing articles in\n'),
            TextSpan(text: 'Mena Blogs'),
          ],
        ),
      ),
    );
  }
}
