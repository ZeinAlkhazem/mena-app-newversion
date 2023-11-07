// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/functions/main_funcs.dart';
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
    return SafeArea(
      child: Column(
        children: [
          SearchControll(),
          heightBox(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonWithLabel(
                btnIcon: "assets/menamarket/services_circle_fill_blue_20.svg",
                label: "All Category",
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon:
                    "assets/menamarket/money_transfer_circle_fill_turquoise_20.svg",
                label: "Request for\nQuatation",
                onTap: () {},
              ),
              ButtonWithLabel(
                btnIcon: "assets/menamarket/services_circle_fill_blue_20.svg",
                label: "Secured Trading",
                onTap: () {},
              ),
            ],
          ),
          heightBox(20.h),
          SizedBox(
            // color: Colors.grey,
            height: context.height / 4,
            child: CarouselSlider.builder(
              itemCount: 3,
              carouselController: CarouselController(),
              itemBuilder: (context, index, realIndex) => Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              options: CarouselOptions(
                autoPlay: false,
                reverse: false,
                height: double.maxFinite,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                initialPage: 0,
                scrollPhysics: ClampingScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
