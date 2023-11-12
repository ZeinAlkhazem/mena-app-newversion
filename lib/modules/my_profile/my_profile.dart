import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/main_layout/main_layout.dart';
import 'package:mena/modules/my_profile/cubit/profile_cubit.dart';
import 'package:mena/modules/platform_provider/provider_home/platform_provider_home.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile_Sections.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import '../../models/local_models.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    // var profileCubit = ProfileCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: mainCubit.isUserProvider() ? 'Dashboard' : 'My profile',
          suffix: Row(
            children: [
              // widthBox(5.w),
              // MessengerIconBubble(),
              NotificationIconBubble(),
              widthBox(8.w),
              SvgPicture.asset(
                'assets/svg/icons/setting.svg',
                height: Responsive.isMobile(context) ? 25.w : 12.w,
              ),

              widthBox(8.w),
              MyPullDownButton(
                svgLink: 'assets/svg/icons/addcircle.svg',
                svgHeight: Responsive.isMobile(context) ? 25.w : 12.w,
                customWidth: 0.485.sw,
                items: mainCubit.userActionItems(context),
              ),
              widthBox(defaultHorizontalPadding),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   profileCubit.updateCubit();
      // }),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          /// ! for testing purposes
          return mainCubit.isUserProvider() ? ProviderProfileDashboard() : ClientProfileDashboard();
        },
      ),
    );
  }

// viewProviderActionPanel(BuildContext context) {
//   var mainCubit=MainCubit.get(context);
//   User user=mainCubit.userInfoModel!.data.user;
//
//   return  Container(
//     color: Colors.transparent,
//     width: 33.sp,
//     child: MyPullDownButton(),
//   );
//
// }

//
//
// viewClientActionPanel(BuildContext context) {
//   var mainCubit=MainCubit.get(context);
//   User user=mainCubit.userInfoModel!.data.user;
// }
}

class CustomPullDownItem extends PullDownMenuEntry {
  CustomPullDownItem({
    required this.title,
    required this.svgLink,
    this.onTap,
    // String? title,
  });

  final String? title;
  final String? svgLink;
  final Function()? onTap;

  // String get title => title;
  // final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: 8),
        child: Row(
          children: [
            svgLink != null
                ? SvgPicture.asset(
                    svgLink!,
                    height: 28.h,
                  )
                : SizedBox(
                    height: 28.h,
                  ),
            widthBox(7.w),
            Expanded(
              child: Text(
                title ?? '---',
                style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  // TODO: implement height
  double get height => throw UnimplementedError();

  @override
  // TODO: implement isDestructive
  bool get isDestructive => throw UnimplementedError();

  @override
  // TODO: implement represents
  bool get represents => throw UnimplementedError();
}

class MyPullDownButton extends StatelessWidget {
  const MyPullDownButton({
    super.key,
    required this.svgLink,
    this.customWidth,
    this.customButtonWidget,
    this.customOffset,
    this.customPosition,
    required this.svgHeight,
    required this.items,
  });

  final String svgLink;
  final double svgHeight;
  final Offset? customOffset;
  final Widget? customButtonWidget;
  final double? customWidth;
  final PullDownMenuPosition? customPosition;
  final List<ItemWithTitleAndCallback> items;

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) => items
          .map((e) => CustomPullDownItem(
                            onTap:
                        // jumpToCategory(widget.buttons.indexOf(e));
                        e.onClickCallback,
                    title: e.title,
                    svgLink: e.thumbnailLink,
                  )
              // PullDownMenuItem(
              //       onTap:
              //           // jumpToCategory(widget.buttons.indexOf(e));
              //           e.onClickCallback,
              //       title: e.title,
              //
              //       textStyle: mainStyle(context, 13, weight: FontWeight.w700, color: newDarkGreyColor),
              //     )
              )
          .toList(),
      position: customPosition ?? PullDownMenuPosition.over,
      backgroundColor: Colors.white.withOpacity(0.75),
      offset: customOffset ?? const Offset(-2, 1),
      applyOpacity: true,
      widthConfiguration: PullDownMenuWidthConfiguration(customWidth ?? 0.77.sw,),
      buttonBuilder: (context, showMenu) => GestureDetector(
        onTap: showMenu,
        child: customButtonWidget ??
            Container(
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  svgLink,
                  height: svgHeight,
                ),
              ),
            ),
      ),
    );
  }
}

class AddPlusCircle extends StatelessWidget {
  const AddPlusCircle({
    super.key,
    this.callBack,
  });

  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: SvgPicture.asset(
        'assets/svg/icons/addcircle.svg',
        color: mainBlueColor,
        height: Responsive.isMobile(context) ? 25.w : 12.w,
      ),
    );
  }
}

class ProviderProfileDashboard extends StatefulWidget {
  const ProviderProfileDashboard({
    super.key,
  });

  @override
  State<ProviderProfileDashboard> createState() => _ProviderProfileDashboardState();
}

class _ProviderProfileDashboardState extends State<ProviderProfileDashboard> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    ProfileCubit.get(context).toggleSettingExpanded(customVal: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;

    return Container(
      color: newLightGreyColor,
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          // TODO: implement listener
          user = mainCubit.userInfoModel!.data.user;
        },
        builder: (context, state) {
          return SingleChildScrollView(
              controller: controller,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleUserCard(
                      provider: user,
                      justView: true,
                      currentLayout: 'provider',
                    ),
                    heightBox(10.h),
                    MyDashboardProviderSection(),
                    heightBox(10.h),
                    OurLocationSection(
                      provider: user,
                      viewTitleInProfileLayout: true,
                      providersLocations: [
                        ProviderLocationModel(
                          id: user.id,
                          name: user.fullName.toString(),
                          distance: user.distance.toString(),
                          image: user.personalPicture.toString(),
                          lat: user.lat.toString(),
                          lng: user.lng.toString(),
                          phone: user.phone.toString(),
                        )
                      ],
                      // viewTitleInProfileLayout: true,
                    ),
                    heightBox(10.h),
                    ContactUsSection(
                      provider: user,
                    ),
                    heightBox(10.h),
                    FollowUsSection(
                      provider: user,
                    ),
                    heightBox(10.h),
                    SettingsSection(
                      controller: controller,
                    ),
                    heightBox(10.h),
                    LogoutButton(
                      title: 'Log out',
                      callBack: () {
                        AuthCubit.get(context).logout(context);
                      },
                    ),
                    heightBox(10.h),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class ClientProfileDashboard extends StatefulWidget {
  const ClientProfileDashboard({
    super.key,
  });

  @override
  State<ClientProfileDashboard> createState() => _ClientProfileDashboardState();
}

class _ClientProfileDashboardState extends State<ClientProfileDashboard> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    ProfileCubit.get(context).toggleSettingExpanded(customVal: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return Container(
      color: newLightGreyColor,
      height: double.maxFinite,
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          // TODO: implement listener
          user = mainCubit.userInfoModel!.data.user;
        },
        builder: (context, state) {
          return SingleChildScrollView(
              controller: controller,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleUserCard(
                      provider: user,
                      justView: true,
                      currentLayout: 'provider',
                    ),
                    heightBox(10.h),
                    MyDashboardClientSection(),
                    heightBox(10.h),
                    SettingsSection(
                      controller: controller,
                    ),
                    heightBox(10.h),

                    LogoutButton(
                      title: 'Log out',
                      callBack: () {
                        AuthCubit.get(context).logout(context);
                      },
                    ),
                    heightBox(10.h),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return DefaultShadowedContainer(
      width: double.maxFinite,
      childWidget: Padding(
        padding: EdgeInsets.all(defaultHorizontalPadding),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTitle(title: 'Settings'),
                    GestureDetector(
                      onTap: () async {
                        profileCubit.toggleSettingExpanded();
                        if (profileCubit.isSettingExpanded) {
                          await Future.delayed(Duration(milliseconds: 100));
                          controller.animateTo(controller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                      child: AnimatedRotation(
                        duration: Duration(milliseconds: 200),
                        turns: profileCubit.isSettingExpanded ? 0.25 : 0,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                        ),
                      ),
                    )
                  ],
                ),
                if (profileCubit.isSettingExpanded)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightBox(10.h),
                        SettingButton(
                          title: 'Edit profile',
                          callBack: () {
                            logg('Edit profile');
                          },
                        ),
                        heightBox(10.h),
                        SettingButton(
                          title: 'Setting',
                        ),
                        // heightBox(10.h),
                        // SettingButton(
                        //   title: 'Log out',
                        //   callBack: (){
                        //     AuthCubit.get(context).logout(context);
                        //   },
                        // ),
                        // heightBox(10.h),
                      ],
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({
    super.key,
    required this.title,
    this.callBack,
  });

  final String title;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultShadowedContainer(
          width: double.maxFinite,
          childWidget: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding * 1.2),
            child: Text(
              title,
              style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
            ),
          )),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    required this.title,
    this.callBack,
  });

  final String title;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultShadowedContainer(
          width: double.maxFinite,
          childWidget: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding * 1.2),
            child: Center(
              child: Text(
                title,
                style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
              ),
            ),
          )),
    );
  }
}

class MyDashboardProviderSection extends StatelessWidget {
  const MyDashboardProviderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        // vertical: defaultHorizontalPadding,
      ),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitle(title: 'My Dashboard'),
              heightBox(10.h),
              GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 1.72,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                children: profileCubit
                    .userProfileButtons(context)
                    .map((e) => ProfileButtonCard(
                          button: e,
                        ))
                    .toList(),
              )
            ],
          );
        },
      ),
      // Title(''),
    );
  }
}

class MyDashboardClientSection extends StatelessWidget {
  const MyDashboardClientSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        // vertical: defaultHorizontalPadding,
      ),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitle(title: 'My Dashboard'),
              heightBox(10.h),
              GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 1.72,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                children: profileCubit
                    .userProfileButtons(context)
                    .map((e) => ProfileButtonCard(
                          button: e,
                        ))
                    .toList(),
              )
            ],
          );
        },
      ),
      // Title(''),
    );
  }
}

class ProfileButtonCard extends StatelessWidget {
  const ProfileButtonCard({
    super.key,
    required this.button,
  });

  final ItemWithTitleAndCallback button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: button.onClickCallback,
      child: DefaultShadowedContainer(
          childWidget: Center(
              child: Padding(
        padding: EdgeInsets.all(defaultHorizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('data'),
                  if (button.thumbnailLink != null)
                    Expanded(
                      child: SvgPicture.asset(
                        button.thumbnailLink!,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        width: 35.w,
                        // width: 22,
                      ),
                    ),
                  NotificationCounterBubble(counter: button.count ?? '0'),
                ],
              ),
            ),
            heightBox(5.h),
            Text(
              button.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 12, color: newDarkGreyColor, isBold: true),
            ),
          ],
        ),
      ))),
    );
  }
}
