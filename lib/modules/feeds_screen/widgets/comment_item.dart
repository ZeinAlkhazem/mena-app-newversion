
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';

class CommentItem extends StatelessWidget {
  const CommentItem(
      {Key? key,
        required this.menaFeedComment,
        required this.isMyFeed,
        // required this.isDetailed,
        required this.feedId})
      : super(key: key);
  final MenaFeedComment menaFeedComment;
  final bool isMyFeed;

  // final bool isDetailed;
  final String feedId;

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return menaFeedComment.user == null
        ? Text('Null user')
        : Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                    text:
                    '${menaFeedComment.user!.abbreviation != null ? menaFeedComment.user!.abbreviation!.name : ''} ',
                    style:
                    mainStyle(context, 12, weight: FontWeight.w800),
                    children: [
                      TextSpan(
                        text: '${menaFeedComment.user!.fullName}',
                        style: mainStyle(context, 12,
                            weight: FontWeight.w700,isBold: true),
                      ),
                      TextSpan(
                        text: ': ',
                        style: mainStyle(context, 12,
                            weight: FontWeight.w800),
                      ),
                      // if (isDetailed)
                      //   TextSpan(
                      //     text: '\n\n',
                      //     style: mainStyle(context, 12,
                      //         weight: FontWeight.w800),
                      //   ),
                      TextSpan(
                        text: menaFeedComment.comment,
                        style: mainStyle(context, 11,
                            weight: FontWeight.w400,color: Color(0xff252525)),
                      ),
                    ]),
              ),
            ),
            if (isMyFeed)
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
                                      commentId: menaFeedComment
                                          .id
                                          .toString(),
                                      feedId: feedId)
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
                      size: 18.sp,
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}