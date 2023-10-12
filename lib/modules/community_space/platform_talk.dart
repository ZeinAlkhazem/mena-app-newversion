import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';

import '../../core/shared_widgets/shared_widgets.dart';
import '../feeds_screen/widgets/follow_user_button.dart';

class PlatformTalkLayout extends StatelessWidget {
  const PlatformTalkLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Platform talk',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              heightBox(22.h),
              const CommunityFeaturedVideos(),
              const CommunityTopSpeakers(),
              const CommunitySpecialities(),
              const CommunitySeries(),
              const ContinueWatching(),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityTopSpeakers extends StatelessWidget {
  const CommunityTopSpeakers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightBox(7.h),
        const GroupHeader(
          title: 'Top speakers',
        ),
        heightBox(7.h),
        SizedBox(
          height: 0.10.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
              children: const [
                ProfileBubble(isOnline: true),
                Text('Name'),
              ],
            ),
            separatorBuilder: (context, index) => widthBox(7.w),
            itemCount: 8,
          ),
        ),
        heightBox(7.h),
      ],
    );
  }
}

class CommunityFeaturedVideos extends StatelessWidget {
  const CommunityFeaturedVideos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroupHeader(
          title: 'Featured videos',
        ),
        SizedBox(
          height: 0.22.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => const FeaturedVideoItem(),
            separatorBuilder: (context, index) => widthBox(1.w),
            itemCount: 8,
          ),
        ),
      ],
    );

    ///
  }
}

class CommunitySpecialities extends StatelessWidget {
  const CommunitySpecialities({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroupHeader(
          title: 'Community Specialities',
        ),
        SizedBox(
          height: 0.22.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => const FeaturedVideoItem(),
            separatorBuilder: (context, index) => widthBox(1.w),
            itemCount: 8,
          ),
        ),
      ],
    );
  }
}

class CommunitySeries extends StatelessWidget {
  const CommunitySeries({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroupHeader(
          title: 'Community Series',
        ),
        SizedBox(
          height: 0.22.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => const FeaturedVideoItem(),
            separatorBuilder: (context, index) => widthBox(1.w),
            itemCount: 8,
          ),
        ),
      ],
    );
  }
}

class ContinueWatching extends StatelessWidget {
  const ContinueWatching({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroupHeader(
          title: 'Continue watching',
        ),
        SizedBox(
          height: 0.22.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => const FeaturedVideoItem(),
            separatorBuilder: (context, index) => widthBox(1.w),
            itemCount: 8,
          ),
        ),
      ],
    );
  }
}

class FeaturedVideoItem extends StatelessWidget {
  const FeaturedVideoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0.sp),
      child: DefaultShadowedContainer(
        width: 0.6.sw,
      ),
    );
  }
}

class GroupHeader extends StatelessWidget {
  const GroupHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  ///
  /// test this before we go
  ///

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: mainStyle(context, 14, weight: FontWeight.w600),
        ),
        const DefaultSoftButton(),
      ],
    );
  }
}
