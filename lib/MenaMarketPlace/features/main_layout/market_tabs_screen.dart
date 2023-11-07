import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/cache/cache.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../modules/auth_screens/sign_in_screen.dart';
import '../../../modules/my_profile/my_profile.dart';
import '../market/presentation/pages/market_screen.dart';

class MarketTabsScreen extends StatelessWidget {
  const MarketTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40.w,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: ProfileIconBubble(),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SvgPicture.asset(
                  "assets/menamarket/shopping_cart_outline_28.svg"),
            )
          ],
          title: Text("HealthCare Markets",
              style: mainStyle(context, 18.sp,
                  color: softGreyColor,
                  weight: FontWeight.w600,
                  fontFamily: "VisbyBold")),
          bottom: TabBar(
            indicatorColor: mainBlueColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: softGreyColor,
            labelColor: mainBlueColor,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
            tabs: [
              Tab(
                text: "Market",
              ),
              Tab(
                text: "Deals",
              ),
              Tab(
                text: "Campaigns",
              ),
              Tab(
                text: "Actions",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MarketScreen(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class ProfileIconBubble extends StatelessWidget {
  const ProfileIconBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          logg('profile bubble clicked');
          navigateToWithoutNavBar(context,
              getCachedToken() == null ? SignInScreen() : MyProfile(), '');
        },
        child: Icon(
          Icons.account_circle,
          size: 30.w,
          color: Colors.grey.shade500,
        ));
  }
}
