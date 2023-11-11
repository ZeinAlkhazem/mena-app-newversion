import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/messenger/widget/add_story_widget.dart';
import 'package:mena/modules/messenger/widget/user_story_widget.dart';

class MyStoryWidget extends StatelessWidget {
  const MyStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      child: SizedBox(
        height: 110.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          primary: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return index == 0 ? AddStoryWidget() : UserStoryWidget();
          },
        ),
      ),
    );
  }
}
