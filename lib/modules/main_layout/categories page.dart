import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import '../home_screen/cubit/home_screen_cubit.dart';
import '../home_screen/sections_widgets/sections_widgets.dart';
import '../nearby_screen/cubit/nearby_cubit.dart';
import 'main_layout.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              bottom: rainBowBarBottomPadding(context),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: rainBowBarHeight, //rainbow height
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        // right: defaultHorizontalPadding,
                          left: defaultHorizontalPadding,
                          top: Responsive.isMobile(context)
                              ? defaultHorizontalPadding / 8
                              : defaultHorizontalPadding / 2),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0,top:5),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: SvgPicture.asset(
                                  'assets/new_icons/back.svg',
                                  height: 20,
                                  color: Color(0xff2788E8),
                                ),
                              ),
                            ),
                            // widthBox(0.5.w),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, right: 9),
                              child: Text(
                                "Healthcare Digital directory",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Tajawal',
                                  color: Color(0xff444444),),
                              ),
                            ),
                            widthBox(45.w),


                            widthBox(4.w),
                            // widthBox(3.w),
                            AppBarIcons(
                              btnClick: () {  },
                              icon: 'assets/new_icons/search.svg',
                              iconSize: 22,
                              width: 12,
                              top: 3,
                              bottom: 4,
                              // right: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                            itemBuilder: (context, index) =>
                                                Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      defaultHorizontalPadding /
                                                          7,
                                                  vertical: 0),
                                              child: HomeSectionBlock1(
                                                  homeSectionBlockModel: homeCubit
                                                      .homeSectionModel!
                                                      .data[index],
                                                  inHome: true,
                                                  isAtHomeAndFirstLine:
                                                      index == 0),
                                            ),
                                            separatorBuilder: (_, index) =>
                                                heightBox(10.h),
                                            itemCount: homeCubit
                                                .homeSectionModel!.data.length,
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
        );
      },
    );
  }
}

// GestureDetector(
// onTap: () {
// navigateTo(context, CategoriesPage());
// },
// child: Container(
// margin: EdgeInsets.only(top: 15),
// width: double.infinity,
// height: 90.h,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(20),
// boxShadow: const [
// BoxShadow(
// color: Color(0x29000000),
// offset: Offset(0, 2),
// blurRadius: 3,
// ),
// ],
// ),
// child: Text('Test for widget'),
// ),
// )
class HomeSectionBlock1 extends StatelessWidget {
  const HomeSectionBlock1({
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
              case 'categories':
                return CategoriesSection(
                    categoriesSection: sectionData.categories,
                    homeSectionTitle: homeSectionBlockModel.title,
                    style: homeSectionBlockModel.style ?? '3_1');
              default:
                return Container();
            }
          })),
    );
  }
}
