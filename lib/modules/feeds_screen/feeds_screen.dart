import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/widgets/feed_item.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import 'widgets/newWidgets/content_app_bar.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key,
    this.inHome = false,
    required this.isMyFeeds,
    this.providerId,
    required this.user})
      : super(key: key);
  final bool inHome;
  final bool isMyFeeds;

  final String? providerId;

  final User? user;

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final feedsScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.providerId == null) FeedsCubit.get(context).resetFeedModel();
    print('111111111111111');
    FeedsCubit.get(context).getFeeds(providerId: widget.providerId);
    feedsScrollController.addListener(() {
      if (feedsScrollController.position.pixels >=
          feedsScrollController.position.maxScrollExtent / 2) {
        if (FeedsCubit
            .get(context)
            .state is! GettingFeedsState &&
            FeedsCubit
                .get(context)
                .feedsModel!
                .data
                .totalSize >
                FeedsCubit
                    .get(context)
                    .menaFeedsList
                    .length &&
            widget.providerId == null) {
          FeedsCubit.get(context).getFeeds();
        } else if (FeedsCubit
            .get(context)
            .state is! GettingFeedsState &&
            FeedsCubit
                .get(context)
                .feedsModel!
                .data
                .totalSize >
                FeedsCubit
                    .get(context)
                    .menaProviderFeedsList
                    .length &&
            widget.providerId != null) {
          FeedsCubit.get(context).getFeeds(providerId: widget.providerId);
        }
      }
    });
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    FeedsCubit
        .get(context)
        .menaFeedsListOffset = 1;
    FeedsCubit
        .get(context)
        .menaFeedsList
        .clear();

    FeedsCubit
        .get(context)
        .menaProviderFeedsListOffset = 1;
    FeedsCubit
        .get(context)
        .menaProviderFeedsList
        .clear();
    FeedsCubit.get(context)
        .getFeeds(providerId: widget.providerId)
        .then((value) => _refreshController.refreshCompleted());
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  void didChangeDependencies() {
    if (FeedsCubit
        .get(context)
        .state is! GettingFeedsState) {
      if (widget.providerId != null) {
        FeedsCubit.get(context).resetFeedProviderModel();
      } else
        FeedsCubit.get(context).resetFeedModel();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // FeedsCubit.get(context).resetFeedModel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButton: (getCachedToken() != null &&
      //         (MainCubit.get(context).isUserProvider() &&
      //             (widget.isMyFeeds || widget.inHome)))
      //     ? Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           FloatingActionButton.extended(
      //             onPressed: () {
      //               navigateToWithoutNavBar(context, PostAFeedLayout(), '');
      //             },
      //             isExtended: true,
      //             label: Text(
      //               getTranslatedStrings(context).addPost,
      //               style: mainStyle(context, 13,
      //                   color: Colors.white, weight: FontWeight.w700),
      //             ),
      //             backgroundColor: mainBlueColor,
      //           ),
      //           // heightBox(widget.inHome ? 55.h : 10.h)
      //         ],
      //       )
      //     : SizedBox(),
      appBar: ContentAppBar(),
      // widget.inHome
      //     ? null
      //     : PreferredSize(
      //         preferredSize: Size.fromHeight(56.0.h),
      //         child: const DefaultOnlyLogoAppbar(
      //           withBack: true,
      //           logo: "assets/svg/mena_feed.svg",
      //         ),
      //       ),
      drawerScrimColor: Colors.grey.withOpacity(0.2),
      backgroundColor: Colors.white,
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          double inDy = 0;
          double lastDy = 0;
          return Padding(
            padding: widget.inHome
                ? EdgeInsets.only(bottom: rainBowBarBottomPadding(context))
                : EdgeInsets.all(0),
            child: MainBackground(
              hideRainbow: widget.inHome ? false : true,
              customColor: feedsCubit.feedsModel == null
                  ? Colors.white
                  : (widget.inHome &&

                  /// for empty background should be white so:
                  feedsCubit.feedsModel!.data.feeds!.isNotEmpty)
                  ? Color(0xfff4f4f4)
                  : Colors.white,
              bodyWidget: SafeArea(
                // safe area
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: rainBowBarHeight, //rainbow height
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Color(0xffdfe4e4)),
                      Expanded(
                          child:
                          (state is GettingFeedsState &&
                              feedsCubit.feedsModel == null)

                          /// getting first time
                          /// because next time will pop to refresh
                              ? Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              color: Colors.white,
                              child: Center(child: DefaultLoaderGrey()))
                              : feedsCubit.feedsModel == null
                              ? SizedBox()
                              : (feedsCubit.menaFeedsList.isEmpty &&
                              state is! GettingFeedsState &&
                              widget.providerId == null) ||
                              (feedsCubit.menaProviderFeedsList
                                  .isEmpty &&
                                  state is! GettingFeedsState &&
                                  widget.providerId != null)
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              FeedsEmptyLayout(
                                  isMyFeed: widget.isMyFeeds),
                            ],
                          )
                          // EmptyListLayout()
                          /// not empty feeds
                              : Listener(
                            onPointerDown: (e) {
                              inDy = e.localPosition.dy;
                            },
                            onPointerUp: (event) {
                              lastDy = event.localPosition.dy;
                              logg('iny: ${inDy.toString()}');
                              logg(
                                  'lastDy: ${lastDy.toString()}');
                              if (lastDy != inDy) {
                                logg('pointer moved');
                              } else {
                                logg('pointer not moved');
                                FocusScopeNode currentFocus =
                                FocusScope.of(context);
                                if (!currentFocus
                                    .hasPrimaryFocus) {
                                  currentFocus.focusedChild
                                      ?.unfocus();
                                }
                              }
                            },
                            child: SmartRefresher(
                              scrollController:
                              feedsScrollController,
                              controller: _refreshController,
                              enablePullDown: true,
                              // enablePullUp: true,
                              // header: WaterDropHeader(),
                              // footer: CustomFooter(
                              //   builder: (BuildContext context,LoadStatus mode){
                              //     Widget body ;
                              //     if(mode==LoadStatus.idle){
                              //       body =  Text("pull up load");
                              //     }
                              //     else if(mode==LoadStatus.loading){
                              //       body =  CupertinoActivityIndicator();
                              //     }
                              //     else if(mode == LoadStatus.failed){
                              //       body = Text("Load Failed!Click retry!");
                              //     }
                              //     else if(mode == LoadStatus.canLoading){
                              //       body = Text("release to load more");
                              //     }
                              //     else{
                              //       body = Text("No more Data");
                              //     }
                              //     return Container(
                              //       height: 55.0,
                              //       child: Center(child:body),
                              //     );
                              //   },
                              // ),
                              onRefresh: _onRefresh,
                              // onLoading: _onLoading,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    widget.inHome
                                        ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .white,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(15
                                                    .sp),
                                                bottomRight:
                                                Radius.circular(
                                                    15.sp))),
                                        height: 174.h,
                                        child: Padding(
                                          padding:
                                          EdgeInsets.all(
                                              defaultHorizontalPadding),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(
                                                height:
                                                35.h,
                                                child: ListView.builder(
                                                    scrollDirection: Axis
                                                        .horizontal,
                                                    itemCount: feedsCubit
                                                        .categories.length,
                                                    itemBuilder: (context,
                                                        index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          feedsCubit
                                                              .selectCategory(
                                                              index);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: feedsCubit
                                                                          .categoryId ==
                                                                          index
                                                                          ? Colors
                                                                          .blue
                                                                          : Colors
                                                                          .grey
                                                                          .shade300,
                                                                      width: 2))),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.h,
                                                                horizontal: 20
                                                                    .w),
                                                            child: Text(
                                                              feedsCubit
                                                                  .categories[index],
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                color: feedsCubit
                                                                    .categoryId ==
                                                                    index
                                                                    ? Color(
                                                                    0xFF202226)
                                                                    : Color(
                                                                    0xFF999B9D),
                                                                fontSize: 15,
                                                                fontFamily: 'Inter',
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              heightBox(
                                                  10.h),

                                              feedsCubit.categoryId ==
                                                  0
                                                  ? SizedBox(
                                                height:
                                                100.h,
                                                child:
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(right: 8.0),
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (
                                                                      context) =>
                                                                      AlertDialog(
                                                                        title: Center(
                                                                            child: Text(
                                                                              "Video Or Image",
                                                                            )),
                                                                        content: Container(
                                                                          height: 90,
                                                                          child: Center(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .center,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    // var video = await FilePicker.platform.pickFiles(type: FileType.video);
                                                                                    // // VESDK.unlockWithLicense("assets/vesdk_license");
                                                                                    // var ed = await VESDK.openEditor(Video(video!.files[0].path!));
                                                                                    // feedsCubit.addStory(StoryItem(
                                                                                    //   url: ed!.video,
                                                                                    //   type: StoryItemType.video,
                                                                                    //   duration: 20,
                                                                                    // ));
                                                                                    // Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        8.0),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons
                                                                                              .video_library_outlined,
                                                                                          color: Colors
                                                                                              .blue,
                                                                                          size: 30,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .all(
                                                                                              8.0),
                                                                                          child: Text(
                                                                                              "Video",
                                                                                              style: TextStyle(
                                                                                                  color: Colors
                                                                                                      .blue)),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    //  var video = await FilePicker.platform.pickFiles(type: FileType.image);
                                                                                    // // VESDK.unlockWithLicense("assets/vesdk_license");
                                                                                    // var ed = await PESDK.openEditor(image:video!.files[0].path!);
                                                                                    // feedsCubit.addStory(StoryItem(
                                                                                    //   url: ed!.image,
                                                                                    //   type: StoryItemType.image,
                                                                                    //   duration: 5,
                                                                                    // ));
                                                                                    // // await pushNewScreen(
                                                                                    // //   context,
                                                                                    // //   screen: StoriesEditor(
                                                                                    // //     onDoneButtonStyle: Container(decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8),),child: Center(child: Padding(
                                                                                    // //       padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 8),
                                                                                    // //       child: Text("SHARE",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w700) ,),
                                                                                    // //     )),),
                                                                                    // //     middleBottomWidget: const Text("MenaAI"),
                                                                                    // //     onDone: (uri) {
                                                                                    // //       feedsCubit.addStory(StoryItem(
                                                                                    // //         url: uri,
                                                                                    // //         type: StoryItemType.image,
                                                                                    // //         duration: 3,
                                                                                    // //       ));
                                                                                    // //       Navigator.pop(context);
                                                                                    // //     },
                                                                                    // //     giphyKey: 'C4dMA7Q19nqEGdpfj82T8ssbOeZIylD4',
                                                                                    // //   ),
                                                                                    // //   // withNavBar: false
                                                                                    // // );
                                                                                    // // Timer(Duration(milliseconds: 600), () {
                                                                                    // //   Get.forceAppUpdate();
                                                                                    // // });
                                                                                    // Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        8.0),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons
                                                                                              .image_outlined,
                                                                                          color: Colors
                                                                                              .blue,
                                                                                          size: 30,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets
                                                                                              .all(
                                                                                              8.0),
                                                                                          child: Text(
                                                                                              "Image",
                                                                                              style: TextStyle(
                                                                                                  color: Colors
                                                                                                      .blue)),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ));
                                                              //   var video = await FilePicker.platform.pickFiles(type: FileType.video);
                                                              //   // VESDK.unlockWithLicense("assets/vesdk_license");
                                                              //  var ed= await VESDK.openEditor(Video(video!.files[0].path!));
                                                              //          feedsCubit.addStory(StoryItem(
                                                              //           url: ed!.video,
                                                              //           type: StoryItemType.video,
                                                              //           duration: 3,
                                                              //         ));

                                                              // await pushNewScreen(
                                                              //   context,
                                                              //   screen: StoriesEditor(
                                                              //     middleBottomWidget: const Text("MenaAI"),
                                                              //     onDone: (uri) {
                                                              //       feedsCubit.addStory(StoryItem(
                                                              //         url: uri,
                                                              //         type: StoryItemType.image,
                                                              //         duration: 3,
                                                              //       ));
                                                              //       Navigator.pop(context);
                                                              //     },
                                                              //     giphyKey: 'C4dMA7Q19nqEGdpfj82T8ssbOeZIylD4',
                                                              //   ),
                                                              //   // withNavBar: false
                                                              // );
                                                              // Timer(Duration(milliseconds: 900), () {
                                                              //   Get.forceAppUpdate();
                                                              // });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  width: 77,
                                                                  height: 77,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade100,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border
                                                                          .all(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(
                                                                              .25))),
                                                                  child: Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    bottom: 0,
                                                                    right: 0,
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Colors
                                                                              .blue),
                                                                      child: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(top: 8.0),
                                                          child: Text(
                                                            "My Story",
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    // Expanded(
                                                    //   child: ListView.separated(
                                                    //     // shrinkWrap: true,
                                                    //     scrollDirection: Axis.horizontal,
                                                    //     itemBuilder: (
                                                    //       context,
                                                    //       index,
                                                    //     ) =>
                                                    //         GestureDetector(
                                                    //       onTap: () async {
                                                    //         // pushNewScreen(
                                                    //         //   context,
                                                    //         //   screen: FlutterStoryView(
                                                    //         //     userInfo: UserInfo(username: "majd", profileUrl: "https://images.alwatanvoice.com/news/images/3910365359.jpg"),
                                                    //         //     onComplete: () {
                                                    //         //       Navigator.pop(context);
                                                    //         //     },
                                                    //         //     onPageChanged: (int) {
                                                    //         //       print("currentPageIndex = $index");
                                                    //         //     },
                                                    //         //     storyItems: feedsCubit.stories,
                                                    //         //   ),
                                                    //         // );
                                                    //         //  Container(
                                                    //         //       height: MediaQuery.of(context).size.height,
                                                    //         //       child: StoryView(
                                                    //         //           storyItems: feedsCubit.stories,
                                                    //         //           controller: StoryController(), // pass controller here too
                                                    //         //           repeat: true, // should the stories be slid forever
                                                    //         //           onStoryShow: (s) {
                                                    //         //             // notifyServer(s)
                                                    //         //           },
                                                    //         //           onComplete: () {
                                                    //         //             Navigator.pop(context);
                                                    //         //           },
                                                    //         //           onVerticalSwipeComplete: (direction) {
                                                    //         //             if (direction == Direction.down) {
                                                    //         //               Navigator.pop(context);
                                                    //         //             }
                                                    //         //           } // To disable vertical swipe gestures, ignore this parameter.
                                                    //         //           // Preferrably for inline story view.
                                                    //         //           ),
                                                    //         //     )
                                                    //       },
                                                    //       child: Column(
                                                    //         children: [
                                                    //           ClipOval(
                                                    //             child: Container(
                                                    //               width: 77.w,
                                                    //               height: 77.h,
                                                    //               decoration: BoxDecoration(border: Border.all(color: Colors.blue), shape: BoxShape.circle),
                                                    //               child:
                                                    //                   // Padding(padding: const EdgeInsets.all(0.0), child: feedsCubit.stories[index].view
                                                    //
                                                    //                   Container(
                                                    //                 decoration: ShapeDecoration(
                                                    //                   image: DecorationImage(
                                                    //                     image: CachedNetworkImageProvider(
                                                    //                      "https://images.alwatanvoice.com/news/images/3910365359.jpg",
                                                    //                     ),
                                                    //                     fit: BoxFit.fill,
                                                    //                   ),
                                                    //                   shape: OvalBorder(),
                                                    //                 ),
                                                    //                 // child: Image.file(File(FeedsCubit.get(context).stories[index].url),fit: BoxFit.cover,),
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //           Padding(
                                                    //             padding: const EdgeInsets.only(top: 8.0),
                                                    //             child: Text(
                                                    //               "Majd",
                                                    //               style: TextStyle(fontSize: 10),
                                                    //             ),
                                                    //           )
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //     // LiveProfileBubble(requiredWidth: 60.sp, name: 'Ahmad', liveTitle: '', liveGoal: '', liveTopic: '', liveId: null, thumbnailUrl: ''),
                                                    //     separatorBuilder: (_, i) => widthBox(8.w),
                                                    //     itemCount: feedsCubit.stories.length > 0 ? 1 : 0,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              )
                                                  : Container(),

                                              // Expanded(
                                              //   child: ListView
                                              //       .separated(
                                              //     scrollDirection:
                                              //         Axis.horizontal,
                                              //     itemBuilder: (
                                              //       context,
                                              //       index,
                                              //     ) =>
                                              //         LiveProfileBubble(requiredWidth: 60.sp, name: 'Ahmad', liveTitle: '', liveGoal: '', liveTopic: '', liveId: null, thumbnailUrl: ''),
                                              //     separatorBuilder:
                                              //         (_, i) =>
                                              //             widthBox(8.w),
                                              //     itemCount:
                                              //         10,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ))
                                        : SizedBox(),
                                    feedsCubit.categoryId == 0
                                        ? ListView.separated(
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets
                                          .only(
                                          bottom:
                                          15,
                                          top:
                                          10.h),
                                      shrinkWrap: true,
                                      itemBuilder: (context,
                                          index) =>
                                          FeedItemContainer(
                                            index: index,
                                            menaFeed: widget
                                                .providerId !=
                                                null
                                                ? feedsCubit
                                                .menaProviderFeedsList[
                                            index]
                                                : feedsCubit
                                                .menaFeedsList[
                                            index],
                                            customProviderFeedsId:
                                            widget
                                                .providerId,
                                            inPublicHomeFeeds:
                                            widget
                                                .inHome,
                                            isMyFeed: widget
                                                .providerId !=
                                                null
                                                ? feedsCubit
                                                .menaProviderFeedsList[
                                            index]
                                                .isMine
                                                : feedsCubit
                                                .menaFeedsList[
                                            index]
                                                .isMine,
                                          ),
                                      separatorBuilder:
                                          (_, i) =>
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                      itemCount: widget
                                          .providerId !=
                                          null
                                          ? feedsCubit
                                          .menaProviderFeedsList
                                          .length
                                          : feedsCubit
                                          .menaFeedsList
                                          .length,
                                    )
                                        :
                                    //      VSStoryDesigner(
                                    //         giphyKey:
                                    //             '[YOUR GIPHY API KEY]',

                                    //         /// (String), //disabled feature for now
                                    //         onDone:
                                    //             (String uri) {
                                    //           print(uri);

                                    //           /// uri is the local path of final render Uint8List
                                    //           /// here your code
                                    //         },
                                    //         themeType: ThemeType
                                    //             .dark, // OPTIONAL, DEFAULT ThemeType.dark
                                    //         centerText:
                                    //             "Start Designing" //mandatory param, this text will appear in center of story designer
                                    //         // colorList: [] /// (List<Color>[]) optional param
                                    //         // gradientColors: [] /// (List<List<Color>>[]) optional param
                                    //         // middleBottomWidget: Container() /// (Widget) optional param, you can add your own logo or text in the bottom tool
                                    //         // fontFamilyList: [] /// (List<FontType>) optional param
                                    //         // isCustomFontList: '' /// (bool) if you use a own font list set value to "true"
                                    //         // onDoneButtonStyle: Container() /// (Widget) optional param, you can create your own button style
                                    //         // onBackPress: /// (Future<bool>) optional param, here you can add yor own style dialog
                                    //         // editorBackgroundColor: /// (Color) optional param, you can define your own background editor color
                                    //         // galleryThumbnailQuality: /// (int = 200) optional param, you can set the gallery thumbnail quality (higher is better but reduce the performance)
                                    //         )
                                    Container(
                                        height: 500,
                                        child:
                                        ComingSoonWidget()),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
