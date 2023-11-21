import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/messenger/widget/add_story_widget.dart';
import 'package:mena/modules/messenger/widget/user_story_widget.dart';

class MyStoryWidget extends StatelessWidget {
  final int count;
  const MyStoryWidget({super.key,required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
      top: 2.h,bottom: 2.h,right: 0.w,left: 12.w
      ),
      child: SizedBox(
        height: 110.h,
        width: 1.sw,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          primary: true,
          itemCount: count,
          itemBuilder: (context, index) {
            return index == 0 ? Row(
              children: [
                AddStoryWidget(),
                SizedBox(width: 1.w,)
              ],
            ) : UserStoryWidget();
          },
        ),
      ),
    );
  }
}
