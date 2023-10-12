import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import 'icon_with_text.dart';

class MenaCommentActionBar extends StatefulWidget {
  const MenaCommentActionBar(
      {Key? key, required this.menaFeedComment, required this.feedId})
      : super(key: key);

  final MenaFeedComment menaFeedComment;
  final String feedId;

  @override
  State<MenaCommentActionBar> createState() => _MenaCommentActionBarState();
}

class _MenaCommentActionBarState extends State<MenaCommentActionBar> {
  bool replyVisibility = false;
  bool liking = false;
  bool disLiking = false;
  late FocusNode myFocusNode;
  TextEditingController replyInputController = TextEditingController();

  // late MenaFeedComment updatedComment;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    // updatedComment=widget.menaFeedComment;
    // myFocusNode.addListener(() {
    //
    // });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
        // if(state is){
        //
        // }
        // if(state is SuccessUpdatingCommentLikeState){
        //  updatedComment=state.menaFeedComment;
        // }
      },
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                // state is UpdatingCommentLikeState?DefaultLoaderGrey():
                GestureDetector(
                  onTap: () {
                    // liking=true;
                    widget.menaFeedComment.isDisLiked = false;
                    widget.menaFeedComment.isLiked = true;
                    feedsCubit.likeComment(
                      feedId: widget.feedId,
                      commentId: widget.menaFeedComment.id.toString(),
                      isLikeOrDislike: true,
                    );
                  },
                  child: IconWithText(
                    text: widget.menaFeedComment.likesCount,
                    customSize: 20.sp,
                    customFontSize: 11,
                    svgAssetLink: 'assets/svg/icons/like.svg',
                    customIconColor: (widget.menaFeedComment.isLiked)
                        ? mainBlueColor
                        : Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(
                    'assets/svg/icons/Linevertical.svg',
                    color: mainBlueColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // disLiking=true;
                    widget.menaFeedComment.isLiked = false;
                    widget.menaFeedComment.isDisLiked = true;
                    feedsCubit.likeComment(
                      feedId: widget.feedId,
                      commentId: widget.menaFeedComment.id.toString(),
                      isLikeOrDislike: false,
                    );
                  },
                  child: IconWithText(
                    text: widget.menaFeedComment.disLikesCount,
                    customSize: 20.sp,
                    customFontSize: 11,
                    svgAssetLink: 'assets/svg/icons/dislike.svg',
                    customIconColor: (widget.menaFeedComment.isDisLiked)
                        ? mainBlueColor
                        : Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(
                    'assets/svg/icons/Linevertical.svg',
                    color: mainBlueColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      replyVisibility = !replyVisibility;
                      if (replyVisibility) {
                        myFocusNode.requestFocus();
                      }
                    });
                  },
                  child: IconWithText(
                    text: 'Reply',
                    customSize: 20.sp,
                    customFontSize: 11,
                    svgAssetLink: 'assets/svg/icons/reply.svg',
                  ),
                ),
              ],
            ),
            heightBox(5.h),
            Visibility(
                visible: replyVisibility,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.0, color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            logg('Focus changed');
                            if (hasFocus) {
                              // do stuff
                              logg('Focus has');
                            } else {
                              if (replyInputController.text.isEmpty) {
                                setState(() {
                                  replyVisibility = false;
                                });
                              }
                            }
                          },
                          child: DefaultInputField(
                            focusedBorderColor: Colors.transparent,
                            focusNode: myFocusNode,
                            controller: replyInputController,
                            unFocusedBorderColor: Colors.transparent,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            feedsCubit
                                .commentOnFeed(
                                feedId: widget.feedId.toString(),
                                comment: replyInputController.text,
                                commentId:
                                widget.menaFeedComment.id.toString(),
                                customProviderFeedsId: null)
                                .then((value) {
                              replyInputController.text = '';
                              if (myFocusNode.hasFocus) {
                                myFocusNode.unfocus();
                              }
                              setState(() {
                                replyVisibility = false;
                              });
                            });
                          },
                          child: Container(
                              color: Colors.white,
                              height: 33.h,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 12),
                                child: Icon(
                                  Icons.send,
                                  color: mainBlueColor,
                                  size: 20.h,
                                ),
                              )))
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}
