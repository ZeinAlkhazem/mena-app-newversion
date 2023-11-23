import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/widgets/newWidgets/pull_down.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/cache/cache.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/main_cubit/main_cubit.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../add_people_to_live/widget/live_bubble.dart';
import '../../../auth_screens/sign_in_screen.dart';
import '../../../main_layout/main_layout.dart';
import '../../../messenger/cubit/messenger_cubit.dart';
import '../../../messenger/screens/messenger_get_start_page.dart';
import '../../../messenger/screens/messenger_home_page.dart';
import '../../../my_profile/my_profile.dart';

class ContentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                logg('profile bubble clicked');
                navigateToWithoutNavBar(
                    context,
                    getCachedToken() == null ? SignInScreen() : MyProfile(),
                    '');
              },
              child: getCachedToken() == null
                  ? SvgPicture.asset(
                      'assets/svg/icons/profileFilled.svg',
                      height: Responsive.isMobile(context) ? 30.w : 12.w,
                    )
                  :
                   ProfileImage(
                      isOnline: true,
                      customRingColor: Colors.transparent,
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
          ),
          Text(
            "ContentBlend",
            style: TextStyle(
              color: Color(0xFF444444),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              // height: 0.03,
            ),
          ),
          Spacer(),
          AppBarIcons(
            btnClick: () {
              if (getCachedToken() == null) {
                viewMessengerLoginAlertDialog(context);
              } else if (MessengerCubit.get(context)
                  .myMessagesModel!
                  .data
                  .myChats!
                  .isEmpty) {
                navigateToWithoutNavBar(
                    context, const MessengerGetStartPage(), '');
              } else {
                navigateToWithoutNavBar(context, const MessengerHomePage(), '');
              }
            },
            icon: 'assets/new_icons/message_outline_28.svg',
            iconSize: 28,
            // width: 12,
            top: 1,
            bottom: 4,
            // right: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 3),
            child: PullDown(
              svgHeight: Responsive.isMobile(context) ? 25.w : 12.w,
              customWidth: 0.485.sw,
              customOffset: Offset(-30, 12),
              customPosition: PullDownMenuPosition.under,
              customButtonWidget: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SvgPicture.asset(
                  "assets/new_icons/add_circle_outline_28.svg",
                  color: Color(0xff2A87EA),
                  width: 28,
                ),
              ),
              items: FeedsCubit.get(context).userActionItems(context),
              svgLink: "assets/new_icons/add_circle_outline_28.svg",
            ),
          ),
          AppBarIcons(
            btnClick: () {},
            icon: 'assets/icons/search_20 3.svg',
            iconSize: 28,
            width: 12,
            top: 1,
            bottom: 4,
            // right: 3,
          ),
        ],
      ),

      // leadingWidth: 90,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}




class ProfileImage extends StatelessWidget {
  const ProfileImage(
      {Key? key,
      required this.isOnline,
      this.radius,
      this.pictureUrl,
      this.onlyView = true,
      this.customRingColor})
      : super(key: key);
  final bool isOnline;
  final double? radius;
  final Color? customRingColor;
  final String? pictureUrl;
  final bool onlyView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onlyView ? null : () {},
      child: CircleAvatar(
        radius: radius != null ? radius! + 1.sp : 30.sp,
        backgroundColor:
            isOnline ? customRingColor ?? mainGreenColor : Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: CircleAvatar(
                radius: radius ?? 30.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: (radius ?? 30.sp) - 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isOnline
                        ? radius == null
                            ? 26.sp
                            : (radius! - (radius! * 0.01))
                        : radius ?? 30.sp),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: DefaultImage(
                        backGroundImageUrl: pictureUrl ?? '',
                        backColor: newLightGreyColor,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: NotificationCounterBubble(isOnline: isOnline),
            // ),
          ],
        ),
      ),
    );
  }
}