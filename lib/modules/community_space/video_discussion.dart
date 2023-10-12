import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/community_space/video_discuss_details.dart';

import '../../core/shared_widgets/shared_widgets.dart';

class VideoDiscussion extends StatelessWidget {
  const VideoDiscussion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Video Discussion',
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const VideoDiscussItem();
            },
            separatorBuilder: (ctx, index) => heightBox(15.h),
            itemCount: 8,
          )),
    );
  }
}

class VideoDiscussItem extends StatelessWidget {
  const VideoDiscussItem({
    Key? key,
    this.viewGroup = true,
  }) : super(key: key);

  final bool viewGroup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logg('navigating to video discuss details');
        navigateToWithoutNavBar(context, const VideoDiscussDetails(), '');
      },
      child: DefaultShadowedContainer(
        // height: 150,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightBox(10.h),
              Row(
                children: [
                  const CircleAvatar(),
                  widthBox(5.w),
                  const Text('Title'),
                  widthBox(5.w),
                  Text(
                    '(40)',
                    style: mainStyle(context,12, color: mainBlueColor),
                  ),
                ],
              ),
              heightBox(15.h),
              const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet consectetur condimentum vivamus rutrum tristique.'),
              viewGroup
                  ? Column(
                      children: [
                        heightBox(20.h),
                        const Text('Group'),
                        heightBox(5.h),
                        SizedBox(
                          height: 44.h,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                radius: 22.h,
                              );
                            },
                            separatorBuilder: (ctx, index) => widthBox(5.w),
                            itemCount: 7,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              heightBox(5.h),
            ],
          ),
        ),
      ),
    );
  }
}
