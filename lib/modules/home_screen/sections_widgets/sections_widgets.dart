import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/community_space/cme_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/my_countries.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../category_childs_screen/category_details_childs_screen.dart';

import '../../main_layout/categories page.dart';
import '../../main_layout/weather_banner.dart';
import '../../nearby_screen/nearby_layout.dart';
import '../../platform_provider/provider_home/platform_provider_home.dart';
import 'package:http/http.dart' as http;

class VideoSection extends StatelessWidget {
  const VideoSection({
    Key? key,
    required this.videoUrl,
    this.customFit,
    this.autoplay = true,
  }) : super(key: key);

  final String videoUrl;
  final BoxFit? customFit;
  final bool autoplay;

  @override
  Widget build(BuildContext context) {
    return HomeScreenVideoContainer(
      videoLink: videoUrl,
      testText: '2as',
      comingFromDetails: false,
      customFit: customFit,
      autoplay: autoplay,
    );
  }
}

///
///
///
///
///
///
///
///

class CategoriesSection extends StatelessWidget {
  const CategoriesSection(
      {Key? key,
      required this.categoriesSection,
      required this.style,
      required this.homeSectionTitle})
      : super(key: key);

  final List<MenaCategory>? categoriesSection;
  final String homeSectionTitle;
  final String style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 12, horizontal: defaultHorizontalPadding),
      child: categoriesSection == null
          ? const Text('categories null')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // color: Colors.red,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: style == '4_1'
                        ? 4
                        : style == '3_1'
                            ? 3
                            : style == '2_1'
                                ? 2
                                : 1,
                    childAspectRatio: style == '4_1'
                        ? 9.sp / 10.sp
                        : style == '3_1'
                            ? 9.sp / 10.sp
                            : style == '2_1'
                                ? 9.sp / 7.sp
                                : 9.sp / 7.sp,
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    mainAxisSpacing: 9.sp,
                    crossAxisSpacing: 10.sp,
                    children: List.generate(
                        style == '4_1'
                            ? categoriesSection!.length > 8
                                ? 8
                                : categoriesSection!.length
                            : style == '3_1'
                                ? categoriesSection!.length > 6
                                    ? 6
                                    : categoriesSection!.length
                                : style == '2_1'
                                    ? categoriesSection!.length > 4
                                        ? 4
                                        : categoriesSection!.length
                                    : 1,
                        (index) => GestureDetector(
                              onTap: () {
                                // comingSoonAlertDialog(context);
                                navigateToWithoutNavBar(
                                    context,
                                    CategoryChildsScreen(
                                      currentCategoryToViewId:
                                          categoriesSection![index]
                                              .id
                                              .toString(),
                                    ),
                                    '');
                                // navigateToWithoutNavBar(
                                //     context, const PlatformProviderHomePage(), '');
                              },
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(1.0.sp),
                                        child: SmoothBorderContainerModified(
                                          thumbNail:
                                              categoriesSection![index].image!,
                                          cornerRadius:
                                              Responsive.isMobile(context)
                                                  ? defaultRadiusVal
                                                  : defaultRadiusVal,
                                          customHeight:
                                              Responsive.isMobile(context)
                                                  ? 0.25.sw
                                                  : 0.13.sw,
                                        ),
                                      ),
                                    ),
                                    heightBox(5.h),
                                    Text(
                                      categoriesSection![index].name ?? '-',
                                      style: mainStyle(context, 11,
                                          weight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ) //getProductObjectAsList
                        ),
                  ),
                ),

                /// if not all displayed

                GestureDetector(
                    onTap: () {
                      ///
                      /// show all categories list bottom sheet
                      ///
                      if ((style == '4_1' && categoriesSection!.length > 8) ||
                          (style == '3_1' && categoriesSection!.length > 6) ||
                          (style == '2_1' && categoriesSection!.length > 4) ||
                          (style == '1_1' && categoriesSection!.length > 1)) {
                        showMyBottomSheet(
                          context: context,
                          title: homeSectionTitle,
                          body: Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: categoriesSection!.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  // comingSoonAlertDialog(context);
                                  navigateToWithoutNavBar(
                                      context,
                                      CategoryChildsScreen(
                                        currentCategoryToViewId:
                                            categoriesSection![index]
                                                .id
                                                .toString(),
                                      ),
                                      '');
                                  // navigateToWithoutNavBar(
                                  //     context, const PlatformProviderHomePage(), '');
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(1.0.sp),
                                        child: SmoothBorderContainer(
                                          thumbNail:
                                              categoriesSection![index].image!,
                                          customWidth: 0.2.sw,
                                          cornerRadius:
                                              Responsive.isMobile(context)
                                                  ? 8.r
                                                  : 10.r,
                                          customHeight: 0.2.sw,
                                        ),
                                      ),
                                      widthBox(8.w),
                                      Expanded(
                                        child: Text(
                                          categoriesSection![index].name ?? '-',
                                          style: mainStyle(context, 13,
                                              isBold: true,
                                              color: newDarkGreyColor),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      widthBox(8.w),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: newDarkGreyColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: CategoriesTail(
                      title: homeSectionTitle,
                      viewAllOption: ((style == '4_1' &&
                              categoriesSection!.length > 8) ||
                          (style == '3_1' && categoriesSection!.length > 6) ||
                          (style == '2_1' && categoriesSection!.length > 4) ||
                          (style == '1_1' && categoriesSection!.length > 1)),
                    ))
                // heightBox(6.h),
                // SizedBox(
                //     child: Center(
                //         child: Padding(
                //   padding: const EdgeInsets.all(2.0),
                //   child: DefaultButton(
                //     text: getTranslatedStrings(context).viewMore,
                //     fontSize: 11,
                //     backColor: softBlueColor,
                //     titleColor: mainBlueColor,
                //     onClick: () {},
                //     width: 0.3.sw,
                //     // height: 27.sp,
                //     radius: 23.r,
                //   ),
                // ))),
              ],
            ),
    );
  }
}

class CategoriesTail extends StatelessWidget {
  const CategoriesTail({
    super.key,
    required this.viewAllOption,
    required this.title,
  });

  final String title;

  final bool viewAllOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Divider(
            thickness: 1.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icons/services.svg',
                      color: mainBlueColor,
                    ),
                    widthBox(10.w),
                    Expanded(
                      child: Text(
                        !viewAllOption ? title : 'Find All ' + title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: mainStyle(
                          context,
                          12,
                          isBold: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///
              ///
              ///
              if (viewAllOption)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: newDarkGreyColor,
                  size: 18.sp,
                )
            ],
          ),
        ],
      ),
    );
  }
}

class NearbyProvidersSection extends StatefulWidget {
  const NearbyProvidersSection(
      {Key? key, required this.providersNearby, required this.title})
      : super(key: key);
  final String title;
  final List<ProviderLocationModel> providersNearby;

  @override
  State<NearbyProvidersSection> createState() => _NearbyProvidersSectionState();
}

class _NearbyProvidersSectionState extends State<NearbyProvidersSection> {
  final _controller = ScrollController();

  late bool isAutoScrollRun = false;

  @override
  void initState() {
    // TODO: implement initState
    ///
    // _controller.addListener(() {
    //   // logg('listener');
    //   // autoScroll();
    // });
    // if (_controller.hasClients) {
    //   _controller.animateTo(
    //     _controller.position.maxScrollExtent,
    //     duration: const Duration(seconds: 5),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // }
// autoScroll();
    Future.delayed(const Duration(milliseconds: 1500))
        .then((value) => autoScroll());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    logg('_NearbyProvidersSectionState disposed');
    super.dispose();
  }

  void animateToEndThenToStart() {
    logg('animateToEndThenToStart');
    if (_controller.hasClients) {
      _controller
          .animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: widget.providersNearby.length * 1),

        ///every ite will take 1 second
        curve: Curves.linear,
      )
          .then((value) async {
        if (_controller.hasClients) {
          if (_controller.position.pixels ==
              _controller.position.maxScrollExtent) {
            {
              return animateToStartThenToEnd();
            }
          }
        }
      });
    }
  }

  Future<void> animateToStartThenToEnd() async {
    logg('animateToStartThenToEnd');
    if (_controller.hasClients) {
      _controller
          .animateTo(
        _controller.position.minScrollExtent,
        duration: Duration(seconds: widget.providersNearby.length * 1),

        /// every ite will take 1 second
        curve: Curves.linear,
      )
          .then((value) async {
        if (_controller.hasClients) {
          if (_controller.position.pixels ==
              _controller.position.minScrollExtent) {
            return animateToEndThenToStart();

            if (_controller.keepScrollOffset) {
              if (_controller.hasClients) {
                if (true) {}
              }
            }
          }
        }
      });
    }
  }

  void autoScroll() {
    if (!isAutoScrollRun) {
      logg('! isAutoScrollRun');
      if (_controller.hasClients) {
        isAutoScrollRun = true;
        if (_controller.position.pixels <
            _controller.position.maxScrollExtent) {
          logg('pixels is _controller.position.minScrollExtent');

          ///
          animateToEndThenToStart();
        }
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          logg('pixels is _controller.position.maxScrollExtent');
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: const Duration(seconds: 5),
            curve: Curves.fastOutSlowIn,
          );
        }
        setState(() {});
        // logg('has client');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              // logg('logVal: ${widget.providersNearby}');
            },
            child: HomePageSectionHeader(title: widget.title)),
        Container(
          // color: Colors.red,
          height: 145.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  logg('nearby click');
                  navigateToWithoutNavBar(
                      context,
                      ProviderLocationsLayout(
                        title: '',
                        providersLocations: widget.providersNearby,
                        initialSelectedNearbyProvider: widget.providersNearby
                            .firstWhere((element) =>
                                element == widget.providersNearby[index]),
                      ),
                      '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NearbyContainer(
                    customWidth: 120.sp,
                    // customHeight: 99.sp,
                    title: widget.providersNearby[index].distance,
                    imageUrl: widget.providersNearby[index].image,
                  ),
                ),
              ),
              separatorBuilder: (_, index) => widthBox(7.w),
              itemCount: widget.providersNearby.length,
            ),
          ),
        ),
      ],
    );
  }
}

class NewMapNearbyProvidersSection extends StatefulWidget {
  const NewMapNearbyProvidersSection(
      {Key? key, required this.providersNearby, required this.title})
      : super(key: key);
  final String title;
  final List<ProviderLocationModel> providersNearby;

  @override
  State<NewMapNearbyProvidersSection> createState() =>
      _NewMapNearbyProvidersSectionState();
}

class _NewMapNearbyProvidersSectionState
    extends State<NewMapNearbyProvidersSection> {
  final _controller = ScrollController();
  late bool isAutoScrollRun = false;

  @override
  void initState() {
    // TODO: implement initState
    ///
    // _controller.addListener(() {
    //   // logg('listener');
    //   // autoScroll();
    // });
    // if (_controller.hasClients) {
    //   _controller.animateTo(
    //     _controller.position.maxScrollExtent,
    //     duration: const Duration(seconds: 5),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // }
    // autoScroll();
    Future.delayed(const Duration(milliseconds: 1500))
        .then((value) => autoScroll());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    logg('_NearbyProvidersSectionState disposed');
    super.dispose();
  }

  void animateToEndThenToStart() {
    logg('animateToEndThenToStart');
    if (_controller.hasClients) {
      _controller
          .animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: widget.providersNearby.length * 1),

        ///every ite will take 1 second
        curve: Curves.linear,
      )
          .then((value) async {
        if (_controller.hasClients) {
          if (_controller.position.pixels ==
              _controller.position.maxScrollExtent) {
            {
              return animateToStartThenToEnd();
            }
          }
        }
      });
    }
  }

  Future<void> animateToStartThenToEnd() async {
    logg('animateToStartThenToEnd');
    if (_controller.hasClients) {
      _controller
          .animateTo(
        _controller.position.minScrollExtent,
        duration: Duration(seconds: widget.providersNearby.length * 1),

        /// every ite will take 1 second
        curve: Curves.linear,
      )
          .then((value) async {
        if (_controller.hasClients) {
          if (_controller.position.pixels ==
              _controller.position.minScrollExtent) {
            return animateToEndThenToStart();
          }
        }
      });
    }
  }

  void autoScroll() {
    if (!isAutoScrollRun) {
      logg('! isAutoScrollRun');
      if (_controller.hasClients) {
        isAutoScrollRun = true;
        if (_controller.position.pixels <
            _controller.position.maxScrollExtent) {
          logg('pixels is _controller.position.minScrollExtent');

          ///
          animateToEndThenToStart();
        }
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          logg('pixels is _controller.position.maxScrollExtent');
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: const Duration(seconds: 5),
            curve: Curves.fastOutSlowIn,
          );
        }
        setState(() {});
        // logg('has client');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              // logg('logVal: ${widget.providersNearby}');
            },
            child: HomePageSectionHeader(title: widget.title)),
        Container(
          // color: Colors.red,
          height: 145.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  logg('nearby click');
                  navigateToWithoutNavBar(
                      context,
                      ProviderLocationsLayout(
                        title: widget.title,
                        providersLocations: widget.providersNearby,
                        initialSelectedNearbyProvider: widget.providersNearby
                            .firstWhere((element) =>
                                element == widget.providersNearby[index]),
                      ),
                      '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NearbyContainer(
                    customWidth: 120.sp,
                    // customHeight: 99.sp,
                    title: widget.providersNearby[index].distance,
                    imageUrl: widget.providersNearby[index].image,
                  ),
                ),
              ),
              separatorBuilder: (_, index) => widthBox(7.w),
              itemCount: widget.providersNearby.length,
            ),
          ),
        ),
      ],
    );
  }
}

class OnAirListSection extends StatefulWidget {
  const OnAirListSection({
    Key? key,
    required this.providersOnAir,
    required this.title,
    this.inHomeAndFirstLine = false,
  }) : super(key: key);

  final String title;
  final bool inHomeAndFirstLine;
  final List<ProvidersOnAir> providersOnAir;

  @override
  State<OnAirListSection> createState() => _OnAirListSectionState();
}

class _OnAirListSectionState extends State<OnAirListSection> {
  int maxViewed = 20;

  @override
  void initState() {
    // TODO: implement initState
    maxViewed = 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HomePageSectionHeader(title: title),
          SizedBox(
            height: 82.sp,
            child: Center(
              child: Row(
                children: [
                  // widthBox(defaultHorizontalPadding),
                  // if (inHomeAndFirstLine) MyProfileBubble(),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultHorizontalPadding / 2),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => viewComingSoonAlertDialog(context),
                        child:

                            /// >20 ? 21 ITEM SO ITEM 20 IS MORE
                            /// < 20 LENGTH+1 ITEMS SO ITEM[LENGTH] IS MORE
                            ((widget.providersOnAir.length > maxViewed &&
                                    index == maxViewed)
                                // ||
                                //     (providersOnAir.length < 20 && index == providersOnAir.length)
                                )
                                ? ViewMoreBubble(
                                    requiredWidth: 60.sp,
                                    liveId: null,
                                    liveTitle: '',
                                    liveGoal: '',
                                    liveTopic: '',
                                    name: 'More',
                                    thumbnailUrl: '',
                                    callBack: () {
                                      logg('More');
                                      maxViewed += 10;
                                      setState(() {});
                                    },
                                  )
                                : LiveProfileBubble(
                                    requiredWidth: 60.sp,
                                    liveId: null,
                                    liveTitle: '',
                                    liveGoal: '',
                                    liveTopic: '',
                                    name: widget.providersOnAir[index].name,
                                    thumbnailUrl:
                                        widget.providersOnAir[index].image,
                                  ),
                      ),
                      separatorBuilder: (_, index) => widthBox(1.w),
                      itemCount: widget.providersOnAir.length > maxViewed
                          ? maxViewed + 1
                          : widget.providersOnAir.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewMoreBubble extends StatelessWidget {
  const ViewMoreBubble({
    Key? key,
    required this.requiredWidth,
    required this.name,
    required this.liveTitle,
    required this.liveGoal,
    required this.liveTopic,
    required this.liveId,
    required this.thumbnailUrl,
    this.callBack,
  }) : super(key: key);

  final double requiredWidth;
  final String name;
  final Function()? callBack;
  final String liveTitle;
  final String liveGoal;
  final String liveTopic;
  final String? liveId;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                height: requiredWidth + 6.sp,
                child: Stack(children: <Widget>[
                  Container(
                    width: requiredWidth + 3,
                    height: requiredWidth + 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(66.sp),
                      ),
                      color: newLightGreyColor,
                      border: Border.all(
                        color: mainBlueColor,
                        width: 1.7,
                      ),
                    ),
                    child: Container(
                      width: requiredWidth,
                      height: requiredWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(66.sp),
                        ),
                        color: newLightGreyColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.2,
                        ),
                        image: DecorationImage(
                            image: AssetImage('assets/images/mena.png'),
                            fit: BoxFit.fitWidth,
                            onError: (object, stackTrace) =>
                                const ImageLoadingError()),
                      ),

                      // child:Image.asset('assets/images/mena.png'),
                    ),
                  ),
                  // Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     child: SizedBox(
                  //       width: requiredWidth,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(1.sp),
                  //               ),
                  //               color: mainBlueColor,
                  //               border: Border.all(
                  //                 color: mainBlueColor,
                  //                 width: 0.5,
                  //               ),
                  //             ),
                  //             padding: EdgeInsets.symmetric(
                  //               horizontal: 5.sp,
                  //               vertical: 3.sp,
                  //             ),
                  //             child: Text(
                  //               'LIVE',
                  //               style: mainStyle(context, 5, isBold: true, color: Colors.white),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                ]),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: requiredWidth + 13.sp,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 9, isBold: true),
            ),
          ),
        ],
      ),
    );
  }
}

class MyProfileBubble extends StatelessWidget {
  const MyProfileBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: Center(
              child: getCachedToken() == null
                  ? LoginBubble(
                      isOnline: false,
                      radius: 30.sp,
                    )
                  : ProfileBubble(
                      isOnline: true,
                      customRingColor: newDarkGreyColor,
                      radius: 30.sp,
                      onlyView: false,
                      pictureUrl:
                          mainCubit.userInfoModel!.data.user.personalPicture,
                    ),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: 60.sp + 13.sp,
          child: Text(
            getCachedToken() != null ? 'My profile' : 'Login',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: mainStyle(context, 9, weight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

// class SuppliesSection extends StatelessWidget {
//   const SuppliesSection({Key? key, required this.suppliers}) : super(key: key);
//
//   final List<Supplier> suppliers;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Suppliers'),
//         SizedBox(
//           height: 133.sp,
//           child: ListView.separated(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal:2.0),
//               child: GestureDetector(
//                 onTap: () {
//                   logg('supplier click');
//                   // navigateToWithoutNavBar(context, const NearbyLayout(), '');
//                 },
//                 child: Padding(
//                   padding:  EdgeInsets.symmetric(vertical: 10.0.sp),
//                   child: Column(
//                     children: [
//                       Expanded(child: SmoothBorderContainer(
//                         customWidth: 88.sp,
//                         thumbNail: suppliers[index].image,
//                       )),
//                       heightBox(6.h),
//                       Text(suppliers[index].distance)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             separatorBuilder: (_, index) => widthBox(10.w),
//             itemCount: suppliers.length,
//           ),
//         ),
//       ],
//     );
//   }
// }

class ItemsSection extends StatelessWidget {
  const ItemsSection({Key? key, required this.items, required this.title})
      : super(key: key);
  final String title;

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 192.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () {
                    logg('items click');
                    viewComingSoonAlertDialog(context);
                    // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                    child: Column(
                      children: [
                        Expanded(
                            child: DefaultShadowedContainer(
                          borderWidth: 0,
                          width: 144.sp,
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: DefaultImage(
                                radius: defaultRadiusVal,
                                width: double.maxFinite,
                                boxFit: BoxFit.fill,
                                backGroundImageUrl: items[index].image,
                              )),
                              heightBox(3.h),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Center(
                                  child: Text(
                                    items[index].title,
                                    style:
                                        mainStyle(context, 13, textHeight: 1),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    // topLeft: Radius.circular(10.0),
                                    // topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(
                                        defaultHorizontalPadding),
                                    bottomLeft: Radius.circular(
                                        defaultHorizontalPadding),
                                  ),
                                  child: Container(
                                    color: const Color(0xff33B6FF)
                                        .withOpacity(0.5),
                                    height: 20.sp,
                                    child: Center(
                                      child: Text(
                                        items[index].price,
                                        style: mainStyle(context, 13,
                                            color: mainBlueColor,
                                            weight: FontWeight.w700),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        )),
                        // heightBox(6.h),
                        // Text(items[index].price)
                      ],
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, index) => widthBox(10.w),
              itemCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class VacanciesSection extends StatelessWidget {
  const VacanciesSection(
      {Key? key, required this.vacancies, required this.title})
      : super(key: key);
  final String title;

  final List<Vacancy> vacancies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 199.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Vacancy vacancy = vacancies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('vacancies click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                      child: Column(
                        children: [
                          Expanded(
                              child: DefaultShadowedContainer(
                            borderWidth: 1,
                            borderColor: mainBlueColor,
                            width: 288.sp,
                            childWidget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Job title: ',
                                                          style: mainStyle(
                                                              context, 12)),
                                                      TextSpan(
                                                          text: vacancy.title,
                                                          style: mainStyle(
                                                              context, 12,
                                                              weight: FontWeight
                                                                  .w700)),
                                                    ]),
                                                  ),
                                                  heightBox(8.h),
                                                  RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Location: ',
                                                          style: mainStyle(
                                                              context, 12)),
                                                      TextSpan(
                                                          text:
                                                              vacancy.location,
                                                          style: mainStyle(
                                                              context, 12,
                                                              weight: FontWeight
                                                                  .w700)),
                                                      TextSpan(
                                                          text:
                                                              ' (${vacancy.distance})',
                                                          style: mainStyle(
                                                              context, 12,
                                                              weight: FontWeight
                                                                  .w700,
                                                              color:
                                                                  mainBlueColor)),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DefaultImage(
                                              backGroundImageUrl: vacancy.image,
                                              width: 45.sp,
                                            ),
                                          ],
                                        ),
                                        heightBox(10.h),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Job scope: ',
                                                style: mainStyle(context, 12)),
                                            TextSpan(
                                                text: vacancy.scope,
                                                style: mainStyle(context, 12,
                                                    textHeight: 1.5,
                                                    weight: FontWeight.w700)),
                                          ]),
                                        ),
                                        heightBox(10.h),
                                      ],
                                    ),
                                  ),
                                  Text(getFormattedDate(vacancy.createdAt),
                                      style: mainStyle(context, 12,
                                          color: softGreyColor)),
                                  heightBox(10.h),
                                ],
                              ),
                            ),
                          )),
                          // heightBox(6.h),
                          // Text(items[index].price)
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(10.w),
              itemCount: vacancies.length,
            ),
          ),
        ),
      ],
    );
  }
}

class DealsSection extends StatelessWidget {
  const DealsSection({Key? key, required this.deals, required this.title})
      : super(key: key);
  final String title;

  final List<Deal> deals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 300.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Deal deal = deals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('deals click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: Column(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DefaultShadowedContainer(
                            borderWidth: 0,
                            width: 200.sp,
                            childWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: DefaultImage(
                                  radius: defaultHorizontalPadding,
                                  backGroundImageUrl: deal.image,
                                  boxFit: BoxFit.fitHeight,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/svg/icons/heart.svg',
                                                  height: 12.sp),
                                              widthBox(3.w),
                                              Text(
                                                deal.likes.toString(),
                                                style: mainStyle(context, 12),
                                              )
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svg/icons/location.svg',
                                                height: 12.sp,
                                              ),
                                              widthBox(3.w),
                                              Text(
                                                deal.distance.toString(),
                                                style: mainStyle(context, 12),
                                              )
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RatingBarIndicator(
                                                rating: 2.75,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 12.0.sp,
                                                direction: Axis.horizontal,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      heightBox(5.h),
                                      Text(
                                        deal.title,
                                        style: mainStyle(context, 14,
                                            weight: FontWeight.w600),
                                      ),
                                      heightBox(5.h),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: deal.price,
                                              style: mainStyle(context, 12)),
                                          TextSpan(
                                              text: ' (${deal.offer})',
                                              style: mainStyle(context, 12,
                                                  weight: FontWeight.w700,
                                                  color: Colors.red)),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        // heightBox(6.h),
                        // Text(items[index].price)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(10.w),
              itemCount: deals.length,
            ),
          ),
        ),
      ],
    );
  }
}

class CouponsSection extends StatelessWidget {
  const CouponsSection({Key? key, required this.coupons, required this.title})
      : super(key: key);
  final String title;

  final List<Coupon> coupons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 177.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Coupon coupon = coupons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('coupons click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0.sp),
                      child: DefaultShadowedContainer(
                        borderWidth: 0,
                        width: 300.sp,
                        childWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              width: 70.sp,
                              'assets/svg/no shadow.svg',
                              fit: BoxFit.contain,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    coupon.description,
                                    style: mainStyle(context, 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: coupon.price,
                                          style: mainStyle(context, 12)),
                                      TextSpan(
                                          text: ' (${coupon.offer})',
                                          style: mainStyle(context, 12,
                                              weight: FontWeight.w700,
                                              color: Colors.red)),
                                    ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.sp),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/icons/heart.svg',
                                              height: 20.sp,
                                            ),
                                            widthBox(3.w),
                                            Text(
                                              coupon.likes.toString(),
                                              style: mainStyle(context, 13),
                                            )
                                          ],
                                        ),
                                        RatingBarIndicator(
                                          rating: 2.75,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 12.0.sp,
                                          direction: Axis.horizontal,
                                        ),
                                        SvgPicture.asset(
                                          'assets/svg/icons/share.svg',
                                          height: 15.sp,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DefaultImage(
                                          width: 33.sp,
                                          backGroundImageUrl: coupon.image),
                                      SvgPicture.asset(
                                        'assets/svg/getCode.svg',
                                        height: 30.sp,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(10.w),
              itemCount: coupons.length,
            ),
          ),
        ),
      ],
    );
  }
}

class EventsSection extends StatelessWidget {
  const EventsSection({Key? key, required this.events, required this.title})
      : super(key: key);
  final String title;

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 333.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Event event = events[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('events click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: Column(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DefaultShadowedContainer(
                            borderWidth: 0,
                            width: 200.sp,
                            childWidget: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: DefaultImage(
                                  radius: defaultHorizontalPadding,
                                  width: double.maxFinite,
                                  backGroundImageUrl: event.image,
                                  boxFit: BoxFit.cover,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.category,
                                        style: mainStyle(context, 12,
                                            color: mainBlueColor),
                                      ),
                                      heightBox(6.h),
                                      Text(
                                        event.title,
                                        style: mainStyle(context, 13,
                                            weight: FontWeight.w700,
                                            textHeight: 1.3),
                                      ),
                                      heightBox(6.h),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: event.time,
                                              style: mainStyle(context, 12)),
                                          TextSpan(
                                              text: ' ${event.type}',
                                              style: mainStyle(context, 12,
                                                  weight: FontWeight.w700,
                                                  color: mainBlueColor)),
                                        ]),
                                      ),
                                      heightBox(6.h),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/icons/sand_clock.svg'),
                                          widthBox(5.w),
                                          Text(
                                            event.duration,
                                            style: mainStyle(context, 10),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          ProfileBubble(
                                              radius: 12.sp,
                                              isOnline: false,
                                              pictureUrl: event.userImg),
                                          widthBox(5.w),
                                          Text(
                                            event.userName,
                                            style: mainStyle(context, 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        // heightBox(6.h),
                        // Text(items[index].price)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(10.w),
              itemCount: events.length,
            ),
          ),
        ),
      ],
    );
  }
}

class NearbyEventsSection extends StatelessWidget {
  const NearbyEventsSection(
      {Key? key, required this.nearbyEvents, required this.title})
      : super(key: key);
  final String title;

  final List<EventsNearby> nearbyEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 120.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  logg('nearby click');
                  viewComingSoonAlertDialog(context);
                  // navigateToWithoutNavBar(
                  //     context,
                  //     NearbyEventsLayout(
                  //       nearbyProviders: nearbyEvents,
                  //       initialSelectedNearbyProvider: nearbyEvents.firstWhere(
                  //           (element) => element == nearbyEvents[index]),
                  //     ),
                  //     '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NearbyContainer(
                    customWidth: 0.25.sw,
                    // customHeight: 99.sp,
                    title: nearbyEvents[index].distance,
                    imageUrl: nearbyEvents[index].image,
                  ),
                ),
              ),
              separatorBuilder: (_, index) => widthBox(7.w),
              itemCount: nearbyEvents.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({Key? key, required this.articles, required this.title})
      : super(key: key);
  final String title;

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 266.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Article article = articles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('article click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: // Figma Flutter Generator Frame2172Widget - FRAME - VERTICAL
                          ArticleContainer(
                        article: article,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(5.w),
              itemCount: articles.length,
            ),
          ),
        ),
      ],
    );
  }
}

class TalkSection extends StatelessWidget {
  const TalkSection({Key? key, required this.talks, required this.title})
      : super(key: key);

  final String title;
  final List<Talk> talks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 200.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Talk talk = talks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('talk click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: SizedBox(
                      width: 299.sp,
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              DefaultImage(
                                width: double.maxFinite,
                                backGroundImageUrl: talk.image!,
                                boxFit: BoxFit.cover,
                                radius: 22,
                              ),
                              DefaultContainer(
                                backColor: Colors.grey.withOpacity(0.3),
                                width: double.maxFinite,
                                borderColor: Colors.transparent,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: double.maxFinite,
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 66.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(5.w),
              itemCount: talks.length,
            ),
          ),
        ),
      ],
    );
  }
}

class CmeSection extends StatelessWidget {
  const CmeSection({Key? key, required this.title, required this.cmeItems})
      : super(key: key);
  final String title;
  final List<Cme> cmeItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 233.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Cme cmeItem = cmeItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('cme click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: SizedBox(
                      width: 288.sp,
                      child: CMECard(
                        cmeItem: cmeItem,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(5.w),
              itemCount: cmeItems.length,
            ),
          ),
        ),
      ],
    );
  }
}

class BannerSection extends StatelessWidget {
  const BannerSection({Key? key, required this.banners, required this.style})
      : super(key: key);

  final List<MenaBanner> banners;
  final String style;

  @override
  Widget build(BuildContext context) {
    return Center(
      // color: Colors.red,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: style == '4_1'
            ? 4
            : style == '3_1'
                ? 3
                : style == '2_1'
                    ? 2
                    : 1,
        childAspectRatio: banners[0].imagesStyle == 'null'
            ? 1
            : 1 / double.parse(banners[0].imagesStyle),
        padding: banners[0].resourceId == 'air_quality' ||
                banners[0].resourceId == 'weather_summary' ||
                banners[0].resourceId == 'upcoming_days'
            ? const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10)
            : const EdgeInsets.all(0),
        shrinkWrap: true,
        mainAxisSpacing: 9.sp,
        crossAxisSpacing: 10.sp,
        children: List.generate(
            banners.length,
            (index) => GestureDetector(
                  onTap: () {
                    handleBannerNavigation(context, banner: banners[index]);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(0.0.sp),
                          child: banners[index].resourceId == 'air_quality' ||
                                  banners[index].resourceId ==
                                      'weather_summary' ||
                                  banners[index].resourceId == 'upcoming_days'
                              ?
                              // _buildConditionalWidget(banners[index].resourceType),
                              SmoothBorderContainer(
                                  thumbNail: banners[index].image,
                                  cornerRadius: 22.r,
                                  customWidth: 80.w,
                                )
                              : SmoothBorderContainer(
                                  thumbNail: banners[index].image,
                                  // withShadow: style != '1_1',
                                  cornerRadius: defaultRadiusVal,
                                  // customHeight: Responsive.isMobile(context) ? 0.25.sw : 0.13.sw,
                                ),
                        ),
                      ),
                      // heightBox(5.h),
                    ],
                  ),
                ) //getProductObjectAsList
            ),
      ),
    );
  }

  Future<void> handleBannerNavigation(BuildContext context,
      {required MenaBanner banner}) async {
    logg('handleBannerNavigation - type: ${banner.resourceType}');
    switch (banner.resourceType) {
      // case 'appointment':
      case 'category':
        logg('handleBannerNavigation: category');

        /// currently for test purposes 15.Feb.2023
        ///
        /// getCategory by id then navigate.
        ///
        ///
        navigateToWithoutNavBar(
            context,
            CategoryChildsScreen(
              currentCategoryToViewId: banner.resourceId,
            ),
            '');

        break;

      // case 'url':
      //   logg('handleBannerNavigation: url');
      //
      //   if (banner.url != null) {
      //     launchUrl(Uri.parse(banner.url!));
      //   }
      //
      //   break;
      case 'api':
        navigateToWithoutNavBar(
            context,
            CategoryChildsScreen(
              currentCategoryToViewId: banner.resourceId,
            ),
            '');
        break;
      default:
        logg('handleBannerNavigation: url');

        if (banner.url != null) {
          launchUrl(Uri.parse(banner.url!));
        }
        break;

      /// and soo on
    }
  }
}

class BannerSectionWeather extends StatelessWidget {
  const BannerSectionWeather(
      {Key? key, required this.banners,required this.categoriesSection, required this.style, required this.homeSectionTitle})
      : super(key: key);

  final List<MenaBanner> banners;
  final String style;
  final List<MenaCategory>? categoriesSection;
  final String homeSectionTitle;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 85),
            child: Text(
              'Wellness Monitoring Widgets',
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Tajawal',
                color: Color(0xff444444),),
            ),
          ),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: banners.length,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {

                    String countryName = await getCachedSelectedCountry()??"";
                    String countryNameNew ="";
                    log('# country name : $countryName');
                    List countryList = MayyaCountries.countryList;
                    for(var item in countryList){
                      if(item['alpha_3_code']==countryName){
                        countryNameNew = item['en_short_name'];
                      }
                    }
                    log('# country name  new : $countryNameNew');


                            banners[index].resourceId == 'upcoming_days'
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return PopupWidgetUpComing(countryNameNew);
                            },
                          )
                        :banners[index].resourceId == 'air_quality' ?
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PopupWidgetUpComing(countryNameNew);
                      },
                    )
                        :banners[index].resourceId == 'weather_summary' ?
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PopupWidgetUpComing(countryNameNew);
                      },
                    ): handleBannerNavigation(context,
                            banner: banners[index]);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 10, right: 10),
                          child: banners[index].resourceId == 'air_quality' ||
                                  banners[index].resourceId ==
                                      'weather_summary' ||
                                  banners[index].resourceId == 'upcoming_days'
                              ? SmoothBorderContainer(
                                  thumbNail: banners[index].image,
                                  cornerRadius: 18.r,
                                  customWidth: 70.w,
                                )
                              : SmoothBorderContainer(
                                  thumbNail: banners[index].image,
                                  cornerRadius: defaultRadiusVal,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'more',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tajawal',
                    color: Color(0xff97A0A8),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleBannerNavigation(BuildContext context,
      {required MenaBanner banner}) async {
    logg('handleBannerNavigation - type: ${banner.resourceType}');
    var mainCubit = MainCubit.get(context);
    switch (banner.resourceType) {
      // case 'appointment':
      case 'category':
        logg('handleBannerNavigation: category');
        navigateToWithoutNavBar(
            context,
            CategoryChildsScreen(
              currentCategoryToViewId: banner.resourceId,
            ),
            '');
        break;
      case 'api':
        break;
      default:
        logg('handleBannerNavigation: url');

        if (banner.url != null) {
          launchUrl(Uri.parse(banner.url!));
        }
        break;

      /// and soo on
    }
  }
}

class PartnerSection extends StatelessWidget {
  const PartnerSection({Key? key, required this.partners, required this.title})
      : super(key: key);

  final String title;
  final List<Partner> partners;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageSectionHeader(title: title),
        SizedBox(
          height: 66.sp,
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Partner partner = partners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      logg('partner click');
                      viewComingSoonAlertDialog(context);
                      // navigateToWithoutNavBar(context, const NearbyLayout(), '');
                    },
                    child: DefaultImage(
                      backGroundImageUrl: partner.image,
                      width: 66.sp,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => widthBox(5.w),
              itemCount: partners.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ProvidersSection extends StatelessWidget {
  const ProvidersSection({
    Key? key,
    required this.providers,
    required this.title,
    this.justView = false,
    this.currentCategoryName,
  }) : super(key: key);

  final String title;
  final bool justView;
  final String? currentCategoryName;
  final List<User> providers;

  @override
  Widget build(BuildContext context) {
    // logg('providers gfg: ${providers}');
    return Container(
      color: newLightGreyColor,
      child: providers.isEmpty
          ? SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HomePageSectionHeader(title: title),
                ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    User provider = providers[index];
                    return NewProviderCard(
                      provider: provider,
                      // customCallback: cardCustomCallback,
                      justView: justView,
                      currentLayout: currentCategoryName,
                    );
                  },
                  separatorBuilder: (_, index) => heightBox(10.h),
                  itemCount: providers.length,
                ),
              ],
            ),
    );
  }
}

class HomePageSectionHeader extends StatelessWidget {
  const HomePageSectionHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return title.isEmpty
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: mainStyle(
                    context, 14, weight: FontWeight.w600,
                    //     fontFamily:
                    // getTranslatedStrings(context).language == 'English'
                    //     ? 'RobotoBold'
                    //     :
                    // 'Tajawal'
                  ),
                ),
                const Text('-')
              ],
            ),
          );
  }
}
