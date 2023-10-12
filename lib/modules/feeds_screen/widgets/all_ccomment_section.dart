
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import '../feeds_screen.dart';
import 'detailed_comment_container.dart';

class AllCommentsSection extends StatefulWidget {
  const AllCommentsSection({
    Key? key,
    required this.menaFeed,
    required this.isMyFeed,
    required this.canComment,
  }) : super(key: key);
  final MenaFeed menaFeed;
  final bool isMyFeed;
  final bool canComment;

  @override
  State<AllCommentsSection> createState() => _AllCommentsSectionState();
}

class _AllCommentsSectionState extends State<AllCommentsSection> {
  @override
  void initState() {
    // TODO: implement initState
    FeedsCubit.get(context).resetCommentsModelToInitialLayout();
    logg('getting comments on init state');
    FeedsCubit.get(context).getComments(feedId: widget.menaFeed.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Column(
          children: [
            if (state is GettingCommentsState || state is AddingCommentState)
              LinearProgressIndicator(minHeight: 1),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: DefaultContainer(
                //     backColor: Colors.black,
                //     borderColor: Colors.black,
                //     height: 6,
                //     width: 0.2.sw,
                //   ),
                // ),
                feedsCubit.commentsModel == null
                    ? DefaultLoaderGrey()
                    : feedsCubit.commentsModel!.data!.comments!.isEmpty
                    ?
                // FeedsEmptyLayout(isMyFeed:widget.isMyFeed)
                Column(
                  children: [
                    Lottie.asset('assets/json/empt_comments.json'),
                    Text(
                      getTranslatedStrings(context).noCommentsHere,
                      style: mainStyle(
                        context,
                        14,
                        color: newDarkGreyColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    heightBox(7.h),
                    Text(
                        getTranslatedStrings(context)
                            .postReceivedNoComments,
                        style: mainStyle(
                          context,
                          14,
                          color: newDarkGreyColor,
                        )),
                  ],
                )
                    : Column(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.all(
                          defaultHorizontalPadding / 3),
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return DefaultContainer(
                          borderColor: Colors.transparent,
                          backColor: Colors.transparent,
                          childWidget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DetailedCommentItem(
                              menaFeedComment: feedsCubit
                                  .commentsModel!
                                  .data!
                                  .comments![index],
                              isMyFeed: widget.isMyFeed,
                              feedId: widget.menaFeed.id.toString(),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, i) => Divider(),
                      itemCount: feedsCubit
                          .commentsModel!.data!.comments!.length,
                    ),
                  ],
                ),

                // heightBox(10.h),
              ],
            ),
          ],
        );
      },
    );
  }
}