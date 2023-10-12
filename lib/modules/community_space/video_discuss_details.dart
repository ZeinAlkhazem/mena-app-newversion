import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/community_space/video_discussion.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../feeds_screen/feeds_screen.dart';
import '../feeds_screen/widgets/follow_user_button.dart';

class VideoDiscussDetails extends StatelessWidget {
  const VideoDiscussDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Video Discussion title',
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VideoDiscussItem(
              viewGroup: false,
            ),
            heightBox(30.h),
            const Text('Created by'),
            heightBox(5.h),
            DefaultShadowedContainer(
              // height: 33.h,
              childWidget: Padding(
                padding:  EdgeInsets.symmetric(
                    vertical: defaultHorizontalPadding,
                    horizontal: defaultHorizontalPadding),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(),
                        widthBox(9.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Dr. Name Name'),
                            Text('Dr. Name Name'),
                          ],
                        ),
                      ],
                    ),
                    const DefaultSoftButton()

                  ],
                ),
              ),
            ),
            heightBox(30.h),
            const Text('Members'),
            heightBox(30.h),
            const Text('GridView Members'),
            heightBox(30.h),
            const DefaultSoftButton(label: 'Join',)
          ],
        ),
      ),
    );
  }
}
