import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import '../feed_details.dart';
import '../feeds_screen.dart';
import 'comment_item.dart';

class CommentsContainer extends StatefulWidget {
  const CommentsContainer({
    Key? key,
    required this.index,
    required this.viewAll,
    required this.isMyFeed,
    required this.menaFeed,
    this.customProviderFeedsId,
  }) : super(key: key);
  final bool isMyFeed;
  final bool viewAll;
  final MenaFeed menaFeed;
  final String? customProviderFeedsId;
  final int index;

  @override
  State<CommentsContainer> createState() => _CommentsContainerState();
}

class _CommentsContainerState extends State<CommentsContainer> {
  /// this for update feeds after comment
  TextEditingController commentInputController = TextEditingController();

  bool hideSendButton = true;
  late MenaFeed menaFeed;

  @override
  void initState() {
    // TODO: implement initState
    menaFeed = widget.menaFeed;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CommentsContainer oldWidget) {
    if (oldWidget.index == widget.index) {
      setState(() {
        menaFeed = widget.customProviderFeedsId == null
            ? FeedsCubit.get(context).menaFeedsList[widget.index]
            : FeedsCubit.get(context).menaProviderFeedsList[widget.index];
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SuccessAddingCommentState) {
          logg('sjdkgaskjhdjkashkjdhs');
          if (widget.menaFeed.id == state.menaFeed.id) {
            setState(() {
              commentInputController.text = '';
              menaFeed = state.menaFeed;
            });
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                ///
                ///
                /// Todo: test
                ///
                ///
                ///
                ///
                menaFeed.top10Comments == null
                    ? SizedBox()
                    : menaFeed.top10Comments!.isEmpty
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => CommentItem(
                                  menaFeedComment:
                                      menaFeed.top10Comments![index]!,
                                  isMyFeed: widget.isMyFeed,
                                  feedId: menaFeed.id.toString(),
                                  // isDetailed: false,
                                ),
                                separatorBuilder: (_, i) => heightBox(4.h),
                                itemCount: menaFeed.top10Comments!.length,
                              ),
                              heightBox(8.h),
                            ],
                          ),
                if (menaFeed.commentsCounter > 1)
                  GestureDetector(
                    onTap: () {
                      navigateToWithoutNavBar(context,
                          FeedDetailsLayout(menaFeed: menaFeed), 'routeName');
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${getTranslatedStrings(context).viewAll} ${menaFeed.commentsCounter.toString()} ${getTranslatedStrings(context).comments}',
                          style:
                              mainStyle(context, 12, weight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                (menaFeed.canComment == 1 &&
                        MainCubit.get(context).userInfoModel != null)
                    ? Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ProfileBubble(
                                  isOnline: false,
                                  radius: 14.h,
                                  pictureUrl: MainCubit.get(context)
                                      .userInfoModel!
                                      .data
                                      .user
                                      .personalPicture,
                                ),
                                widthBox(5.w),
                                Expanded(
                                  child: DefaultInputField(
                                    controller: commentInputController,
                                    maxLines: 3,
                                    unFocusedBorderColor: Colors.transparent,
                                    onFieldChanged: (text) {
                                      if (text.isNotEmpty && hideSendButton) {
                                        setState(() {
                                          hideSendButton = false;
                                        });
                                      } else if (text.isEmpty &&
                                          !hideSendButton) {
                                        setState(() {
                                          hideSendButton = true;
                                        });
                                      }
                                    },
                                    // label: 'Add',
                                    label: getTranslatedStrings(context)
                                        .addComment,
                                    labelTextStyle: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w400),
                                    // labelWidget: Text(
                                    //   getTranslatedStrings(context).addComment,
                                    //   style: mainStyle(context, 11, color: softGreyColor),
                                    // ),
                                    focusedBorderColor: Colors.transparent,
                                    edgeInsetsGeometry: EdgeInsets.symmetric(
                                        vertical: Responsive.isMobile(context)
                                            ? 10
                                            : 15.0,
                                        horizontal: 10.0),
                                  ),
                                )
                                // Expanded(
                                //   child: DefaultInputField(controller: commentInputController,
                                //   maxLines: 3,
                                //
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          hideSendButton
                              ? Container(
                                  height: 33.h,
                                  width: 20,
                                  color: Colors.white,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    feedsCubit
                                        .commentOnFeed(
                                            feedId:
                                                widget.menaFeed.id.toString(),
                                            comment:
                                                commentInputController.text,
                                            customProviderFeedsId:
                                                widget.customProviderFeedsId)
                                        .then((value) {
                                      commentInputController.text = '';
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
                                        size: 20.h,
                                      ),
                                    ),
                                  ),
                                ),

                          ///
                          ///
                          ///
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
