import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import 'comment_action_bar_section.dart';
import 'comment_replies_section.dart';

class DetailedCommentItem extends StatefulWidget {
  const DetailedCommentItem(
      {Key? key,
        required this.menaFeedComment,
        required this.isMyFeed,
        this.isReplyNotComment = false,
        // required this.isDetailed,
        required this.feedId})
      : super(key: key);
  final MenaFeedComment menaFeedComment;
  final bool isMyFeed;
  final bool isReplyNotComment;

  // final bool isDetailed;
  final String feedId;

  @override
  State<DetailedCommentItem> createState() => _DetailedCommentItemState();
}

class _DetailedCommentItemState extends State<DetailedCommentItem> {
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return widget.menaFeedComment.user == null
        ? Text('Null user')
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileBubble(
              isOnline: false,
              pictureUrl: widget.menaFeedComment.user!.personalPicture,
              radius: 12.sp,
            ),
            widthBox(10.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 244.w),
                    child: Text(
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      '${widget.menaFeedComment.user!.abbreviation == null ? '' : widget.menaFeedComment.user!.abbreviation!.name} ${widget.menaFeedComment.user!.fullName}',
                      style: mainStyle(
                          context, widget.isReplyNotComment ? 10 : 12,
                          weight: FontWeight.w700),
                    ),
                  ),
                  (widget.menaFeedComment.user!.verified == '1')
                      ? Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.verified,
                      color: Color(0xff01BC62),
                      size:
                      widget.isReplyNotComment ? 14.sp : 16.sp,
                    ),
                  )
                      : SizedBox()
                ],
              ),
            ),
            if (widget.isMyFeed)
              GestureDetector(
                onTap: () {
                  showMyAlertDialog(context, 'Remove comment',
                      alertDialogContent: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Are you sure you want to remove this comment?',
                            style: mainStyle(context, 14,
                                color: mainBlueColor),
                          ),
                        ],
                      ),
                      actions: [
                        BlocConsumer<FeedsCubit, FeedsState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return state is DeletingFeedsState
                                ? LinearProgressIndicator()
                                : TextButton(
                                onPressed: () {
                                  feedsCubit
                                      .removeComment(
                                      commentId: widget
                                          .menaFeedComment.id
                                          .toString(),
                                      feedId: widget.feedId)
                                      .then((value) {
                                    // feedsCubit.getFeeds(
                                    //     providerId: isMyFeed
                                    //         ? feedId
                                    //         : null);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('Yes'));
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No')),
                      ]);
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: widget.isReplyNotComment ? 15.sp : 18.sp,
                    ),
                  ),
                ),
              )
          ],
        ),
        heightBox(4.h),
        Text(
          widget.menaFeedComment.comment,
          style: mainStyle(context, widget.isReplyNotComment ? 9 : 11,
              weight: FontWeight.w400,color: 
          Color(0xff252525)),
          textAlign: TextAlign.justify,
        ),
        heightBox(10.h),
        MenaCommentActionBar(
          menaFeedComment: widget.menaFeedComment,
          feedId: widget.feedId,
        ),
        CommentRepliesSection(
            menaFeedComment: widget.menaFeedComment,
            feedId: widget.feedId,
            isMyFeed: widget.isMyFeed),
      ],
    );
  }
}
