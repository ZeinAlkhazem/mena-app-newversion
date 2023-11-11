import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/Colors.dart';
import '../widgets/health_care_category.dart';
import '../widgets/health_care_controll_appbar.dart';
import '../widgets/health_care_search_controll.dart';
import '../widgets/health_care_sub_category.dart';

class HealthCareMarket extends StatefulWidget {
  const HealthCareMarket({super.key});

  @override
  State<HealthCareMarket> createState() => _HealthCareMarketState();
}

class _HealthCareMarketState extends State<HealthCareMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 120.h),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,

            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          automaticallyImplyLeading: false, // hides default back button
          flexibleSpace: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.softBlue,
                    AppColors.hardBlue,
                  ]),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HealthCareControllAppbar(),
                  HealthCareSearchControll(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Divider(),
                ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) => HealthCareCategory(
                  btnIcon: "assets/menamarket/market_circle_fill_yellow_20.svg",
                  label: "Healthcare\nMarket",
                  onTap: () async {},
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: HealthCareSubCategory(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
