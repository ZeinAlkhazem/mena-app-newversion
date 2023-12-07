// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/cubit/market_cubit.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

import 'package:mena/core/cache/cache.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/widgets/button_with_label.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/widgets/search_box.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/pages/health_care_market.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  CarouselController carouselController = CarouselController();
  String platformName = CacheHelper.getData(key: 'platformName');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          // systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          //   statusBarColor: AppColors.hardBlue,
          // ),
          // systemOverlayStyle: const SystemUiOverlayStyle(
          //   // Status bar color
          //   statusBarColor: Colors.transparent,
          //   statusBarIconBrightness: Brightness.dark,
          //   statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          // ),
          automaticallyImplyLeading: false, // hides default back button
          flexibleSpace: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(10.r)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.softBlue,
                  AppColors.hardBlue,
                ],
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: const SearchBox(hint: 'Search'),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          heightBox(13.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonWithLabel(
                btnIcon: 'assets/menamarket/market_circle_fill_yellow_20.svg',
                label: '$platformName\nMarket',
                onTap: () async {
                  await navigateToWithoutNavBar(
                    context,
                    const HealthCareMarket(),
                    'routeName',
                  );
                },
              ),
              ButtonWithLabel(
                btnIcon: 'assets/menamarket/discount_outline_20.svg',
                label: '$platformName\nDeals',
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: 'assets/menamarket/discount_outline_20.svg',
                label: '$platformName\nCampaigns',
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: 'assets/menamarket/discount_outline_20.svg',
                label: '$platformName\nAuctions',
                onTap: () {},
              ),
            ],
          ),
          heightBox(13.h),
          SizedBox(
            // color: Colors.grey,
            height: context.height / 5,
            child: CarouselSlider.builder(
              itemCount: 6,
              carouselController: carouselController,
              itemBuilder: (context, index, realIndex) => Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/menamarket/offer1.png'),
                  ),
                ),
              ),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  context.read<MarketCubit>().changeCaroselPosition(index);
                },
                viewportFraction: 0.90,
                height: double.maxFinite,
                scrollPhysics: const ClampingScrollPhysics(),
              ),
            ),
          ),
          BlocBuilder<MarketCubit, MarketState>(
            builder: (context, state) {
              final cubit = context.read<MarketCubit>();
              return DotsIndicator(
                dotsCount: 6,
                position: cubit.i,
                decorator: const DotsDecorator(
                  activeSize: Size.square(6),
                  activeColor: Color(0xff6D9BCB),
                  size: Size.square(6),
                  spacing: EdgeInsets.all(3),
                ),
              );
            },
          ),
        ],
      ),
    );
    // return SafeArea(
    //   child: Column(
    //     children: [
    //       SearchControll(),
    //       heightBox(20.h),

    //     ],
    //   ),
    // );
  }
}

class SliderItem extends StatelessWidget {
  final String title;
  final String description;
  final String subDescription;
  final String time;
  final String btnLable;
  const SliderItem({
    super.key,
    required this.title,
    required this.description,
    required this.subDescription,
    required this.time,
    required this.btnLable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppColors.indigoBlue,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: mainStyle(
                  context,
                  18.sp,
                  fontFamily: 'VisbyBold',
                  weight: FontWeight.w800,
                  color: AppColors.whiteCreamColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0.r),
                  color: Colors.white30,
                ),
                child: Row(
                  children: [
                    Text(
                      btnLable,
                      style: mainStyle(
                        context,
                        10.sp,
                        weight: FontWeight.w700,
                        color: AppColors.whiteCreamColor,
                      ),
                    ),
                    widthBox(3.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10.sp,
                      color: AppColors.whiteCreamColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          heightBox(20.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/allNewDesign/logo.jpg',
                        image:
                            'https://media.istockphoto.com/id/1150397417/photo/abstract-luminous-dna-molecule-doctor-using-tablet-and-check-with-analysis-chromosome-dna.webp?s=2048x2048&w=is&k=20&c=ipb_OZxpMheJNNEfC-cZea6_nz59HrYO4Sjli16jGzY=',
                      ),
                    ),
                  ),
                ),
                widthBox(10.w),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        style: mainStyle(
                          context,
                          12.sp,
                          fontFamily: 'VisbyBold',
                          weight: FontWeight.w800,
                          color: AppColors.whiteCreamColor,
                        ),
                      ),
                      Text(
                        subDescription,
                        style: mainStyle(
                          context,
                          10.sp,
                          weight: FontWeight.w800,
                          color: AppColors.whiteCreamColor,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 20.sp,
                            color: AppColors.whiteCreamColor,
                          ),
                          widthBox(5.w),
                          Text(
                            time,
                            style: mainStyle(
                              context,
                              10.sp,
                              color: AppColors.whiteCreamColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
