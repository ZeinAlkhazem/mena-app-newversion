import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import '../feed_details.dart';
import 'icon_with_text.dart';

class FeedActionBar extends StatelessWidget {
  const FeedActionBar({
    Key? key,
    required this.menaFeed,
    required this.isMyFeed,
    this.alreadyInComments = false,
  }) : super(key: key);
  final MenaFeed menaFeed;
  final bool isMyFeed;
  final bool alreadyInComments;

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding:
          EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          feedsCubit.toggleLikeStatus(
                              feedId: menaFeed.id.toString(),
                              isLiked: menaFeed.isLiked);
                        },
                        child: IconWithText(
                          // text: menaFeed.likes.toString(),
                          // text: getFormattedNumberWithKandM(menaFeed.likes.toString()),
                          text: getFormattedNumberWithKandM(
                              menaFeed.likes.toString()),
                          customColor: menaFeed.isLiked ? mainBlueColor : null,
                          customSize: 18.sp,
                          svgAssetLink: menaFeed.isLiked
                              ? 'assets/svg/icons/like_solid.svg'
                              : 'assets/svg/icons/heart.svg',
                        ),
                      ),
                      widthBox(15.w),
                      GestureDetector(
                        onTap: () {
                          if (!alreadyInComments) {
                            navigateToWithoutNavBar(
                                context,
                                FeedDetailsLayout(menaFeed: menaFeed),
                                'routeName');
                          }
                        },
                        child: IconWithText(
                          text: getFormattedNumberWithKandM(
                              menaFeed.commentsCounter.toString()),
                          customSize: 18.sp,
                          svgAssetLink: 'assets/svg/icons/comments.svg',
                        ),
                      ),
                      widthBox(15.w),
                      IconWithText(
                        text: '167',
                        customSize: 18.sp,
                        svgAssetLink: 'assets/svg/icons/share_outline.svg',
                        customIconColor: newDarkGreyColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/icons/open_eye.svg',
                        color: newDarkGreyColor,
                      ),
                      widthBox(7.w),
                      Text(
                        '${menaFeed.views != null ? getFormattedNumberWithKandM(menaFeed.views!) : 0}',
                        style: mainStyle(context, 13,
                            color: newDarkGreyColor, weight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
              // heightBox(10.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 9),
              //   child: Text('${menaFeed.views ?? 0} views', style: mainStyle(context, 11, weight: FontWeight.w800)),
              // )
            ],
          ),
        );
      },
    );
  }
}
