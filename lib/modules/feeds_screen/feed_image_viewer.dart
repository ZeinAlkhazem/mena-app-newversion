import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/feeds_model.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../core/constants/constants.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'feed_details.dart';
import 'widgets/icon_with_text.dart';

class FeedImageViewer extends StatefulWidget {
  const FeedImageViewer({
    Key? key,
    this.customIndex = 0,
    required this.menaFeed,
    required this.fromDetails
  }) : super(key: key);

  // final String imageLink;
  final int customIndex;
  final MenaFeed menaFeed;
  final bool fromDetails;
  @override
  State<FeedImageViewer> createState() => _FeedImageViewerState();
}

class _FeedImageViewerState extends State<FeedImageViewer> {
  PreloadPageController carouselController = PreloadPageController(
  );
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentIndex = widget.customIndex;

    carouselController = PreloadPageController(
    initialPage: currentIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: defaultVideoOnlyBackAppBar(context,
          title:
              '${(currentIndex + 1).toString()} of ${widget.menaFeed.files!.where((element) => element.type == 'image').toList().length}',
          customColor: Colors.white),
      body: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            child: PreloadPageView.builder(
              itemCount: widget.menaFeed.files!.where((element) => element.type == 'image').toList().length,
              controller: carouselController,
              itemBuilder: (BuildContext context, int itemIndex, ) => PhotoViewWithZoomContainer(
                  picture:
                      widget.menaFeed.files!.where((element) => element.type == 'image').toList()[itemIndex].path!),
              preloadPagesCount: 2,
            onPageChanged: (index){
                  setState(() {
                    currentIndex = index;
                  });
            },
              physics:   ClampingScrollPhysics(),
              // options: CarouselOptions(
              //   autoPlay: false,
              //   reverse: false,
              //   enableInfiniteScroll: false,
              //   enlargeCenterPage: false,
              //   viewportFraction: Responsive.isMobile(context) ? 1 : 1,
              //   aspectRatio: 1,
              //   initialPage: currentIndex,
              //   onPageChanged: (index, reason) {
              //     setState(() {
              //       currentIndex = index;
              //     });
              //   },
              //   scrollPhysics: ClampingScrollPhysics(),
              // ),
            ),
          ),

          // Align(alignment: Alignment.bottomRight, child: VideoFeedSideActionBar()),
          Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: BlocConsumer<FeedsCubit, FeedsState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Container(
                      height: 55.h,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              feedsCubit.toggleLikeStatus(
                                  feedId: widget.menaFeed.id.toString(), isLiked: widget.menaFeed.isLiked);
                            },
                            child: IconWithText(
                              // text: menaFeed.likes.toString(),
                              // text: getFormattedNumberWithKandM(menaFeed.likes.toString()),
                              text: getFormattedNumberWithKandM(widget.menaFeed.likes.toString()),
                              customColor: widget.menaFeed.isLiked ? mainBlueColor : null,
                              customSize: 18.sp,
                              inGallery: true,

                              svgAssetLink: widget.menaFeed.isLiked
                                  ? 'assets/svg/icons/like_solid.svg'
                                  : 'assets/svg/icons/heart.svg',
                            ),
                          ),
                          widthBox(15.w),
                          GestureDetector(
                            onTap: () {
                              if(widget.fromDetails)
                              Navigator.pop(context);
                              else{
                                navigateToWithoutNavBar(
                                    context,
                                    FeedDetailsLayout(menaFeed: widget.menaFeed),
                                    'routeName');
                              }
                              /// because coming from details screen already
                            },
                            child: IconWithText(
                              text: getFormattedNumberWithKandM(widget.menaFeed.commentsCounter.toString()),
                              customSize: 18.sp,
                              inGallery: true,
                              svgAssetLink: 'assets/svg/icons/comments.svg',
                            ),
                          ),
                          widthBox(15.w),
                          IconWithText(
                            text: '167',
                            customSize: 18.sp,
                            inGallery: true,
                            svgAssetLink: 'assets/svg/icons/share_outline.svg',
                            customIconColor: Colors.white,
                          ),
                          // Row(
                          //   children: [
                          //     SvgPicture.asset(
                          //       'assets/svg/icons/loveHeart.svg',
                          //       color: Colors.white,
                          //     ),
                          //     widthBox(5.w),
                          //     Text(
                          //       widget.menaFeed.likes.toString(),
                          //       style: mainStyle(context, 14, color: Colors.white),
                          //     ),
                          //   ],
                          // ),
                          // SvgPicture.asset(
                          //   'assets/svg/icons/comments.svg',
                          //   color: Colors.white,
                          // ),
                          // SvgPicture.asset(
                          //   'assets/svg/icons/share.svg',
                          //   color: Colors.white,
                          // )
                        ],
                      ),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
