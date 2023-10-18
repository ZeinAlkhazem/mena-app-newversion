import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/promotions_screen/cubit/promotions_cubit.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'package:http/http.dart' as http;

import '../../models/local_models.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var promotionCubit = PromotionsCubit.get(context);
    return Padding(
      padding: EdgeInsets.only(bottom: rainBowBarBottomPadding(context)),
      child: Scaffold(
        // key: scaffoldKey,
        backgroundColor: Colors.white,
        // floatingActionButton: const SharedFloatingMsngr(
        //   heroTag: 'PromotionsScreen',
        // ),
        drawerScrimColor: Colors.grey.withOpacity(0.2),
        body: MainBackground(
          bodyWidget: BlocConsumer<PromotionsCubit, PromotionsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: rainBowBarHeight),

                ///rainbow
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        heightBox(25.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  promotionCubit.changeCurrentView('all'),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    heightBox(5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SvgPicture.asset(
                                        //   'assets/svg/icons/livenow.svg',
                                        //   height: 16.h,
                                        //   color: promotionCubit.liveNowLayout ==
                                        //           'all'
                                        //       ? mainBlueColor
                                        //       : softGreyColor,
                                        // ),
                                        // widthBox(12.w),
                                        Text(
                                          'All',
                                          style: mainStyle(context,11,
                                              weight: FontWeight.w800,
                                              color: promotionCubit
                                                          .liveNowLayout ==
                                                      'all'
                                                  ? mainBlueColor
                                                  : softGreyColor),
                                        )
                                      ],
                                    ),

                                    ///
                                    heightBox(10.h),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 2.h,
                                      color:
                                          promotionCubit.liveNowLayout == 'all'
                                              ? mainBlueColor
                                              : softGreyColor,
                                      width:
                                          promotionCubit.liveNowLayout == 'all'
                                              ? 0.25.sw
                                              : 0.2.sw,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            widthBox(10.w),
                            GestureDetector(
                              onTap: () =>
                                  promotionCubit.changeCurrentView('deals'),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    heightBox(5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SvgPicture.asset(
                                        //   'assets/svg/icons/upcomingLive.svg',
                                        //   height: 16.h,
                                        //   color: promotionCubit.liveNowLayout ==
                                        //           'deals'
                                        //       ? mainBlueColor
                                        //       : softGreyColor,
                                        // ),
                                        // widthBox(12.w),
                                        Text(
                                          'Deals',
                                          style: mainStyle(context,11,
                                              weight: FontWeight.w800,
                                              color: promotionCubit
                                                          .liveNowLayout ==
                                                      'deals'
                                                  ? mainBlueColor
                                                  : softGreyColor),
                                        )
                                      ],
                                    ),
                                    heightBox(10.h),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 2.h,
                                      color: promotionCubit.liveNowLayout ==
                                              'deals'
                                          ? mainBlueColor
                                          : softGreyColor,
                                      width: promotionCubit.liveNowLayout ==
                                              'deals'
                                          ? 0.25.sw
                                          : 0.2.sw,
                                      // borderColor: Colors.transparent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            widthBox(10.w),
                            GestureDetector(
                              onTap: () =>
                                  promotionCubit.changeCurrentView('coupons'),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    heightBox(5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // SvgPicture.asset(
                                        //   'assets/svg/icons/upcomingLive.svg',
                                        //   height: 16.h,
                                        //   color: promotionCubit.liveNowLayout ==
                                        //           'coupons'
                                        //       ? mainBlueColor
                                        //       : softGreyColor,
                                        // ),
                                        // widthBox(12.w),
                                        Text(
                                          'Coupons',
                                          style: mainStyle(context,11,
                                              weight: FontWeight.w800,
                                              color: promotionCubit
                                                          .liveNowLayout ==
                                                      'coupons'
                                                  ? mainBlueColor
                                                  : softGreyColor),
                                        )
                                      ],
                                    ),
                                    heightBox(10.h),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 2.h,
                                      color: promotionCubit.liveNowLayout ==
                                              'coupons'
                                          ? mainBlueColor
                                          : softGreyColor,
                                      width: promotionCubit.liveNowLayout ==
                                              'coupons'
                                          ? 0.25.sw
                                          : 0.2.sw,
                                      // borderColor: Colors.transparent,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        heightBox(7.h),
                        Expanded(
                            child: promotionCubit.liveNowLayout == 'all'
                                ? const AllPromotionsView()
                                : promotionCubit.liveNowLayout == 'deals'
                                    ? const DealsPromotions()
                                    : const CouponsPromotions())
                      ],
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AllPromotionsView extends StatelessWidget {
  const AllPromotionsView({Key? key}) : super(key: key);

  Future<List> fetchTestData() async {
    final response = await http.get(
        Uri.parse('https://blasanka.github.io/watch-ads/lib/data/ads.json'));
    if (response.statusCode == 200) return json.decode(response.body);
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        vertical: rainBowBarHeight, // vertical 3 is rainbow row height
      ),
      child: FutureBuilder<List>(

          future: fetchTestData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                     HorizontalSelectorScrollable( buttons: [
                      SelectorButtonModel(title: 'test', onClickCallback: (){},isSelected:true),
                      SelectorButtonModel(title: 'test', onClickCallback: (){},isSelected:true),
                      SelectorButtonModel(title: 'test', onClickCallback: (){},isSelected:true),
                    ],),
                    Expanded(
                      child: StaggeredGridView.count(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 10.0.w,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 50.h),
                        children: snapshot.data.map<Widget>((item) {
                          return PromotionContainer(
                            imageUrl: item['imageUrl'] ?? '',
                            title: item['title'],
                            price: item['price'],
                            location: item['location'],
                          );
                        }).toList(),
                        staggeredTiles: snapshot.data
                            .map<StaggeredTile>(
                                (_) => const StaggeredTile.fit(2))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child:
                      const DefaultLoaderGrey()); // If there are no data show this
            }
          }),

    );
  }
}

class DealsPromotions extends StatelessWidget {
  const DealsPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CouponsPromotions extends StatelessWidget {
  const CouponsPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
