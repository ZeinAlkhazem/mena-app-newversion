import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/feeds_model.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/widgets/all_ccomment_section.dart';
import 'package:mena/modules/feeds_screen/widgets/feed_text_extended.dart';

import '../../core/constants/constants.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'feed_image_viewer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'widgets/feed_action_bar.dart';
import 'widgets/feed_item_header.dart';

class FeedDetailsLayout extends StatefulWidget {
  const FeedDetailsLayout(
      {Key? key, required this.menaFeed, this.customFileIndex})
      : super(key: key);

  final MenaFeed menaFeed;

  final int? customFileIndex;

  @override
  State<FeedDetailsLayout> createState() => _FeedDetailsLayoutState();
}

class _FeedDetailsLayoutState extends State<FeedDetailsLayout> {
  CarouselController carouselController = CarouselController();
  TextEditingController commentInputController = TextEditingController();
  bool hideSendButton = true;
  double inDy = 0;
  double lastDy = 0;

  IO.Socket? socket;

  late MenaFeed currentMenaFeed;

  @override
  void initState() {
    // TODO: implement initState
    commentInputController.text = '';
    currentMenaFeed = widget.menaFeed;
    socket = MainCubit.get(context).socket;

    socket?.emit('join-feed', [
      {'feed_id': '${widget.menaFeed.id}'},
    ]);
    logg('emitted.....');
    socket?.on('feed-update', (data) {
      logg('new feed socket: $jsonEncode($data)');
      // currentMenaFeed=MenaFeed.fromJson(data.value);
      setState(() {
        FeedsCubit.get(context).commentsModel!.data!.comments =
            List<MenaFeedComment>.from(data["data"]["feed"]["top_10_comments"]
                .map((x) => MenaFeedComment.fromJson(x)));
      });
      // messengerCubit
      //   ..fetchMyMessages()
      //   ..fetchOnlineUsers();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    socket?.emit('leave-feed', [
      {'feed_id': '${widget.menaFeed.id}'},
    ]);

    logg('emitted');
    socket?.off('feed-update');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return Scaffold(
        // appBar: AppBar(),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: DefaultBackTitleAppBar(
            title: getTranslatedStrings(context).back,
          ),
        ),
        body: BlocConsumer<FeedsCubit, FeedsState>(
          listener: (context, state) {
            // TODO: implement listener
            // if(state is SuccessAddingCommentState){
            //   currentMenaFeed=state.menaFeed;
            // }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Listener(
                      onPointerDown: (e) {
                        inDy = e.localPosition.dy;
                      },
                      onPointerUp: (event) {
                        lastDy = event.localPosition.dy;
                        logg('iny: ${inDy.toString()}');
                        logg('lastDy: ${lastDy.toString()}');
                        if (lastDy != inDy) {
                          logg('pointer moved');
                        } else {
                          logg('pointer not moved');
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.focusedChild?.unfocus();
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FeedItemHeader(
                                menaFeed: currentMenaFeed,
                                inPublicFeeds: false,
                                isMyFeeds: currentMenaFeed.isMine),
                          ),
                          if (currentMenaFeed.files != null)
                            if (currentMenaFeed.files!.isNotEmpty)
                              Container(
                                color: Colors.white,
                                height: 0.31.sh,
                                width: double.maxFinite,
                                child: CarouselSlider.builder(
                                  itemCount: currentMenaFeed.files!.length,
                                  carouselController: carouselController,
                                  itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) =>
                                      InkWell(
                                    onTap: () {
                                      if (currentMenaFeed
                                              .files![itemIndex].type ==
                                          'image') {
                                        navigateToWithoutNavBar(
                                            context,
                                            FeedImageViewer(
                                              /// item index - length of all non images indexes before this element
                                              customIndex: itemIndex -
                                                  currentMenaFeed.files!
                                                      .getRange(0, itemIndex)
                                                      .where((element) =>
                                                          element.type !=
                                                          'image')
                                                      .toList()
                                                      .length,

                                              menaFeed: currentMenaFeed,
                                              fromDetails: true,
                                            ),
                                            '');
                                      }
                                    },
                                    child: AttachmentHandlerAccordingTypeWidget(
                                      type: currentMenaFeed
                                          .files![itemIndex].type!,
                                      file: currentMenaFeed
                                          .files![itemIndex].path!,
                                      inFeedOrGalleryCarousel: true,
                                      comingFromDetails: true,
                                      menaFeed: currentMenaFeed,
                                    ),
                                  ),
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    reverse: false,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: false,
                                    viewportFraction:
                                        Responsive.isMobile(context) ? 1 : 1,
                                    aspectRatio: 1,
                                    initialPage: widget.customFileIndex == null
                                        ? 0
                                        : widget.customFileIndex!,
                                    scrollPhysics: ClampingScrollPhysics(),
                                  ),
                                ),
                              ),
                          // heightBox(5.h),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FeedActionBar(
                              menaFeed: currentMenaFeed,
                              isMyFeed: currentMenaFeed.isMine,
                              alreadyInComments: true,
                            ),
                          ),
                          // heightBox(5.h),
                          if (currentMenaFeed.text != null)
                            if (currentMenaFeed.text!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultHorizontalPadding,
                                    vertical: defaultHorizontalPadding / 2),
                                child: FeedTextExtended(
                                    text: currentMenaFeed.text!,
                                    maxLines: (currentMenaFeed.files != null &&
                                            currentMenaFeed.files!.isNotEmpty)
                                        ? 2
                                        : 10),
                              ),
                          Divider(),
                          AllCommentsSection(
                            menaFeed: currentMenaFeed,
                            isMyFeed: currentMenaFeed.isMine,
                            canComment: currentMenaFeed.canComment == 1,
                          ),
                          // FeedsAllComments(menaFeed:currentMenaFeed),
                        ],
                      ),
                    ),
                  ),
                ),
                if (currentMenaFeed.canComment == 1 &&
                    MainCubit.get(context).userInfoModel != null)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                                    // labelWidget: Text(
                                    //   getTranslatedStrings(context).addComment,
                                    //   style: mainStyle(context, 11, color: softGreyColor),
                                    // ),
                                    label: getTranslatedStrings(context)
                                        .addComment,
                                    labelTextStyle: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w400),
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
                                                currentMenaFeed.id.toString(),
                                            comment:
                                                commentInputController.text,
                                            customProviderFeedsId: null)
                                        .then((value) {
                                      setState(() {
                                        commentInputController.text = '';
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
                                          size: 20.h,
                                        ),
                                      )))
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ));
  }
}
