import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../core/constants/constants.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/feeds_model.dart';

class VideosViewOrScrollLayout extends StatefulWidget {
  const VideosViewOrScrollLayout({
    Key? key,
    required this.initialVideoLink,
    required this.comingFromDetails,
    // this.onlyVideoNoScroll = false,
    this.menaFeed,
  }) : super(key: key);

  final String initialVideoLink;

  // final bool onlyVideoNoScroll;
  final MenaFeed? menaFeed;
  final bool comingFromDetails;

  @override
  State<VideosViewOrScrollLayout> createState() => _VideosViewOrScrollLayoutState();
}

class _VideosViewOrScrollLayoutState extends State<VideosViewOrScrollLayout> {
  PreloadPageController controller = PreloadPageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.menaFeed != null) {
      FeedsCubit.get(context).getFeedsVideos();
    }

    controller.addListener(() {
      if (controller.page?.toInt() ==
          FeedsCubit.get(context).feedsVideosList.length - 3) {
        print('etyrtyrtyrtyrtyrtyrtyrt');
        print(controller.page);
        if (FeedsCubit.get(context).state is! GettingFeedsVideosState &&
            FeedsCubit.get(context).feedsVideosModel!.data.totalSize >
                FeedsCubit.get(context).feedsVideosList.length ) {
          FeedsCubit.get(context).getFeedsVideos();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return Scaffold(
      backgroundColor: newDarkGreyColor,
      extendBodyBehindAppBar: true,
      appBar: defaultVideoOnlyBackAppBar(context, title: 'back', customColor: Colors.white),
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: widget.menaFeed == null

                    /// so not in feeds may in chat so just view without interaction
                    ? FullScreenVideoContainer(
                        videoLink: widget.initialVideoLink,
                        autoplay: true,
                  comingFromDetails: widget.comingFromDetails,
                        customFit: BoxFit.contain,
                      )
                    : PreloadPageView.builder(
                        controller: controller,
                        itemBuilder: (context, index) => Container(
                          // color: Colors.red,
                          child: Center(
                            child: FullScreenVideoContainer(
                              videoLink: feedsCubit.feedsVideosModel == null
                                  ? widget.initialVideoLink
                                  : feedsCubit.feedsVideosList[index].files![0].path!,
                              autoplay: true,
                              comingFromDetails: widget.comingFromDetails,
                              inPreLoader: true,
                              user: feedsCubit.feedsVideosModel == null
                                  ? widget.menaFeed!.user
                                  : feedsCubit.feedsVideosList[index].user,
                              menaFeed: feedsCubit.feedsVideosModel == null
                                  ? widget.menaFeed
                                  : feedsCubit.feedsVideosList[index],
                              customFit: BoxFit.contain,
                            ),
                          ),
                        ),
                        reverse: false,
                        preloadPagesCount: 2,
                        // onPageChanged: (){
                        //   flic
                        // },
                        itemCount:
                            /// only one video not scroll
                            feedsCubit.feedsVideosModel == null ? 1 : feedsCubit.feedsVideosList.length,
                        // currentVideoPlaylist.length,
                        scrollDirection: Axis.vertical,
                      ),
              ),
              state is GettingFeedsVideosState ? Text('Loading(this msg for test purpose) ') : SizedBox()
            ],
          );
        },
      ),

      // PageView.builder(
      //   itemBuilder: (context, index) => Container(
      //     // color: Colors.red,
      //     child: Center(
      //       child: FeedScrollVideoContainer(
      //         videoLink: initialVideoLink,
      //         autoplay: true,
      //         customFit: BoxFit.contain,
      //       ),
      //     ),
      //   ),
      //   itemCount:
      //   /// only one video not scroll
      //   onlyVideoNoScroll?1:feedsCubit.currentVideoPlaylist.length,
      //   scrollDirection: Axis.vertical,
      // ),
    );
  }
}
