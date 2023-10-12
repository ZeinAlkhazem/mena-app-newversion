






import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../models/api_model/feeds_model.dart';
import 'detailed_comment_container.dart';

class CommentRepliesSection extends StatelessWidget {
  const CommentRepliesSection({
    Key? key,
    required this.menaFeedComment,
    required this.feedId,
    required this.isMyFeed,
  }) : super(key: key);

  final MenaFeedComment menaFeedComment;
  final String feedId;
  final bool isMyFeed;

  @override
  Widget build(BuildContext context) {
    return menaFeedComment.replies == null
        ? SizedBox()
        : menaFeedComment.replies!.isEmpty
        ? SizedBox()
        : Row(
      children: [
        widthBox(17.w),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    width: 1.0,
                    color: getTranslatedStrings(context)
                        .currentLanguageDirection ==
                        'ltr'
                        ? mainBlueColor
                        : Colors.transparent),
                right: BorderSide(
                    width: 1.0,
                    color: getTranslatedStrings(context)
                        .currentLanguageDirection !=
                        'ltr'
                        ? mainBlueColor
                        : Colors.transparent),
              ),
            ),
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) => Row(
                  children: [
                    widthBox(1),
                    Expanded(
                      child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DetailedCommentItem(
                              menaFeedComment:
                              menaFeedComment.replies![i],
                              isMyFeed: isMyFeed,
                              feedId: feedId,
                              isReplyNotComment: true,
                            ),
                          )),
                    ),
                  ],
                ),
                // separatorBuilder: (ctx, i) => Row(
                //   children: [
                //     widthBox(1),
                //     Expanded(
                //       child: Container(
                //           color: Colors.white,
                //         height: 10.h,
                //           ),
                //     ),
                //   ],
                // ),
                itemCount: menaFeedComment.replies!.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
