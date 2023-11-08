// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../widgets/button_with_label.dart';
import '../widgets/search_controll.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 200.h),
        child: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   // Status bar color
          //   statusBarColor: Colors.transparent,

          //   // Status bar brightness (optional)
          //   statusBarIconBrightness:
          //       Brightness.dark, // For Android (dark icons)
          //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
          // ),
          automaticallyImplyLeading: false, // hides default back button
          flexibleSpace: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.softBlue,
                          AppColors.hardBlue,
                        ]),
                  )),
              Positioned(
                left: 0,
                right: 0,
                bottom: -30.h,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 160.h,
                  child: Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.softBlue,
                          AppColors.hardBlue,
                        ]),
                  ),
                ),
              )
            ],
          ),
          title: SearchControll(),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          heightBox(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonWithLabel(
                btnIcon: "assets/menamarket/market_circle_fill_yellow_20.svg",
                label: "Healthcare\nMarket",
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: "assets/menamarket/discount_outline_20.svg",
                label: "Healthcare\nDeals",
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: "assets/menamarket/discount_outline_20.svg",
                label: "Healthcare\nCampaigns",
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: "assets/menamarket/discount_outline_20.svg",
                label: "Healthcare\nAuctions",
                onTap: () {},
              ),
            ],
          ),
          heightBox(20.h),
          SizedBox(
            // color: Colors.grey,
            height: context.height / 3.8,
            child: CarouselSlider.builder(
              itemCount: 3,
              carouselController: CarouselController(),
              itemBuilder: (context, index, realIndex) => SliderItem(
                title: "Smart Expo",
                btnLable: "More Expos",
                description: "2023 Jinagsw import & Export Fair",
                subDescription:
                    "Health & Medicine JiangSulumport Right Now In Expo UAE",
                time: "Nov 1 - Nov10 , 2023 \nUTC +8:00",
              ),
              options: CarouselOptions(
                autoPlay: false,
                reverse: false,
                viewportFraction: 0.95,
                height: double.maxFinite,
                enableInfiniteScroll: false,
                // enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                initialPage: 0,
                scrollPhysics: ClampingScrollPhysics(),
              ),
            ),
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
    Key? key,
    required this.title,
    required this.description,
    required this.subDescription,
    required this.time,
    required this.btnLable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          color: AppColors.indigoBlue,
          borderRadius: BorderRadius.circular(15.r)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: mainStyle(context, 18.sp,
                    fontFamily: "VisbyBold",
                    weight: FontWeight.w800,
                    color: AppColors.whiteCreamColor),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0.r),
                    color: Colors.white30),
                child: Row(
                  children: [
                    Text(
                      btnLable,
                      style: mainStyle(context, 10.sp,
                          weight: FontWeight.w700,
                          color: AppColors.whiteCreamColor),
                    ),
                    widthBox(3.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10.sp,
                      color: AppColors.whiteCreamColor,
                    )
                  ],
                ),
              )
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
                          placeholder:
                              'assets/menamarket/market_circle_fill_yellow_20.svg',
                          image:
                              "https://media.istockphoto.com/id/1150397417/photo/abstract-luminous-dna-molecule-doctor-using-tablet-and-check-with-analysis-chromosome-dna.webp?s=2048x2048&w=is&k=20&c=ipb_OZxpMheJNNEfC-cZea6_nz59HrYO4Sjli16jGzY="),
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
                        style: mainStyle(context, 12.sp,
                            fontFamily: "VisbyBold",
                            weight: FontWeight.w800,
                            color: AppColors.whiteCreamColor),
                      ),
                      Text(
                        subDescription,
                        style: mainStyle(context, 10.sp,
                            weight: FontWeight.w800,
                            color: AppColors.whiteCreamColor),
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
                            style: mainStyle(context, 10.sp,
                                color: AppColors.whiteCreamColor),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
