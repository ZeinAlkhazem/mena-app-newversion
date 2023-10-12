import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import '../feed_details.dart';
import '../feed_image_viewer.dart';
import '../feeds_screen.dart';
import 'feed_action_bar.dart';
import 'feed_comments.dart';
import 'feed_item_body.dart';
import 'feed_item_header.dart';

class FeedItemContainer extends StatelessWidget {
  const FeedItemContainer({
    Key? key,
    required this.menaFeed,
    this.customProviderFeedsId,
    required this.isMyFeed,
    required this.inPublicHomeFeeds,
    required this.index,
  }) : super(key: key);

  final MenaFeed menaFeed;
  final bool isMyFeed;
  final bool inPublicHomeFeeds;
  final String? customProviderFeedsId;
  final int index;

  /// this for update feeds after comment
  ///
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      // withoutRadius: true,
      radius: 15.sp,
      borderColor: Colors.transparent,
      backColor: feedsWhiteColor,
      childWidget: Padding(
        //todo remove padding
        padding: const EdgeInsets.all(8.0),
        child: menaFeed.user == null
            ? Center(child: Text('Missing user info'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeedItemHeader(
                    menaFeed: menaFeed,
                    isMyFeeds: menaFeed.isMine,
                    inPublicFeeds: inPublicHomeFeeds,
                  ),
                  heightBox(3.h),
                  GestureDetector(
                      onTap: () {
                          navigateToWithoutNavBar(context,
                              FeedDetailsLayout(menaFeed: menaFeed), '');
                      },
                      child: FeedItemBody(menaFeed: menaFeed)),
                  // heightBox(10.h),

                  Divider(),
                  FeedActionBar(
                    menaFeed: menaFeed,
                    isMyFeed: isMyFeed,
                  ),
                  heightBox(10.h),
                  FeedComments(
                    index: index,
                    menaFeed: menaFeed,
                    isMyFeed: isMyFeed,
                    customProviderFeedsId: customProviderFeedsId,
                  ),
                ],
              ),
      ),
    );
  }
}
