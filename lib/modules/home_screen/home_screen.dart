import 'dart:developer';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/home_screen/sections_widgets/sections_widgets.dart';
import 'package:mena/modules/tools/jobs/jobs.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../feeds_screen/blogs/blogs_layout.dart';
import '../main_layout/categories page.dart';
import '../main_layout/weather_banner.dart';
import '../my_profile/my_profile.dart';
import '../nearby_screen/cubit/nearby_cubit.dart';
import '../platform_provider/provider_home/provider_profile_Sections.dart';
import '../tools/e_services/e-services.dart';
import 'cubit/home_screen_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await HomeScreenCubit.get(context)
      ..changeSelectedHomePlatform(
          HomeScreenCubit.get(context).selectedHomePlatformId.toString());
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    NearbyCubit.get(context).initialMapMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeCubit =
        HomeScreenCubit.get(context); // will get data inside this function
    ///
    /// to initial marker before building layout
    ///
    return BlocConsumer<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: rainBowBarBottomPadding(context),
          ),
          child: Stack(
            children: [
              MainBackground(
                customColor: newLightGreyColor,
                bodyWidget: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: rainBowBarHeight, //rainbow height
                    ),
                    child: Column(
                      children: [

                        Expanded(
                          child:

                              /// test null or empty in 2 lines
                              state is LoadingDataState?
                                  ? Container(
                                      color: Colors.white,
                                      child: const DefaultLoaderGrey())
                                  : homeCubit.homeSectionModel == null
                                      ? const Center(child: Text('check temp'))
                                      : homeCubit.homeSectionModel!.data.isEmpty
                                          ? const EmptyListLayout()
                                          : SmartRefresher(
                                              enablePullDown: true,
                                              controller: _refreshController,
                                              onRefresh: _onRefresh,
                                              child: ListView.separated(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                 return
                                                   index == 1 ?
                                                   Column(
                                                     children: [
                                                       GestureDetector(
                                                         onTap: () {
                                                           navigateToWithoutNavBar(context, CategoriesPage(),"");
                                                           // Navigator.push(
                                                           //       context,
                                                           //       PageTransition(
                                                           //         type:Platform.isIOS?PageTransitionType.: PageTransitionType.fade,
                                                           //         child: routPage,
                                                           //         duration: const Duration(milliseconds: 400),
                                                           //       ),
                                                           //     );
                                                         },
                                                         child: Container(
                                                           margin: EdgeInsets.only(top: 10, bottom: 10,right: 15.w/7.w,left: 15.w/7.w),
                                                           width: double.infinity,
                                                           height: 170.h,
                                                           decoration: BoxDecoration(
                                                             color: Colors.white,
                                                             borderRadius: BorderRadius.circular(7.r),
                                                             boxShadow: const [
                                                               BoxShadow(
                                                                 color: Color(0x29000000),
                                                                 offset: Offset(0, 2),
                                                                 blurRadius: 3,
                                                               ),
                                                             ],
                                                           ),
                                                           child: Container(
                                                             padding: EdgeInsets.only(top: 35,left: 33, bottom: 20),
                                                               child: Text(
                                                                   'Click to discover\nall the Categories',
                                                                 style: TextStyle(
                                                                   color: Color(0xff050505),
                                                                   fontSize: 45.0,
                                                                   // fontWeight: FontWeight.w600,
                                                                   fontFamily: 'Tajawal',
                                                                 ),                                                               )
                                                           ),
                                                         ),
                                                       ),
                                                       heightBox(10.h),
                                                       Padding(
                                                         padding: EdgeInsets.symmetric(
                                                             horizontal:
                                                             defaultHorizontalPadding /
                                                                 7,
                                                             vertical: 0),
                                                         child: HomeSectionBlock(
                                                             homeSectionBlockModel:
                                                             homeCubit
                                                                 .homeSectionModel!
                                                                 .data[index],
                                                             inHome: true,
                                                             isAtHomeAndFirstLine:
                                                             index == 0),
                                                       )
                                                     ],
                                                   ):
                                                   Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                        defaultHorizontalPadding /
                                                            7,
                                                        vertical: 0),
                                                    child: HomeSectionBlock(
                                                        homeSectionBlockModel:
                                                        homeCubit
                                                            .homeSectionModel!
                                                            .data[index],
                                                        inHome: true,
                                                        isAtHomeAndFirstLine:
                                                        index == 0),
                                                  );
                                                }
                                                 ,
                                                separatorBuilder: (_, index) =>
                                                    heightBox(10.h),
                                                itemCount: homeCubit
                                                    .homeSectionModel!
                                                    .data
                                                    .length,
                                                padding: EdgeInsets.only(
                                                  bottom: 22.h,
                                                ),
                                              ),
                                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      myScaffoldKey.currentState?.openEndDrawer();
                    },
                    onHorizontalDragStart: (x) {
                      myScaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Container(
                      width: 6.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: mainBlueColor.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultRadiusVal),
                            bottomLeft: Radius.circular(defaultRadiusVal)),
                        border:
                            Border.all(width: 1.0, color: Colors.transparent),
                      ),
                    )),
              ),
              if (getCachedToken() != null)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: MyPullDownButton(
                            svgLink:
                                "assets/new_icons/add_circle_fill_blue_16.svg",
                            svgHeight:
                                Responsive.isMobile(context) ? 30.w : 12.w,
                            customWidth: 0.600.sw,
                            customOffset: Offset(-30, 12),
                            customPosition: PullDownMenuPosition.above,
                            customButtonWidget: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                "assets/new_icons/add_circle_fill_blue_20.svg",
                                width: 33,
                              ),
                            ),
                            items: MainCubit.get(context)
                                .userActionItems1(context),
                          ),
                        ),

                        widthBox(7.w),
                        // GestureDetector(
                        //   onTap: (){},
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(radius)
                        //       boxShadow: const [
                        //         BoxShadow(
                        //           color: Color(0x29000000),
                        //           offset: Offset(0, 2),
                        //           blurRadius: 3,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () {
                        //     navigateToWithoutNavBar(context, EServicesLayout(), 'routeName');
                        //   },
                        //   child: CircleAvatar(
                        //     radius: 33.h,
                        //     child: Text('E-ser'),
                        //   ),
                        // ),
                        // widthBox(7.w),
                        // GestureDetector(
                        //   onTap: () {
                        //     navigateToWithoutNavBar(context, JobsLayout(), 'routeName');
                        //   },
                        //   child: CircleAvatar(
                        //     radius: 33.h,
                        //     child: Text('Jobs'),
                        //   ),
                        // ),
                      ],
                    )),
            ],
          ),
        );
      },
    );
  }
}

class MyPopUpMenu extends StatefulWidget {
  const MyPopUpMenu({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<MyPopUpMenu> createState() => _MyPopUpMenuState();
}

class _MyPopUpMenuState extends State<MyPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        logg('tapped');
        _showMyPopUpMenu();
      },
    );
  }

  void _showMyPopUpMenu() {
    showCupertinoDialog(
        context: context,
        // anchorPoint: Offset(56, 56),
        barrierDismissible: true,
        barrierLabel: 't',
        builder: (context) {
          RenderBox renderBox = (widget.child.key as GlobalKey)
              .currentContext
              ?.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              children: [
                Positioned(
                  right: (MediaQuery.of(context).size.width - position.dx) -
                      renderBox.size.width,
                  top: position.dy,
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    width: 75,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class HomeSectionBlock extends StatelessWidget {
  const HomeSectionBlock({
    Key? key,
    required this.homeSectionBlockModel,
    this.currentHomeCategory,
    this.isAtHomeAndFirstLine = false,
    this.inHome = false,
  }) : super(key: key);

// HomeSectionBlockModel homeSectionBlockModel;
  final HomeSectionBlockModel homeSectionBlockModel;
  final String? currentHomeCategory;
  final bool isAtHomeAndFirstLine;
  final bool inHome;

  @override
  Widget build(BuildContext context) {
    HomeSectionBlockDataModel sectionData = homeSectionBlockModel.data;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: inHome
              ? isAtHomeAndFirstLine
                  ? 0.0
                  : homeScreeHorizontalPadding
              : 0),
      child: Container(
          decoration: BoxDecoration(
            color: homeSectionBlockModel.type == 'banner'
                ? Colors.white
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(isAtHomeAndFirstLine ? 0 : defaultRadiusVal),
              topRight:
                  Radius.circular(isAtHomeAndFirstLine ? 0 : defaultRadiusVal),
              bottomLeft: Radius.circular(defaultRadiusVal),
              bottomRight: Radius.circular(defaultRadiusVal),
            ),
            boxShadow: homeSectionBlockModel.type == 'banner' ||
                    homeSectionBlockModel.type == 'providers'
                ? const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
          ),
          child: Builder(builder: (BuildContext context) {
            switch (homeSectionBlockModel.type) {
              case 'video':
                return HomeScreenVideoContainer(
                  videoLink: sectionData.video!,
                  testText: '998',
                  comingFromDetails: false,
                );
              // case 'categories':
              //   return CategoriesSection(
              //       categoriesSection: sectionData.categories,
              //       homeSectionTitle: homeSectionBlockModel.title,
              //       style: homeSectionBlockModel.style ?? '3_1');
              case 'providers_nearby':
                // return NearbyProvidersSection(
                //   providersNearby: sectionData.providersNearby!,
                //   title: homeSectionBlockModel.title,
                // );
                return OurLocationSection(
                  provider: null,
                  viewTitleInProfileLayout: false,
                  providersLocations: sectionData.providersNearby,
                  // providersLocations: productDetailsCubit
                  //     .providerDetailsModel!.user.locations,
                );
              case 'providers_on_air':
                return OnAirListSection(
                  providersOnAir: homeSectionBlockModel.data.providersOnAir!,
                  title: homeSectionBlockModel.title,
                  inHomeAndFirstLine: isAtHomeAndFirstLine,
                );
              // case 'supplies':
              //   return SuppliesSection(suppliers: sectionData.supplies!);
              case 'items':
                return ItemsSection(
                    items: sectionData.items!,
                    title: homeSectionBlockModel.title);
              case 'vacancies':
                return VacanciesSection(
                    vacancies: sectionData.vacancies!,
                    title: homeSectionBlockModel.title);
              case 'deals':
                return DealsSection(
                    deals: sectionData.deals!,
                    title: homeSectionBlockModel.title);
              case 'coupons':
                return CouponsSection(
                    coupons: sectionData.coupons!,
                    title: homeSectionBlockModel.title);

              ///
              ///
              case 'events':
                return EventsSection(
                    events: sectionData.events!,
                    title: homeSectionBlockModel.title);
              case 'events_nearby':
                return NearbyEventsSection(
                    nearbyEvents: sectionData.eventsNearby!,
                    title: homeSectionBlockModel.title);
              case 'articles':
                return ArticlesSection(
                    articles: sectionData.articles!,
                    title: homeSectionBlockModel.title);
              case 'talk':
                return TalkSection(
                    talks: sectionData.talk!,
                    title: homeSectionBlockModel.title);
              case 'cme':
                return CmeSection(
                    cmeItems: sectionData.cme!,
                    title: homeSectionBlockModel.title);
              case 'banner':
                if (sectionData.banner![0].resourceId == 'air_quality' ||
                    sectionData.banner![0].resourceId == 'weather_summary' ||
                    sectionData.banner![0].resourceId == 'upcoming_days') {
                  log("# cate data : ${sectionData.categories}");
                  return BannerSectionWeather(
                    banners: sectionData.banner!,
                    style: homeSectionBlockModel.style ?? '1_1',
                    homeSectionTitle: homeSectionBlockModel.title,
                    categoriesSection: sectionData.categories,
                  );
                } else {
                  return BannerSection(
                      banners: sectionData.banner!,
                      style: homeSectionBlockModel.style ?? '1_1');
                }
                break;
              case 'partner':
                return PartnerSection(
                    partners: sectionData.partner!,
                    title: homeSectionBlockModel.title);
              case 'providers':
                return ProvidersSection(
                    providers: sectionData.providers!,
                    currentCategoryName:
                        currentHomeCategory ?? homeSectionBlockModel.title,
                    title: 'providers');
              default:
                return Container();
              // return Center(
              //     child: Text(
              //   'unsupported view: ${homeSectionBlockModel.type}',
              //   style: mainStyle(context, 13, color: Colors.red),
              // ));
            }
          })),
    );
  }
}
