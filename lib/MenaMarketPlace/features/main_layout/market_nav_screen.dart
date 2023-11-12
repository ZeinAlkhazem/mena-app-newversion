import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/pages/market_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';

class MarketNavLayout extends StatefulWidget {
  const MarketNavLayout({super.key});

  @override
  State<MarketNavLayout> createState() => _MarketNavLayoutState();
}

class _MarketNavLayoutState extends State<MarketNavLayout> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() => [
        MarketScreen(),
        Container(),
        Container(),
        Container(),
        Container(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/icons/home.svg',
          color: mainBlueColor,
          fit: BoxFit.contain,
          // height: 33.h,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/icons/home.svg',
          fit: BoxFit.contain,
          color: Colors.black.withOpacity(0.5),
          // height: 30.h,
        ),
        title: getTranslatedStrings(context).home.toUpperCase(),
        textStyle: mainStyle(context, 10.0, isBold: true),
        activeColorPrimary: mainBlueColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/icons/promotion.svg',
          fit: BoxFit.contain,
          color: mainBlueColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/icons/promotion.svg',
          fit: BoxFit.contain,
          color: Colors.black.withOpacity(0.5),
        ),
        title: getTranslatedStrings(context).deals.toUpperCase(),
        textStyle: mainStyle(context, 10.0, isBold: true),
        activeColorPrimary: mainBlueColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: SvgPicture.asset(
            'assets/svg/icons/live screencast.svg',
            color: mainBlueColor,
            // fit: BoxFit.contain,
            // height: 28.h,
          ),
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/icons/live screencast.svg',
          fit: BoxFit.contain,
          color: newDarkGreyColor,
          // height: 28.h,
        ),
        title: getTranslatedStrings(context).live.toUpperCase(),
        textStyle: mainStyle(context, 10.0, isBold: true),
        activeColorPrimary: mainBlueColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/icons/community.svg',
          color: mainBlueColor,
          fit: BoxFit.contain,
          // height: 30.h,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/icons/community.svg',
          fit: BoxFit.contain,
          color: Colors.black.withOpacity(0.5),
          // height: 28.h,
        ),
        title: getTranslatedStrings(context).meetings.toUpperCase(),
        textStyle: mainStyle(context, 10.0, isBold: true),
        activeColorPrimary: mainBlueColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/svg/icons/feeds.svg',
          fit: BoxFit.contain,
          color: mainBlueColor,
        ),
        inactiveIcon: SvgPicture.asset(
          'assets/svg/icons/feeds.svg',
          color: Colors.black.withOpacity(0.5),
          fit: BoxFit.contain,
        ),
        title: getTranslatedStrings(context).feeds.toUpperCase(),
        textStyle: mainStyle(context, 10.0, isBold: true),
        activeColorPrimary: mainBlueColor,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        navBarHeight: Responsive.isMobile(context)
            ? kBottomNavigationBarHeight * 1
            : kBottomNavigationBarHeight * 1.3,
        controller: _controller,
        // floatingActionButton: Container(
        //   c
        // ),
        onItemSelected: (index) {
          // mainCubit.changeHeaderVisibility(true);
        },
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        margin: const EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        onWillPop: (context) async {
          await showDialog(
            context: context!,
            useSafeArea: true,
            builder: (context) => Container(
              ///
              /// height:50.0,
              /// width:50.0,
              ///
              ///
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              /// todo: test this
              color: mainBlueColor,
              // blurRadius: 0.001,
            ),
          ],
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: false,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
