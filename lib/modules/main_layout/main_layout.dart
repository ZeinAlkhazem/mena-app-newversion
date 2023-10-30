import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/responsive/responsive.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';
import 'package:mena/modules/home_screen/cubit/home_screen_cubit.dart';
import 'package:mena/modules/messenger/messenger_home_page.dart';

// import 'package:mena/modules/test/test_layout.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../core/constants/constants.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/local_models.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/sign_in_screen.dart';
import '../feeds_screen/cubit/feeds_cubit.dart';
import '../home_screen/home_screen.dart';
import '../live_screens/live_main_layout.dart';
import '../live_screens/meetings/meetings_layout.dart';
import '../messenger/messenger_layout.dart';
import '../my_profile/my_profile.dart';
import '../splash_screen/route_engine.dart';
import 'widget/messenger_icon_bubble_widget.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    // if (getCachedToken() != null) {
    //   checkPhoneVerified();
    // }
    _hideNavBar = false;

    // MainCubit.socketInitial();
  }

  // void checkPhoneVerified() {
  //   logg('checkPhoneVerified');
  //
  //   var mainCubit = MainCubit.get(context);
  //   Future.delayed(Duration(seconds: 2)).then((value) {
  //     logg('after 2 seconds checkPhoneVerified');
  //     if (mainCubit.isUserLoggedIn) {
  //       if (mainCubit.userInfoModel!.data.user.phoneVerifiedAt == null) {
  //         // var authCubit= AuthCubit.get(context);
  //         String otpText = '';
  //         showMyBottomSheet(
  //             context: context,
  //             isDismissible: false,
  //             title: getTranslatedStrings(context).enterCode,
  //             body: Padding(
  //               padding: EdgeInsets.symmetric(vertical: defaultHorizontalPadding, horizontal: defaultHorizontalPadding),
  //               child: BlocConsumer<AuthCubit, AuthState>(
  //                 listener: (context, state) {
  //                   // TODO: implement listener
  //                   if (state is VerifyingNumErrorState) {
  //                     showMyAlertDialog(context, 'Error Message',
  //                         alertDialogContent: Text(
  //                           'The digits you entered are incorrect. Please double-check the 6 digits that were sent to you.',
  //                           style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
  //                           textAlign: TextAlign.center,
  //                         ));
  //                   }
  //                 },
  //                 builder: (context, state) {
  //                   return Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       // Text(
  //                       //   getTranslatedStrings(context).enterCode,
  //                       //   style: mainStyle(context, 14, weight: FontWeight.w800),
  //                       // ),
  //                       // heightBox(10.h),
  //                       // Text(
  //                       //   '${getTranslatedStrings(context).enterCodeReceivedPhone} ${registerModel!.data.user.phone}',
  //                       //   style: mainStyle(context, 13.0),
  //                       //   textAlign: TextAlign.center,
  //                       // ),
  //                       Text(
  //                         'Please enter the 6-digit code you received on your mobile or email.',
  //                         style: mainStyle(context, 13.0, color: newDarkGreyColor, weight: FontWeight.w700),
  //                         // textAlign: TextAlign.center,
  //                       ),
  //                       heightBox(10.h),
  //                       PinCodeTextField(
  //                         onChanged: (value) {
  //                           otpText = value;
  //                           AuthCubit.get(context).updateOtpVal(value);
  //                         },
  //                         keyboardType: TextInputType.number,
  //                         appContext: context,
  //                         length: 6,
  //                         obscureText: false,
  //                         textStyle: const TextStyle(
  //                           color: Colors.white,
  //                         ),
  //                         pinTheme: PinTheme(
  //                           selectedFillColor: softBlueColor,
  //                           inactiveColor: mainBlueColor,
  //                           activeColor: mainBlueColor,
  //                           inactiveFillColor: Colors.white,
  //                           selectedColor: mainBlueColor.withOpacity(0.5),
  //                           shape: PinCodeFieldShape.box,
  //                           borderRadius: BorderRadius.circular(5),
  //                           fieldHeight: 50,
  //                           fieldWidth: 40,
  //                           activeFillColor: Theme.of(context).backgroundColor,
  //                         ),
  //                         cursorColor: Theme.of(context).backgroundColor,
  //                         animationDuration: const Duration(milliseconds: 300),
  //                         //backgroundColor:  Theme.of(context).backgroundColor,
  //                         enableActiveFill: true,
  //                         // controller: smsCodeEditingController,
  //                       ),
  //                       heightBox(10.h),
  //                       state is VerifyingNumState
  //                           ? const DefaultLoaderGrey()
  //                           : DefaultButton(
  //                               text: getTranslatedStrings(context).submit,
  //                               onClick: () {
  //                                 if (otpText.length < 6) {
  //                                   logg('otp must be 6 digits');
  //                                 } else {
  //                                   AuthCubit.get(context)
  //                                       .verifyPhoneNumber(mainCubit.userInfoModel!.data.user.phone!)
  //                                       .then((value) {
  //                                     ///
  //                                     ///
  //                                     ///     navigateTo(
  //                                     ///      context, const CompleteInfoSubscribe());
  //                                     ///    Todo: if data completed go to main
  //                                     ///    Todo: else go to complete data
  //                                     ///
  //                                     return navigateToAndFinishUntil(context, const RouteEngine());
  //                                   });
  //                                 }
  //                               }),
  //                       heightBox(10.h),
  //                       // state is VerifyingNumErrorState
  //                       //     ? Text(
  //                       //         state.error.toString(),
  //                       //         style: mainStyle(context, 11, color: Colors.red),
  //                       //         textAlign: TextAlign.center,
  //                       //       )
  //                       //     : const SizedBox()
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ));
  //       }
  //     }
  //   });
  // }


  // void socketInitial(BuildContext context) async {
  //   /// Socket connect
  //   print('establishing socket connection');
  //
  //   IO.Socket socket = await IO.io(
  //       'https://menaplatforms.com:3001',
  //       IO.OptionBuilder().setTransports(['websocket'])
  //           // for Flutter or Dart VM
  //           .setExtraHeaders({
  //         'foo': 'bar',
  //       }) // optional
  //           .build());
  //
  //   ///
  //   // IO.Socket socket =await IO.io('https://menaplatforms.com:3001');
  //
  //   logg(socket.json.connected.toString());
  //   socket.onConnect((_) {
  //     print('socket connection established');
  //
  //     if (MainCubit.get(context).userInfoModel != null) {
  //       socket.emit('join', [
  //         {
  //           'user_id': '${MainCubit.get(context).userInfoModel!.data.user.id}',
  //           'type': '${MainCubit.get(context).isUserProvider() ? 'provider' : 'client'}'
  //         },
  //       ]);
  //
  //       logg('emitted');
  //     }
  //
  //     socket.emit('msg', 'socket test');
  //   });
  //
  //   socket.on('event', (data) => print('socket ' + data));
  //
  //   socket.onerror({logg('Socket error')});
  //
  //   socket.onDisconnect((_) => print('socket disconnect'));
  //
  //   socket.on('fromServer', (_) => print('socket ' + _));
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
      ComingSoonWidget(),
      LiveMainLayout(),
      MeetingsLayout(),
      FeedsScreen(
        inHome: true,
        isMyFeeds: false,
        user: null,
      )
    ];
    // return const [
    //   HomeScreen(),
    //   DealsScreen(),
    //   LiveMainLayout(),
    //   CommunityScreen(),
    //        FeedsScreen(inHome: true,)
    // ];
  }

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
    var mainCubit = MainCubit.get(context);
    var homeCubit = HomeScreenCubit.get(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    if (!kIsWeb) {
                      Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                    }
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        // appBar: AppBar(),
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   // onPressed: (){
        //   //   MainCubit.get(context).updateMenaViewedLogo('assets/svg/icons/menalive.svg');
        //   // },
        // ),
        key: myScaffoldKey,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: ()async{
        //     var userBox = await Hive.openBox('userBox');
        //     UserInfoModel test=
        //     UserInfoModel.fromJson( userBox.get('userModel'));
        //     // await userBox.close();
        //     logg('yefghjdksmf: ${test.data.user.fullName}');
        //   },
        // ),
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     color: Colors.white,
        //   ),
        //   elevation: 0.1,
        //   leadingWidth: 50.w,
        //   leading:  Padding(
        //     padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding*2),
        //     child: Row(
        //       children: [
        //         SvgPicture.asset('assets/svg/mena8.svg',width: 0.4.sw,)
        //       ],
        //     ),
        //   ),
        // ),

        ///
        ///  change to getCachedToken()==null
        ///
        ///

        // drawer: getCachedToken() == null ? const GuestDrawer() : const UserProfileDrawer(),
        endDrawer: BlocConsumer<HomeScreenCubit, HomeScreenState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return FloatingPickPlatformsDrawer(
              buttons: mainCubit.configModel!.data.platforms
                  .map(
                    (e) => SelectorButtonModel(
                      title: e.name!,
                      image: e.image,
                      onClickCallback: () {
                        myScaffoldKey.currentState?.closeEndDrawer();
                        homeCubit.changeSelectedHomePlatform(e.id.toString());
                      },
                      isSelected: homeCubit.selectedHomePlatformId == e.id,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        endDrawerEnableOpenDragGesture: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     scaffoldKey.currentState?.openEndDrawer();
        //
        //   },
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        drawerScrimColor: Colors.white.withOpacity(0.2),
        body: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return (MainCubit.get(context).userInfoModel == null && getCachedToken() != null)
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(top: topScreenPadding),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          mainCubit.isHeaderVisible
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: defaultHorizontalPadding,
                                      left: defaultHorizontalPadding,
                                      top: Responsive.isMobile(context)
                                          ? defaultHorizontalPadding / 8
                                          : defaultHorizontalPadding / 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              mainCubit.currentLogo,
                                              height: Responsive.isMobile(context) ? 22.w : 12.w,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/icons/searchFilled.svg',
                                              height: Responsive.isMobile(context) ? 30.w : 12.w,
                                            ),
                                            widthBox(10.w),
                                            MessengerIconBubble(),
                                            widthBox(10.w),
                                            GestureDetector(
                                              onTap: () {
                                                logg('profile bubble clicked');
                                                navigateToWithoutNavBar(context,
                                                    getCachedToken() == null ? SignInScreen() : MyProfile(), '');
                                                    // getCachedToken() == null ? SignInScreen() : MyProfile(), '');

                                                // viewComingSoonAlertDialog(context,
                                                //     customAddedWidget: DefaultButton(
                                                //         text: getCachedToken() == null ? 'Login' : 'Logout',
                                                //         onClick: () {
                                                //           // AuthCubit.get(context).lo
                                                //
                                                //           if (getCachedToken() == null) {
                                                //             navigateToAndFinishUntil(context, SignInScreen());
                                                //           } else {
                                                //             removeToken();
                                                //             MainCubit.get(context).removeUserModel();
                                                //             navigateToAndFinishUntil(context, SignInScreen());
                                                //           }
                                                //         }));
                                              },
                                              child: getCachedToken() == null
                                                  ? SvgPicture.asset(
                                                      'assets/svg/icons/profileFilled.svg',
                                                      height: Responsive.isMobile(context) ? 30.w : 12.w,
                                                    )
                                                  : ProfileBubble(
                                                      isOnline: true,
                                                      customRingColor: mainBlueColor,
                                                      pictureUrl: MainCubit.get(context).userInfoModel == null
                                                          ? ''
                                                          : MainCubit.get(context)
                                                              .userInfoModel!
                                                              .data
                                                              .user
                                                              .personalPicture,
                                                      onlyView: true,
                                                      radius: Responsive.isMobile(context) ? 14.w : 5.w,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: PersistentTabView(
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
                                if (index == 2) {
                                  MainCubit.get(context).updateMenaViewedLogo('assets/svg/icons/menalive.svg');
                                } else if (index == 4) {
                                  /// feeds public
                                  MainCubit.get(context).updateMenaViewedLogo('assets/svg/mena8.svg');
                          //        FeedsCubit.get(context).getFeeds();
                                } else {
                                  MainCubit.get(context).updateMenaViewedLogo('assets/svg/mena8.svg');
                                }
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
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}




