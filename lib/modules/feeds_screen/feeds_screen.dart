import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/attachments_grid.dart';
import 'package:mena/modules/create_live/widget/appbar_for_live.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/post_a_feed.dart';
import 'package:mena/modules/feeds_screen/widgets/feed_item.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/feeds_model.dart';
import '../../models/api_model/home_section_model.dart';

import '../../models/local_models.dart';
import '../messenger/chat_layout.dart';
import 'feed_details.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen(
      {Key? key,
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
        if (FeedsCubit.get(context).state is! GettingFeedsState &&
            FeedsCubit.get(context).feedsModel!.data.totalSize >
                FeedsCubit.get(context).menaFeedsList.length &&
            widget.providerId == null) {
          FeedsCubit.get(context).getFeeds();
        } else if (FeedsCubit.get(context).state is! GettingFeedsState &&
            FeedsCubit.get(context).feedsModel!.data.totalSize >
                FeedsCubit.get(context).menaProviderFeedsList.length &&
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
    FeedsCubit.get(context).menaFeedsListOffset = 1;
    FeedsCubit.get(context).menaFeedsList.clear();

    FeedsCubit.get(context).menaProviderFeedsListOffset = 1;
    FeedsCubit.get(context).menaProviderFeedsList.clear();
    FeedsCubit.get(context)
        .getFeeds(providerId: widget.providerId)
        .then((value) => _refreshController.refreshCompleted());
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  void didChangeDependencies() {
    if (FeedsCubit.get(context).state is! GettingFeedsState) {
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
      floatingActionButton: (getCachedToken() != null &&
              (MainCubit.get(context).isUserProvider() &&
                  (widget.isMyFeeds || widget.inHome)))
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    navigateToWithoutNavBar(context, PostAFeedLayout(), '');
                  },
                  isExtended: true,
                  label: Text(
                    getTranslatedStrings(context).addPost,
                    style: mainStyle(context, 13,
                        color: Colors.white, weight: FontWeight.w700),
                  ),
                  backgroundColor: mainBlueColor,
                ),
                // heightBox(widget.inHome ? 55.h : 10.h)
              ],
            )
          : SizedBox(),
      appBar: widget.inHome
          ? null
          : PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultOnlyLogoAppbar(
          withBack: true,
          logo: "assets/svg/mena_feed.svg",
        ),
      ),
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
                                              ((feedsCubit.menaProviderFeedsList
                                                      .isEmpty &&
                                                  state is! GettingFeedsState &&
                                                  widget.providerId != null))
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
                                                              height: 127.h,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        defaultHorizontalPadding),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      getTranslatedStrings(
                                                                              context)
                                                                          .providersOnAir,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: mainStyle(
                                                                          context,
                                                                          14,
                                                                          weight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                    heightBox(
                                                                        5.h),
                                                                    Expanded(
                                                                      child: ListView
                                                                          .separated(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        itemBuilder: (
                                                                          context,
                                                                          index,
                                                                        ) =>
                                                                            LiveProfileBubble(requiredWidth: 60.sp, name: 'Ahmad', liveTitle: '', liveGoal: '', liveTopic: '', liveId: null, thumbnailUrl: ''),
                                                                        separatorBuilder:
                                                                            (_, i) =>
                                                                                widthBox(8.w),
                                                                        itemCount:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                          :

                                                      SizedBox(),
                                                      ListView.separated(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 15,
                                                                top: 10.h),
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
                                                              widget.providerId,
                                                          inPublicHomeFeeds:
                                                              widget.inHome,
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
                                                            (_, i) => SizedBox(
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
                                                      ),
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
