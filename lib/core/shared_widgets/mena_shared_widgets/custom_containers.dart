import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/live_screens/watcher_screen.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../models/api_model/feeds_model.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/api_model/lives_model.dart';
import '../../../models/local_models.dart';
import '../../../modules/create_live/widget/default_button.dart';
import '../../../modules/feeds_screen/feed_details.dart';
import '../../../modules/feeds_screen/feed_videos_scroll.dart';
import '../../../modules/feeds_screen/feeds_screen.dart';
import '../../../modules/feeds_screen/widgets/feed_text_extended.dart';
import '../../../modules/feeds_screen/widgets/follow_user_button.dart';
import '../../../modules/feeds_screen/widgets/icon_with_text.dart';
import '../../../modules/live_screens/live_screen.dart';
import '../../../modules/messenger/chat_layout.dart';
import '../../../modules/messenger/messenger_layout.dart';
import '../../../modules/plans_screen/plans_layout.dart';
import '../../../modules/platform_provider/provider_home/provider_profile.dart';

class CurrentPlanContainer extends StatelessWidget {
  const CurrentPlanContainer({
    Key? key,
    required this.plan,
  }) : super(key: key);
  final String plan;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getCachedToken() == null
            ? viewLoginAlertDialog(context)
            : navigateToAndFinishUntil(context, const PlansLayout());
      },
      child: Container(
        height: 22.sp,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(42),
          ),
          color: Color.fromRGBO(253, 199, 7, 0.20000000298023224),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: Center(
          child: Text(
            plan,
            textAlign: TextAlign.center,
            style: mainStyle(
              context,
              12,
              color: Color.fromRGBO(210, 165, 4, 1.0),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorButton extends StatelessWidget {
  const SelectorButton({
    Key? key,
    required this.title,
    required this.isSelected,
    this.customRadius,
    this.onClick,
    this.customHeight,
    this.customFontSize,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final double? customHeight;
  final double? customFontSize;
  final double? customRadius;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: customHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(customRadius ?? 42.sp),
          ),
          color: isSelected ? mainBlueColor : newLightGreyColor,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 7.h,
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: mainStyle(
              context,
              customFontSize ?? 12,
              color: isSelected ? Colors.white : newDarkGreyColor,
              isBold: true,
              // weight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class NewSelectorButton extends StatelessWidget {
  const NewSelectorButton({
    Key? key,
    required this.title,
    required this.isSelected,
    this.customRadius,
    this.onClick,
    this.customHeight,
    this.customFontSize,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final double? customHeight;
  final double? customFontSize;
  final double? customRadius;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            height: customHeight,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 3,
                      // style: BorderStyle.solid,
                      color: isSelected
                          ? mainBlueColor
                          : newDarkGreyColor.withOpacity(0.7))),
              // borderRadius: BorderRadius.all(
              //   Radius.circular(0.sp),
              // ),
              // color: isSelected ? mainBlueColor : newLightGreyColor,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 7.h,
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: mainStyle(
                  context,
                  customFontSize ?? 12,
                  color: isSelected ? mainBlueColor : newDarkGreyColor,
                  isBold: true,
                  // weight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // if(isSelected)Container(
          //   height: 2,
          //   width: 300,
          //   color: Colors.red,
          //
          // )
        ],
      ),
    );
  }
}

class SmoothBorderContainer extends StatelessWidget {
  const SmoothBorderContainer({
    Key? key,
    required this.thumbNail,
    this.cornerRadius,
    this.customWidth,
    this.customHeight,
    this.withShadow = true,
  }) : super(key: key);

  final String thumbNail;
  final double? cornerRadius;
  final double? customWidth;
  final double? customHeight;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0.sp),

      /// this padding important for shadow
      child: Container(
        width: customWidth ?? double.maxFinite,
        height: customHeight ?? double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SmoothBorderRadius(
              cornerRadius: cornerRadius ?? defaultRadiusVal,
              cornerSmoothing: 0.8,
            ),
            boxShadow: withShadow ? mainBoxShadow : null),
        child: DefaultImage(
          backGroundImageUrl: thumbNail,
          radius: cornerRadius ?? defaultRadiusVal,
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ContainerWithBottom extends StatelessWidget {
  const ContainerWithBottom({
    Key? key,
    required this.bottom,
    required this.imgUrl,
  }) : super(key: key);

  final Widget bottom;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DefaultImage(
            backGroundImageUrl: imgUrl,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(32, 32, 32, 0.25),
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        heightBox(6.h),
        bottom
      ],
    );
  }
}

class LiveProfileBubble extends StatelessWidget {
  const LiveProfileBubble({
    Key? key,
    required this.requiredWidth,
    required this.name,
    required this.liveTitle,
    required this.liveGoal,
    required this.liveTopic,
    required this.liveId,
    required this.thumbnailUrl,
  }) : super(key: key);

  final double requiredWidth;
  final String name;
  final String liveTitle;
  final String liveGoal;
  final String liveTopic;
  final String? liveId;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                liveId == null
                    ? null
                    : navigateToWithoutNavBar(context, WatcherScreen(), '',
                        onBackToScreen: () {
                        logg('khgkajscn');

                        ScreenUtil.init(context,
                            designSize: const Size(360, 770),
                            splitScreenMode: true
                            // width: 750, height: 1334, allowFontScaling: false
                            );
                      });
              },
              child: SizedBox(
                height: requiredWidth + 6.sp,
                child: Stack(children: <Widget>[
                  Container(
                    width: requiredWidth + 3,
                    height: requiredWidth + 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(66.sp),
                      ),
                      color: newLightGreyColor,
                      border: Border.all(
                        color: mainBlueColor,
                        width: 1.7,
                      ),
                    ),
                    child: Container(
                        width: requiredWidth,
                        height: requiredWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(66.sp),
                          ),
                          color: newLightGreyColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.2,
                          ),
                          image: DecorationImage(
                              image: NetworkImage(thumbnailUrl),
                              fit: BoxFit.fitWidth,
                              onError: (object, stackTrace) =>
                                  const ImageLoadingError()),
                        )),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: requiredWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(1.sp),
                                ),
                                color: mainBlueColor,
                                border: Border.all(
                                  color: mainBlueColor,
                                  width: 0.5,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.sp,
                                vertical: 3.sp,
                              ),
                              child: Text(
                                'LIVE',
                                style: mainStyle(context, 5,
                                    isBold: true, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )),
                ]),
              ),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          width: requiredWidth + 13.sp,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: mainStyle(context, 9, weight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class NearbyContainer extends StatelessWidget {
  const NearbyContainer(
      {Key? key,
      required this.customWidth,
      this.customHeight,
      required this.title,
      required this.imageUrl})
      : super(key: key);
  final double customWidth;
  final double? customHeight;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DefaultShadowedContainer(
            childWidget: DefaultImage(
              backGroundImageUrl: imageUrl,
              boxFit: BoxFit.contain,
              width: customWidth,
              radius: defaultRadiusVal,
            ),
          ),
        ),
        heightBox(5.h),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset('assets/svg/icons/location.svg', height: 15.sp),
              widthBox(2.w),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: mainStyle(context, 10,
                      color: mainBlueColor, weight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
        heightBox(5.h),
      ],
    );
  }
}

class EventContainer extends StatelessWidget {
  const EventContainer({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(defaultRadiusVal),
      dashPattern: const [7, 4],
      color: mainBlueColor,
      strokeWidth: 1,
      child: SizedBox(
          height: double.maxFinite,
          width: 277.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: DefaultImage(
                backGroundImageUrl: imageUrl,
              )),
              heightBox(10.h),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Text(
                    title,
                    style: mainStyle(context, 18),
                  )),
              heightBox(5.h),
            ],
          )),
    );
  }
}

///Promotions
class PromotionContainer extends StatelessWidget {
  const PromotionContainer({
    Key? key,
    required this.imageUrl,
    this.title,
    this.price,
    this.location,
  }) : super(key: key);

  final String imageUrl;
  final String? title;
  final String? price;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(32, 32, 32, 0.25),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultImage(backGroundImageUrl: imageUrl),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ $price',
                      style: mainStyle(context, 13, weight: FontWeight.w800),
                    ),
                    SvgPicture.asset(
                      'assets/svg/icons/share.svg',
                      height: 20.w,
                    ),
                  ],
                ),
                Text(
                  location!,
                  style: mainStyle(context, 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileBubble extends StatelessWidget {
  const ProfileBubble(
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
      onTap: onlyView
          ? null
          : () {
              navigateToWithoutNavBar(
                  context,
                  ProviderProfileLayout(
                    providerId: MainCubit.get(context)
                        .userInfoModel!
                        .data
                        .user
                        .id
                        .toString(),
                    lastPageAppbarTitle: 'Home',
                  ),
                  'routeName');
            },
      child: CircleAvatar(
        radius: radius != null ? radius! + 1.sp : 30.sp,
        backgroundColor: Colors.white,
        //     isOnline ? customRingColor ?? mainGreenColor : Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: CircleAvatar(
                radius: isOnline
                    ? radius == null
                        ? 27.sp
                        : (radius! - (radius! * 0.001))
                    : radius ?? 30.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: (isOnline
                          ? radius == null
                              ? 27.sp
                              : (radius! - (radius! * 0.001))
                          : radius ?? 30.sp) -
                      1.5,
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
                        boxFit: BoxFit.contain,
                        // borderColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!onlyView)
              Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset('assets/svg/icons/profileFilled.svg',
                    height: 24.sp),
              )
          ],
        ),
      ),
    );
  }
}

class LoginBubble extends StatelessWidget {
  const LoginBubble(
      {Key? key, required this.isOnline, this.radius, this.pictureUrl})
      : super(key: key);
  final bool isOnline;
  final double? radius;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToWithoutNavBar(context, SignInScreen(), 'routeName');
      },
      child: CircleAvatar(
        radius: radius != null ? radius! + 1.sp : 31.sp,
        backgroundColor: isOnline ? mainGreenColor : Colors.transparent,
        child: CircleAvatar(
          radius: isOnline
              ? radius == null
                  ? 27.sp
                  : (radius! - (radius! * 0.001))
              : radius ?? 30.sp,
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isOnline
                ? radius == null
                    ? 27.sp
                    : (radius! - (radius! * 0.01))
                : radius ?? 30.sp),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SvgPicture.asset(
                'assets/svg/icons/profileFilled.svg',
                height: 62.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class SumMsgContainer extends StatelessWidget {
//   const SumMsgContainer({Key? key, required this.isNotRead}) : super(key: key);
//
//   final bool isNotRead;
//
//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }

class SharedFloatingMessenger extends StatelessWidget {
  const SharedFloatingMessenger({
    Key? key,
    required this.heroTag,
  }) : super(key: key);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: mainBlueColor,
      onPressed: () {
        getCachedToken() == null
            ? viewMessengerLoginAlertDialog(context)
            : navigateToWithoutNavBar(context, const MessengerLayout(), '');
      },
      elevation: 5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/svg/icons/msngr.svg',
              width: 33,
            ),
          ),
          const Positioned(
            right: 4,
            child: NotificationCounterBubble(counter: '23'),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  ///
}

class FloatingLive extends StatelessWidget {
  const FloatingLive({
    Key? key,
    required this.heroTag,
  }) : super(key: key);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: alertRedColor,
      onPressed: () {
        getCachedToken() == null
            ? viewMessengerLoginAlertDialog(context)
            : navigateToWithoutNavBar(context, const MessengerLayout(), '');
      },
      elevation: 5,
    );
  }
}

class LiveContainerLiveNow extends StatelessWidget {
  const LiveContainerLiveNow({
    Key? key,
    // this.liveDate,
    required this.liveItem,
    // required this.user,
    // required this.liveTitle,
    // required this.liveGoal,
    // required this.liveTopic,
    // required this.liveId,
    // required this.liveId,
    // required this.isCoHost,
  }) : super(key: key);

  final LiveByCategoryItem liveItem;

  // final DateTime? liveDate; // if null it's live now
  //
  // final String thumbnail;
  // final String liveTitle;
  // final String liveGoal;
  // final String liveTopic;
  // final String? liveId;
  //
  // final User? user;
  // final bool? isCoHost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToWithoutNavBar(
          context,
          WatcherScreen(),
          '',
          onBackToScreen: () {
            logg('ksahfkjlsnkxl');
            // ScreenUtil.init(context,
            //     designSize: const Size(360, 770), splitScreenMode: true);
          },
        );
      },
      child: DefaultShadowedContainer(
        width: double.maxFinite,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              heightBox(7.h),
              if (liveItem.provider == null)
                SizedBox()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigateToWithoutNavBar(
                                context,
                                ProviderProfileLayout(
                                    providerId:
                                        liveItem.provider!.id.toString(),
                                    lastPageAppbarTitle: 'back'),
                                'routeName');
                          },
                          child: Row(
                            children: [
                              widthBox(defaultHorizontalPadding),
                              ProfileBubble(
                                isOnline: false,
                                radius: 21.sp,
                                customRingColor: mainBlueColor,
                                pictureUrl: liveItem.provider!.personalPicture,
                              ),
                              widthBox(10.w),
                              Flexible(
                                child: SizedBox(
                                  // height: 44.sp,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // color: Colors.red,
                                                constraints: BoxConstraints(
                                                    maxWidth: 133.w),
                                                child: Text(
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  '${liveItem.provider!.abbreviation == null ? '' : '${liveItem.provider!.abbreviation!.name} '}${liveItem.provider!.fullName}',
                                                  style: mainStyle(context, 13,
                                                      weight: FontWeight.w800),
                                                ),
                                              ),
                                              (liveItem.provider!.verified ==
                                                      '1')
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0),
                                                      child: Icon(
                                                        Icons.verified,
                                                        color:
                                                            Color(0xff01BC62),
                                                        size: 16.sp,
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                          // Text.rich(
                                          //   maxLines: 2,softWrap: true,
                                          //   overflow: TextOverflow.ellipsis,
                                          //   TextSpan(
                                          //     children: [
                                          //       TextSpan(
                                          //         text:
                                          //             "${chat.user!.abbreviation == null ? '' : chat.user!.abbreviation!.name} ${chat.user!.fullName}",
                                          //         style:
                                          //             mainStyle(context, 13, weight: FontWeight.w600),
                                          //         // spellOut: false
                                          //       ),
                                          //       if (chat.user!.verified == '1')
                                          //         WidgetSpan(
                                          //           child: Padding(
                                          //             padding:
                                          //                 const EdgeInsets.symmetric(horizontal: 3.0),
                                          //             child: Icon(
                                          //               Icons.verified,
                                          //               color: Color(0xff01BC62),
                                          //               size: 16.sp,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // Text(
                                          //   chat.user!.fullName.toString(),
                                          //   style: mainStyle(
                                          //       context, 14, weight: FontWeight.w800),
                                          // ),
                                        ],
                                      ),
                                      Text(
                                        liveItem.provider!.speciality == null
                                            ? liveItem.provider!.specialities!
                                                    .isNotEmpty
                                                ? liveItem.provider!
                                                    .specialities![0].name
                                                : '--'
                                            : liveItem.provider!.speciality,
                                        style: mainStyle(context, 10,
                                            color: mainBlueColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (getCachedToken() != null)
                        Row(
                          children: [
                            // if (!isMyFeeds)
                            FollowUSerButton(
                              user: liveItem.provider!,
                            ),
                            // widthBox(1.w),
                            PullDownButton(
                              itemBuilder: (innerContext) {
                                List<FeedActionItem> actionItems =
                                    // isMyFeeds
                                    //     ? [
                                    //   FeedActionItem(
                                    //     id: '0',
                                    //     title: getTranslatedStrings(context).hide,
                                    //   ),
                                    //   FeedActionItem(
                                    //     id: '1',
                                    //     title: getTranslatedStrings(context).report,
                                    //   ),
                                    //   FeedActionItem(
                                    //     id: '2',
                                    //     title: getTranslatedStrings(context).delete,
                                    //   ),
                                    //   FeedActionItem(
                                    //     id: '3',
                                    //     title: getTranslatedStrings(context).edit,
                                    //   ),
                                    // ]
                                    //     :
                                    [
                                  FeedActionItem(
                                    id: '0',
                                    title:
                                        getTranslatedStrings(context).hidePost,
                                  ),
                                  FeedActionItem(
                                    id: '1',
                                    title: getTranslatedStrings(context)
                                        .reportPost,
                                  ),
                                ];
                                return actionItems
                                    .map((e) => PullDownMenuItem(
                                          onTap: () async {
                                            if (e.id == '0') {
                                              showMyAlertDialog(
                                                context,
                                                getTranslatedStrings(context)
                                                    .hideFeed,
                                                isTitleBold: true,
                                                alertDialogContent: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getTranslatedStrings(
                                                              context)
                                                          .areYouSureYouWatHideFeed,
                                                      style: mainStyle(
                                                          context, 14,
                                                          color:
                                                              newDarkGreyColor,
                                                          isBold: true),
                                                    ),
                                                    heightBox(15.h),
                                                    Text(
                                                      getTranslatedStrings(
                                                              context)
                                                          .thePrivacyWillChangeToOnlyMe,
                                                      // textAlign: TextAlign.center,
                                                      style: mainStyle(
                                                          context, 11,
                                                          color:
                                                              newLightTextGreyColor,
                                                          weight:
                                                              FontWeight.w700),
                                                    ),
                                                    heightBox(10.h),
                                                    Center(
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    0.5.sw),
                                                        child: BlocConsumer<
                                                            FeedsCubit,
                                                            FeedsState>(
                                                          listener:
                                                              (context, state) {
                                                            // TODO: implement listener
                                                          },
                                                          builder:
                                                              (context, state) {
                                                            return state
                                                                    is DeletingFeedsState
                                                                ? LinearProgressIndicator()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: DefaultButton(
                                                                        height: 28.h,
                                                                        withoutPadding: true,
                                                                        onClick: () {
                                                                          // feedsCubit
                                                                          //     .hideFeed(feedId: menaFeed.id.toString())
                                                                          //     .then((value) {
                                                                          //   feedsCubit.getFeeds(
                                                                          //       providerId: isMyFeeds
                                                                          //           ? menaFeed.user!.id.toString()
                                                                          //           : null);
                                                                          //   Navigator.pop(context);
                                                                          // });
                                                                        },
                                                                        text: getTranslatedStrings(context).hide),
                                                                  );
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                // actions: [
                                                //   BlocConsumer<FeedsCubit, FeedsState>(
                                                //     listener: (context, state) {
                                                //       // TODO: implement listener
                                                //     },
                                                //     builder: (context, state) {
                                                //       return state is DeletingFeedsState
                                                //           ? LinearProgressIndicator()
                                                //           : TextButton(
                                                //               onPressed: () {
                                                //                 feedsCubit.hideFeed(feedId: menaFeed.id.toString()).then((value) {
                                                //                   feedsCubit.getFeeds(
                                                //                       providerId:
                                                //                           isMyFeeds ? menaFeed.user!.id.toString() : null);
                                                //                   Navigator.pop(context);
                                                //                 });
                                                //               },
                                                //               child: Text('Yes'));
                                                //     },
                                                //   ),
                                                //   TextButton(
                                                //       onPressed: () {
                                                //         Navigator.pop(context);
                                                //       },
                                                //       child: Text('No')),
                                                // ]
                                              );
                                              // feedsCubit.updateFeed();
                                            } else if (e.id == '2') {
                                              // Navigator.pop(context);

                                              showMyAlertDialog(
                                                context,
                                                getTranslatedStrings(context)
                                                    .deleteFeed,
                                                isTitleBold: true,
                                                alertDialogContent: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      getTranslatedStrings(
                                                              context)
                                                          .areYouSureDelete,
                                                      style: mainStyle(
                                                          context, 14,
                                                          color:
                                                              newDarkGreyColor,
                                                          isBold: true),
                                                    ),
                                                    heightBox(10.h),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 0.5.sw),
                                                      child: Row(
                                                        children: [
                                                          BlocConsumer<
                                                              FeedsCubit,
                                                              FeedsState>(
                                                            listener: (context,
                                                                state) {
                                                              // TODO: implement listener
                                                            },
                                                            builder: (context,
                                                                state) {
                                                              return state
                                                                      is DeletingFeedsState
                                                                  ? LinearProgressIndicator()
                                                                  : Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: DefaultButton(
                                                                            height: 28.h,
                                                                            withoutPadding: true,
                                                                            onClick: () {
                                                                              // feedsCubit
                                                                              //     .deleteFeed(feedId: menaFeed.id.toString())
                                                                              //     .then((value) {
                                                                              //   feedsCubit.getFeeds(
                                                                              //       providerId: (isMyFeeds && !inPublicFeeds)
                                                                              //           ? menaFeed.user!.id.toString()
                                                                              //           : null);
                                                                              //   Navigator.pop(context);
                                                                              // });
                                                                            },
                                                                            text: getTranslatedStrings(context).yes),
                                                                      ),
                                                                    );
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  DefaultButton(
                                                                      height:
                                                                          28.h,
                                                                      withoutPadding:
                                                                          true,

                                                                      // width: 0.1.sw,
                                                                      backColor:
                                                                          newLightTextGreyColor,
                                                                      borderColor:
                                                                          newLightTextGreyColor,
                                                                      titleColor:
                                                                          Colors
                                                                              .black,
                                                                      onClick:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      text: getTranslatedStrings(
                                                                              context)
                                                                          .no),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                // actions: [
                                                //
                                                // ]
                                              );
                                              // feedsCubit.deleteFeed();
                                            } else if (e.id == '1') {
                                              // Navigator.pop(context);
                                              TextEditingController
                                                  textEditingController =
                                                  TextEditingController();
                                              showMyBottomSheet(
                                                  context: context,
                                                  title: getTranslatedStrings(
                                                          context)
                                                      .report,
                                                  body: Column(children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          getTranslatedStrings(
                                                                  context)
                                                              .reportDescription,
                                                          style: mainStyle(
                                                              context, 14,
                                                              color:
                                                                  Colors.black,
                                                              weight: FontWeight
                                                                  .w700),
                                                        ),
                                                        Text(
                                                          '0/200',
                                                          style: mainStyle(
                                                              context, 12,
                                                              color:
                                                                  newDarkGreyColor,
                                                              weight: FontWeight
                                                                  .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    // heightBox(15.h),
                                                    // Text(
                                                    //   'Provide details to help us understand the problem',
                                                    //   style: mainStyle(context, 13, color: newDarkGreyColor,weight: FontWeight.normal),
                                                    // ),
                                                    heightBox(5.h),
                                                    DefaultInputField(
                                                      controller:
                                                          textEditingController,
                                                      focusedBorderColor:
                                                          Colors.transparent,
                                                      unFocusedBorderColor:
                                                          Colors.transparent,
                                                      floatingLabelAlignment:
                                                          FloatingLabelAlignment
                                                              .start,
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                      // customHintText: 'Provide details to help us understand the problem',
                                                      withoutLabelPadding: true,
                                                      maxLines: 3,
                                                      label: getTranslatedStrings(
                                                              context)
                                                          .provideDetailsHelpUnderstandProblem,
                                                      // labelWidget: Text(
                                                      //   getTranslatedStrings(context).provideDetailsHelpUnderstandProblem,
                                                      //   style: mainStyle(context, 10, color: newDarkGreyColor),
                                                      // ),
                                                    ),

                                                    heightBox(15.h),
                                                    BlocConsumer<FeedsCubit,
                                                        FeedsState>(
                                                      listener:
                                                          (context, state) {
                                                        // TODO: implement listener
                                                      },
                                                      builder:
                                                          (context, state) {
                                                        var feedsCubit =
                                                            FeedsCubit.get(
                                                                context);
                                                        return Container(
                                                          height: 0.22.sw,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Row(
                                                              children: [
                                                                ListView
                                                                    .separated(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return AttachedFileHandle(
                                                                      xfile: feedsCubit
                                                                              .attachedReportFiles[
                                                                          index],
                                                                      customWidthForHorizontalView:
                                                                          0.18.sw,
                                                                      customHeight:
                                                                          double
                                                                              .maxFinite,
                                                                      fn: () {
                                                                        feedsCubit
                                                                            .removeReportAttachments(index);
                                                                      },
                                                                    );
                                                                  },
                                                                  separatorBuilder: (c,
                                                                          i) =>
                                                                      widthBox(
                                                                          0.w),
                                                                  itemCount:
                                                                      feedsCubit
                                                                          .attachedReportFiles
                                                                          .length,
                                                                ),
                                                                if (feedsCubit
                                                                        .attachedReportFiles
                                                                        .length <
                                                                    4)
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      logg(
                                                                          'picking file');
                                                                      final ImagePicker
                                                                          _picker =
                                                                          ImagePicker();
                                                                      final List<
                                                                              XFile>?
                                                                          photos =
                                                                          await _picker
                                                                              .pickMultiImage();
                                                                      if (photos !=
                                                                          null) {
                                                                        feedsCubit.updateReportAttachedFile(
                                                                            null,
                                                                            xFiles:
                                                                                photos);
                                                                      }
                                                                    },
                                                                    child: DefaultContainer(
                                                                        height: double.maxFinite,
                                                                        width: 0.18.sw,
                                                                        borderColor: Colors.transparent,
                                                                        backColor: newLightGreyColor,
                                                                        childWidget: Center(
                                                                            child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              'assets/svg/icons/gallery.svg',
                                                                              color: newDarkGreyColor,
                                                                            ),
                                                                            heightBox(5.h),
                                                                            Text(
                                                                              '${feedsCubit.attachedReportFiles.length}/4',
                                                                              style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                                                                            )
                                                                          ],
                                                                        ))),
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    heightBox(5.h),
                                                    Divider(),
                                                    Text(
                                                      getTranslatedStrings(
                                                              context)
                                                          .immediatePhysicalDanger,
                                                      style: mainStyle(
                                                          context, 12,
                                                          color:
                                                              newDarkGreyColor),
                                                    ),
                                                    heightBox(10.h),
                                                    Row(
                                                      children: [
                                                        // Expanded(
                                                        //   child: DefaultButton(
                                                        //       onClick: () {
                                                        //         Navigator.pop(context);
                                                        //       },
                                                        //       backColor: newAuxSoftLightGreyColor,
                                                        //       height: 33.h,
                                                        //       titleColor: Colors.black,
                                                        //       borderColor: newAuxSoftLightGreyColor,
                                                        //       text: 'Cancel'),
                                                        // ),
                                                        // widthBox(7.w),
                                                        Expanded(
                                                          child: BlocConsumer<
                                                              FeedsCubit,
                                                              FeedsState>(
                                                            listener: (context,
                                                                state) {
                                                              // TODO: implement listener
                                                            },
                                                            builder: (context,
                                                                state) {
                                                              return state
                                                                      is ReportingFeedsState
                                                                  ? LinearProgressIndicator()
                                                                  : DefaultButton(
                                                                      height:
                                                                          33.h,
                                                                      withoutPadding:
                                                                          true,
                                                                      onClick:
                                                                          () {
                                                                        // if (textEditingController.text.isNotEmpty) {
                                                                        //   feedsCubit
                                                                        //       .reportFeed(
                                                                        //       feedId: menaFeed.id.toString(),
                                                                        //       reason: textEditingController.text)
                                                                        //       .then((value) {
                                                                        //     logg('jskhajdkfh: $inPublicFeeds , $isMyFeeds');
                                                                        //     feedsCubit.getFeeds(
                                                                        //         providerId: inPublicFeeds
                                                                        //             ? null
                                                                        //             : isMyFeeds
                                                                        //             ? menaFeed.user!.id.toString()
                                                                        //             : null);
                                                                        //     Navigator.pop(context);
                                                                        //   });
                                                                        // } else {
                                                                        //   showMyAlertDialog(context,
                                                                        //       getTranslatedStrings(context).reportReasonRequired,
                                                                        //       alertDialogContent: Text(
                                                                        //           getTranslatedStrings(context).explainReasons));
                                                                        // }
                                                                      },
                                                                      text: getTranslatedStrings(
                                                                              context)
                                                                          .sendReport);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]));
                                              // buildShowModalBottomSheet(context,
                                              //     body: Container(
                                              //       color: Colors.white,
                                              //       child: SafeArea(
                                              //         child: Padding(
                                              //           padding: const EdgeInsets.all(14.0),
                                              //           child: Container(
                                              //             child: Column(
                                              //               mainAxisSize: MainAxisSize.min,
                                              //               crossAxisAlignment: CrossAxisAlignment.start,
                                              //               children: [
                                              //                 Text(
                                              //                   getTranslatedStrings(context).report,
                                              //                   style: mainStyle(context, 16, isBold: true),
                                              //                 ),
                                              //                 Divider(),
                                              //                 heightBox(10.h),
                                              //                 Row(
                                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //                   children: [
                                              //                     Text(
                                              //                       getTranslatedStrings(context).reportDescription,
                                              //                       style: mainStyle(context, 14,
                                              //                           color: Colors.black, weight: FontWeight.w700),
                                              //                     ),
                                              //                     Text(
                                              //                       '0/200',
                                              //                       style: mainStyle(context, 12,
                                              //                           color: newDarkGreyColor, weight: FontWeight.w700),
                                              //                     ),
                                              //                   ],
                                              //                 ),
                                              //                 // heightBox(15.h),
                                              //                 // Text(
                                              //                 //   'Provide details to help us understand the problem',
                                              //                 //   style: mainStyle(context, 13, color: newDarkGreyColor,weight: FontWeight.normal),
                                              //                 // ),
                                              //                 heightBox(5.h),
                                              //                 DefaultInputField(
                                              //                   controller: textEditingController,
                                              //                   focusedBorderColor: Colors.transparent,
                                              //                   unFocusedBorderColor: Colors.transparent,
                                              //                   floatingLabelAlignment: FloatingLabelAlignment.start,
                                              //                   floatingLabelBehavior: FloatingLabelBehavior.never,
                                              //                   // customHintText: 'Provide details to help us understand the problem',
                                              //                   withoutLabelPadding: true,
                                              //                   maxLines: 3,
                                              //                   labelWidget: Text(
                                              //                     getTranslatedStrings(context).provideDetailsHelpUnderstandProblem,
                                              //                     style: mainStyle(context, 10, color: newDarkGreyColor),
                                              //                   ),
                                              //                 ),
                                              //
                                              //                 heightBox(15.h),
                                              //                 BlocConsumer<FeedsCubit, FeedsState>(
                                              //                   listener: (context, state) {
                                              //                     // TODO: implement listener
                                              //                   },
                                              //                   builder: (context, state) {
                                              //                     var feedsCubit = FeedsCubit.get(context);
                                              //                     return Container(
                                              //                       height: 0.22.sw,
                                              //                       color: Colors.white,
                                              //                       child: Padding(
                                              //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              //                         child: Row(
                                              //                           children: [
                                              //                             ListView.separated(
                                              //                               scrollDirection: Axis.horizontal,
                                              //                               padding: EdgeInsets.symmetric(horizontal: 4),
                                              //                               shrinkWrap: true,
                                              //                               itemBuilder: (context, index) {
                                              //                                 return AttachedFileHandle(
                                              //                                   xfile: feedsCubit.attachedReportFiles[index],
                                              //                                   customWidthForHorizontalView: 0.18.sw,
                                              //                                   customHeight: double.maxFinite,
                                              //                                   fn: () {
                                              //                                     feedsCubit.removeReportAttachments(index);
                                              //                                   },
                                              //                                 );
                                              //                               },
                                              //                               separatorBuilder: (c, i) => widthBox(0.w),
                                              //                               itemCount: feedsCubit.attachedReportFiles.length,
                                              //                             ),
                                              //                             if (feedsCubit.attachedReportFiles.length < 4)
                                              //                               GestureDetector(
                                              //                                 onTap: () async {
                                              //                                   logg('picking file');
                                              //                                   final ImagePicker _picker = ImagePicker();
                                              //                                   final List<XFile>? photos =
                                              //                                       await _picker.pickMultiImage();
                                              //                                   if (photos != null) {
                                              //                                     feedsCubit.updateReportAttachedFile(null,
                                              //                                         xFiles: photos);
                                              //                                   }
                                              //                                 },
                                              //                                 child: DefaultContainer(
                                              //                                     height: double.maxFinite,
                                              //                                     width: 0.18.sw,
                                              //                                     borderColor: Colors.transparent,
                                              //                                     backColor: newLightGreyColor,
                                              //                                     childWidget: Center(
                                              //                                         child: Column(
                                              //                                       mainAxisAlignment: MainAxisAlignment.center,
                                              //                                       children: [
                                              //                                         SvgPicture.asset(
                                              //                                           'assets/svg/icons/gallery.svg',
                                              //                                           color: newDarkGreyColor,
                                              //                                         ),
                                              //                                         heightBox(5.h),
                                              //                                         Text(
                                              //                                           '${feedsCubit.attachedReportFiles.length}/4',
                                              //                                           style: mainStyle(context, 12,
                                              //                                               color: newDarkGreyColor,
                                              //                                               weight: FontWeight.w700),
                                              //                                         )
                                              //                                       ],
                                              //                                     ))),
                                              //                               )
                                              //                           ],
                                              //                         ),
                                              //                       ),
                                              //                     );
                                              //                   },
                                              //                 ),
                                              //                 heightBox(5.h),
                                              //                 Divider(),
                                              //                 Text(
                                              //                   getTranslatedStrings(context).immediatePhysicalDanger,
                                              //                   style: mainStyle(context, 12, color: newDarkGreyColor),
                                              //                 ),
                                              //                 heightBox(10.h),
                                              //                 Row(
                                              //                   children: [
                                              //                     // Expanded(
                                              //                     //   child: DefaultButton(
                                              //                     //       onClick: () {
                                              //                     //         Navigator.pop(context);
                                              //                     //       },
                                              //                     //       backColor: newAuxSoftLightGreyColor,
                                              //                     //       height: 33.h,
                                              //                     //       titleColor: Colors.black,
                                              //                     //       borderColor: newAuxSoftLightGreyColor,
                                              //                     //       text: 'Cancel'),
                                              //                     // ),
                                              //                     // widthBox(7.w),
                                              //                     Expanded(
                                              //                       child: BlocConsumer<FeedsCubit, FeedsState>(
                                              //                         listener: (context, state) {
                                              //                           // TODO: implement listener
                                              //                         },
                                              //                         builder: (context, state) {
                                              //                           return state is ReportingFeedsState
                                              //                               ? LinearProgressIndicator()
                                              //                               : DefaultButton(
                                              //                                   height: 33.h,
                                              //                                   withoutPadding: true,
                                              //                                   onClick: () {
                                              //                                     if (textEditingController.text.isNotEmpty) {
                                              //                                       feedsCubit
                                              //                                           .reportFeed(
                                              //                                               feedId: menaFeed.id.toString(),
                                              //                                               reason: textEditingController.text)
                                              //                                           .then((value) {
                                              //                                         logg(
                                              //                                             'jskhajdkfh: $inPublicFeeds , $isMyFeeds');
                                              //                                         feedsCubit.getFeeds(
                                              //                                             providerId: inPublicFeeds
                                              //                                                 ? null
                                              //                                                 : isMyFeeds
                                              //                                                     ? menaFeed.user!.id.toString()
                                              //                                                     : null);
                                              //                                         Navigator.pop(context);
                                              //                                       });
                                              //                                     } else {
                                              //                                       showMyAlertDialog(
                                              //                                           context,
                                              //                                           getTranslatedStrings(context)
                                              //                                               .reportReasonRequired,
                                              //                                           alertDialogContent: Text(
                                              //                                               getTranslatedStrings(context)
                                              //                                                   .explainReasons));
                                              //                                     }
                                              //                                   },
                                              //                                   text: getTranslatedStrings(context).sendReport);
                                              //                         },
                                              //                       ),
                                              //                     ),
                                              //                   ],
                                              //                 ),
                                              //               ],
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ));
                                              // showMyAlertDialog(context, 'Report Feed',
                                              //     isTitleBold: true,
                                              //     alertDialogContent: Column(
                                              //       mainAxisSize: MainAxisSize.min,
                                              //       crossAxisAlignment: CrossAxisAlignment.start,
                                              //       children: [
                                              //         // heightBox(15.h),
                                              //         Row(
                                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //           children: [
                                              //             Text(
                                              //               'Report Description',
                                              //               style: mainStyle(context, 14,
                                              //                   color: Colors.black, weight: FontWeight.w700),
                                              //             ),
                                              //             Text(
                                              //               '0/200',
                                              //               style: mainStyle(context, 12,
                                              //                   color: newDarkGreyColor, weight: FontWeight.w700),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //         // heightBox(15.h),
                                              //         // Text(
                                              //         //   'Provide details to help us understand the problem',
                                              //         //   style: mainStyle(context, 13, color: newDarkGreyColor,weight: FontWeight.normal),
                                              //         // ),
                                              //         heightBox(5.h),
                                              //         DefaultInputField(
                                              //           controller: textEditingController,
                                              //           focusedBorderColor: Colors.transparent,
                                              //           unFocusedBorderColor: Colors.transparent,
                                              //           floatingLabelAlignment: FloatingLabelAlignment.start,
                                              //           floatingLabelBehavior: FloatingLabelBehavior.never,
                                              //           customHintText: 'Provide details to help us understand the problem',
                                              //           withoutLabelPadding: true,
                                              //           maxLines: 3,
                                              //           labelWidget: Text('Provide details to help us understand the problem',
                                              //             style: mainStyle(context, 10, color: newDarkGreyColor),
                                              //           ),
                                              //         )
                                              //       ],
                                              //     ),
                                              //     actions: [
                                              //       BlocConsumer<FeedsCubit, FeedsState>(
                                              //         listener: (context, state) {
                                              //           // TODO: implement listener
                                              //         },
                                              //         builder: (context, state) {
                                              //           return state is DeletingFeedsState
                                              //               ? LinearProgressIndicator()
                                              //               : TextButton(
                                              //                   onPressed: () {
                                              //                     feedsCubit
                                              //                         .reportFeed(
                                              //                             feedId: menaFeed.id.toString(),
                                              //                             reason: textEditingController.text)
                                              //                         .then((value) {
                                              //                       feedsCubit.getFeeds(
                                              //                           providerId:
                                              //                               isMyFeeds ? menaFeed.user!.id.toString() : null);
                                              //                       Navigator.pop(context);
                                              //                     });
                                              //                   },
                                              //                   child: Text('Send'));
                                              //         },
                                              //       ),
                                              //       TextButton(
                                              //           onPressed: () {
                                              //             Navigator.pop(context);
                                              //           },
                                              //           child: Text('Cancel')),
                                              //     ]);
                                              // feedsCubit.deleteFeed();
                                            } else if (e.id == '3') {
                                              /// update feed
                                              // navigateToWithoutNavBar(context, PostAFeedLayout(feed: menaFeed), '');
                                            } else {}
                                          },
                                          title: e.title,
                                          textStyle: mainStyle(context, 13,
                                              weight: FontWeight.w600,
                                              color: Color(0xff252525)),
                                        ))
                                    .toList();
                              },
                              position: PullDownMenuPosition.over,
                              backgroundColor: Colors.white.withOpacity(0.75),
                              offset: const Offset(-2, 1),
                              applyOpacity: true,
                              widthConfiguration:
                                  PullDownMenuWidthConfiguration(0.4.sw),
                              buttonBuilder: (context, showMenu) =>
                                  CupertinoButton(
                                onPressed: showMenu,
                                padding: EdgeInsets.zero,
                                child: SvgPicture.asset(
                                    'assets/svg/icons/3dots.svg'),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //
                            //   },
                            //   child: Container(
                            //       color: Colors.white,
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: SvgPicture.asset('assets/svg/icons/3dots.svg'),
                            //       )),
                            // )
                          ],
                        )
                    ],
                  ),
                ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: Column(
                  children: [
                    heightBox(7.h),
                    FeedTextExtended(
                      text: liveItem.title ?? '',
                      maxLines: 3,
                    ),
                    heightBox(7.h),
                    Stack(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Center(
                            child: DefaultImageFadeInOrSvg(
                              backGroundImageUrl: liveItem.image ?? '',
                              radius: defaultRadiusVal,
                              boxConstraints: BoxConstraints(
                                minHeight: 0.2.sh,
                                maxHeight: 0.4.sh,
                              ),
                              boxFit: BoxFit.contain,
                              backColor: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: SizedBox(
                            height: 26.sp,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 18.sp,
                                  child: Lottie.asset(
                                    'assets/json/livebars.json',
                                    width: 33.sp,
                                    height: 18.sp,
                                  ),
                                ),
                                // widthBox(7.w),
                                DefaultContainer(
                                  backColor: auxBlueColor,
                                  borderColor: auxBlueColor,
                                  radius: 35.sp,
                                  childWidget: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     SvgPicture.asset(
                                      //       'assets/svg/icons/open_eye.svg',
                                      //       color: newDarkGreyColor,
                                      //     ),
                                      //     widthBox(7.w),
                                      //     Text(
                                      //       '0',
                                      //       style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                      //     )
                                      //   ],
                                      // )

                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  defaultHorizontalPadding / 2),
                                          child: SvgPicture.asset(
                                            // liveDate != null
                                            //     ? 'assets/svg/icons/upcomingAlert.svg'
                                            //     :
                                            'assets/svg/icons/open_eye.svg',
                                            color: Colors.white,
                                            height: 12.sp,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              defaultHorizontalPadding / 2,
                                        ),
                                        child: Text(
                                          '09',
                                          style: mainStyle(context, 10,
                                              color: Colors.white,
                                              isBold: true),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox(7.h),
                    LiveContainerTail(),
                    heightBox(7.h),
                  ],
                ),
              ),
              // Text('data')
            ],
          ),
        ),
      ),
    );
  }
}

class LiveContainerUpcoming extends StatelessWidget {
  const LiveContainerUpcoming({
    Key? key,
    // this.liveDate,
    required this.liveItem,
    // required this.user,
    // required this.liveTitle,
    // required this.liveGoal,
    // required this.liveTopic,
    // required this.liveId,
    // required this.liveId,
    // required this.isCoHost,
  }) : super(key: key);

  final LiveByCategoryItem liveItem;

  // final DateTime? liveDate; // if null it's live now
  //
  // final String thumbnail;
  // final String liveTitle;
  // final String liveGoal;
  // final String liveTopic;
  // final String? liveId;
  //
  // final User? user;
  // final bool? isCoHost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   liveId == null
      //       ? null
      //       : navigateToWithoutNavBar(
      //           context,
      //           LivePage(
      //             liveID: liveId!,
      //             isHost: isCoHost ?? false,
      //             liveTitle: liveTitle,
      //             liveGoal: liveGoal,
      //             liveTopic: liveTopic,
      //
      //             /// audience false
      //             /// true for host
      //             /// this will change the layout view behaviour
      //           ),
      //           '',
      //           onBackToScreen: () {
      //             logg('ksahfkjlsnkxl');
      //             ScreenUtil.init(context, designSize: const Size(360, 770), splitScreenMode: true
      //                 // width: 750, height: 1334, allowFontScaling: false
      //                 );
      //           },
      //         );
      // },
      child: DefaultShadowedContainer(
        // decoration: const BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(12)),
        //   boxShadow: [
        //     BoxShadow(color: Color.fromRGBO(32, 32, 32, 0.25), offset: Offset(0, 2), blurRadius: 2),
        //   ],
        //   color: Color.fromRGBO(255, 255, 255, 1),
        // ),
        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        width: double.maxFinite,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: defaultHorizontalPadding,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Center(
                            child: DefaultImageFadeInOrSvg(
                              backGroundImageUrl: liveItem.image ?? '',
                              radius: defaultRadiusVal,
                              boxConstraints: BoxConstraints(
                                minHeight: 0.2.sh,
                                maxHeight: 0.4.sh,
                              ),
                              boxFit: BoxFit.contain,
                              backColor: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Lottie.asset('assets/json/93708-blue-loader.json',
                              //     width: 33.sp,
                              //     // height: 44.sp,
                              //
                              //     fit: BoxFit.cover),
                              // widthBox(7.w),
                              DefaultContainer(
                                backColor: Colors.white,
                                borderColor: Colors.white,
                                radius: 35.sp,
                                childWidget: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(
                                    //       'assets/svg/icons/open_eye.svg',
                                    //       color: newDarkGreyColor,
                                    //     ),
                                    //     widthBox(7.w),
                                    //     Text(
                                    //       '0',
                                    //       style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                    //     )
                                    //   ],
                                    // )

                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: SvgPicture.asset(
                                          'assets/svg/icons/upcomingAlert.svg',
                                          // color: liveDate != null ? null : Colors.white,
                                          height: 18.sp,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            defaultHorizontalPadding / 2,
                                      ),
                                      child: Text(
                                        getFormattedDateWithAMPM(
                                            liveItem.dateTime!),
                                        style: mainStyle(context, 10,
                                            color: newDarkGreyColor,
                                            isBold: true),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (liveItem.provider != null)
                          Positioned(
                              bottom: 10,
                              left: 10,
                              child: DefaultContainer(
                                backColor: Colors.black.withOpacity(0.4),
                                withoutBorder: true,
                                // borderColor: Colors.black.withOpacity(0.6),
                                childWidget: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      ProfileBubble(
                                        isOnline: false,
                                        pictureUrl:
                                            liveItem.provider!.personalPicture,
                                        radius: 15.sp,
                                      ),
                                      widthBox(5.w),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 0.3.sw),
                                        child: Column(
                                          children: [
                                            Text(
                                              getFormattedUserName(
                                                  liveItem.provider!),
                                              style: mainStyle(context, 12,
                                                  color: Colors.white,
                                                  isBold: true),
                                              maxLines: 1,
                                            ),
                                            // Text(
                                            //   'liveItem.provider!.fullName' ?? '',
                                            //   style: mainStyle(context, 12, color: Colors.white, isBold: true),
                                            //   maxLines: 1,
                                            // ),
                                            Text(
                                              'liveItem.provider!.fullName' ??
                                                  '',
                                              style: mainStyle(context, 10,
                                                  color: Colors.white,
                                                  weight: FontWeight.w700),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                child: SvgPicture.asset(
                                  'assets/svg/icons/share_outline_56.svg',
                                  height: 15,
                                ),
                                backgroundColor:
                                    newDarkGreyColor.withOpacity(0.6),
                              ),
                              heightBox(5.h),
                              CircleAvatar(
                                radius: 15,
                                child: SvgPicture.asset(
                                  'assets/svg/icons/infocircle.svg',
                                  height: 15,
                                ),
                                backgroundColor:
                                    newDarkGreyColor.withOpacity(0.6),
                              ),
                              heightBox(5.h),
                              CircleAvatar(
                                radius: 15,
                                child: SvgPicture.asset(
                                  'assets/svg/icons/question ask.svg',
                                  height: 15,
                                ),
                                backgroundColor:
                                    newDarkGreyColor.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Text('data')
            ],
          ),
        ),
      ),
    );
  }
}

class LiveContainerTail extends StatelessWidget {
  const LiveContainerTail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // feedsCubit.toggleLikeStatus(feedId: menaFeed.id.toString(), isLiked: menaFeed.isLiked);
              },
              child: IconWithText(
                // text: menaFeed.likes.toString(),
                // text: getFormattedNumberWithKandM(menaFeed.likes.toString()),
                // text: getFormattedNumberWithKandM(menaFeed.likes.toString()),
                text: '240',
                customColor: null,
                customSize: 12.sp,
                customFontSize: 9.sp,
                svgAssetLink: 'assets/svg/icons/heart.svg',
              ),
            ),
            widthBox(15.w),
            GestureDetector(
              onTap: () {
                // if (!alreadyInComments) {
                //   navigateToWithoutNavBar(context, FeedDetailsLayout(menaFeed: menaFeed), 'routeName');
                // }
              },
              child: IconWithText(
                text: '33',
                customSize: 12.sp,
                customFontSize: 9.sp,
                svgAssetLink: 'assets/svg/icons/comments.svg',
              ),
            ),
            widthBox(15.w),
            IconWithText(
              text: '167',
              customSize: 12.sp,
              customFontSize: 9.sp,
              svgAssetLink: 'assets/svg/icons/share_outline.svg',
              customIconColor: newDarkGreyColor,
            ),
          ],
        ),
      ],
    );
  }
}

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({
    Key? key,
    required this.article,
  }) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.sp,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.10000000149011612),
              offset: Offset(0, 0),
              blurRadius: 2)
        ],
        color: Color.fromRGBO(243, 243, 243, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: DefaultImage(
              backGroundImageUrl: article.image,
              boxFit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    textAlign: TextAlign.center,
                    style: mainStyle(context, 13),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Color.fromRGBO(0, 116, 199, 1),
                            width: 0.5,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0.sp, vertical: 4.sp),
                          child: Center(
                            child: Text(
                              article.category,
                              textAlign: TextAlign.left,
                              style: mainStyle(context, 12),
                            ),
                          ),
                        ),
                      ),
                      Text(article.createdAt,
                          textAlign: TextAlign.right,
                          style: mainStyle(context, 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashVideoContainer extends StatefulWidget {
  const SplashVideoContainer({
    Key? key,
    required this.videoLink,
  }) : super(key: key);

  final String videoLink;

  @override
  State<SplashVideoContainer> createState() => _SplashVideoContainerState();
}

class _SplashVideoContainerState extends State<SplashVideoContainer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoControl(widget.videoLink);
  }

  Future<void> videoControl(String videoUrl) async {
    _controller = VideoPlayerController.network(videoUrl);
    await Future.delayed(const Duration(seconds: 1));
    _controller.initialize().then((_) async {
      logg('play');

      ///
      ///
      ///
      ///
      ///
      await Future.delayed(const Duration(seconds: 1));
      logg('play after 1 second');
      _controller.play().then((value) => logg('started'));
      setState(() {});

      ///
      _controller.addListener(() async {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    logg('_VideoContainerState dispose');
    _controller.dispose().then((value) => logg('video player disposed'));
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(
                  _controller,
                ),
              ],
            ),
          )
        : SizedBox(height: 130.sp, child: DefaultLoaderGrey());
  }
}

class HomeScreenVideoContainer extends StatefulWidget {
  const HomeScreenVideoContainer({
    Key? key,
    required this.videoLink,
    required this.comingFromDetails,
    this.customFit,
    this.menaFeed,
    this.autoplay = true,
    required this.testText,
  }) : super(key: key);

  final String videoLink;
  final bool autoplay;
  final bool comingFromDetails;
  final BoxFit? customFit;
  final MenaFeed? menaFeed;
  final String testText;

  @override
  State<HomeScreenVideoContainer> createState() =>
      _HomeScreenVideoContainerState();
}

class _HomeScreenVideoContainerState extends State<HomeScreenVideoContainer> {
  // late VideoPlayerController _controller;
  late FlickManager flickManager;

  bool isFlickInitialized = false;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // bool isVideoHorizontal = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logg('test text: ${widget.testText}');
    logg('Mena feed in home screen video container: ${widget.menaFeed}');
    flickVideoInitial(widget.videoLink).then((value) async {
      await Future.delayed(Duration(milliseconds: 2000));
      logg('ytytyt yyy');
      setState(() {
        isFlickInitialized = true;
      });
    });
  }

  // Future<void> videoInitial(String videoUrl) async {
  //   _controller = VideoPlayerController.network(videoUrl);
  //
  //   _controller.initialize().then((_) async {
  //     logg('play2');
  //
  //     ///
  //     ///
  //     _controller.play().then((value) => logg('started'));
  //     setState(() {});
  //
  //     ///
  //     _controller.addListener(() async {
  //       logg(_controller.position.toString());
  //     });
  //   });
  // }

  Future<void> flickVideoInitial(String videoUrl) async {
    logg('flickVideoInitial');

    if (mounted) {
      logg('flickVideoInitial: mounted');
      flickManager = await FlickManager(
        videoPlayerController: VideoPlayerController.network(
          videoUrl,
        ),
        autoPlay: false,
        onVideoEnd: () {
          logg('video ended');
        },
      );
      logg('done flickVideoInitial');
    }

    // isVideoHorizontal = flickManager.flickVideoManager!.videoPlayerValue!.size.width >
    //     flickManager.flickVideoManager!.videoPlayerValue!.size.height;

    // logg('ytytyt');
  }

// @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     flickManager.dispose();
//     _controller.dispose();
//   }
  @override
  void dispose() {
    // TODO: implement dispose
    logg('_VideoContainerState pause');
    flickManager.dispose();
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    // super.build(context);
    return isFlickInitialized
        ? VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction <= 0.85 && mounted) {
                logg('paused');
                // if (widget.autoplay) {
                flickManager.flickControlManager
                    ?.pause(); //pausing  functionality
                // }
              } else {
                logg('play3');
                if (widget.autoplay) {
                  flickManager.flickControlManager?.play();
                  flickManager.flickControlManager?.mute();
                }
              }
            },
            child: DefaultShadowedContainer(
              withoutBorder: true,
              boxConstraints: flickManager.flickVideoManager!.videoPlayerValue!
                          .size.aspectRatio >
                      1
                  ? null
                  : BoxConstraints(maxHeight: 0.65.sh),
              childWidget: ClipRRect(
                //todo remove border
                borderRadius: BorderRadius.circular(defaultRadiusVal),
                child:
                    // FeedPlayer(),
                    MyFlickVideo(
                  flickManager: flickManager,
                  autoplay: widget.autoplay,
                  comingFromDetails: widget.comingFromDetails,
                  videoLink: widget.videoLink,
                  menaFeed: widget.menaFeed,
                  customFit: widget.customFit != null
                      ? widget.customFit
                      : flickManager.flickVideoManager!.videoPlayerValue!.size
                                  .aspectRatio >
                              1
                          ? null
                          : BoxFit.cover,
                ),
              ),
            ),
          )
        : Container(
            constraints: BoxConstraints(
              maxHeight: 0.4.sh,
            ),
            child: DefaultLoaderColor(),
          );
  }
}

class FullScreenVideoContainer extends StatefulWidget {
  const FullScreenVideoContainer({
    Key? key,
    required this.videoLink,
    this.customFit,
    this.user,
    this.menaFeed,
    required this.comingFromDetails,
    this.autoplay = true,
    this.inPreLoader = false,
  }) : super(key: key);

  final String videoLink;
  final bool autoplay;
  final bool inPreLoader;
  final bool comingFromDetails;
  final BoxFit? customFit;
  final User? user;
  final MenaFeed? menaFeed;

  @override
  State<FullScreenVideoContainer> createState() =>
      _FullScreenVideoContainerState();
}

class _FullScreenVideoContainerState extends State<FullScreenVideoContainer> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;
  bool videoPaused = true;

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;

  // Future<void> videoInitial(String videoUrl) async {
  //   _controller = VideoPlayerController.network(videoUrl);
  //
  //   _controller.initialize().then((_) async {
  //     logg('play2');
  //
  //     ///
  //     ///
  //     _controller.play().then((value) => logg('started'));
  //     setState(() {});
  //
  //     ///
  //     _controller.addListener(() async {
  //       logg(_controller.position.toString());
  //     });
  //   });
  // }

  Future<void> flickVideoInitial(String videoUrl) async {
    logg('flickVideoInitial');
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(videoUrl),
      // autoPlay: widget.inPreLoader == true ? false : widget.autoplay,
      autoPlay: false,

      /// so other videos in preloader will not start on initialize
      /// will start only on visibility changed
      onVideoEnd: () {
        logg('video ended');
        flickManager.flickControlManager?.play();
      },
    );
    logg('done flickVideoInitial');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flickVideoInitial(widget.videoLink);
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    logg('_VideoContainerState pause');
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    // super.build(context);
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction <= 0.85 && mounted) {
          logg('paused');
          if (widget.autoplay) {
            flickManager.flickControlManager?.pause(); //pausing  functionality
            setState(() {
              videoPaused = true;
            });
          }
        } else {
          logg('play3');
          if (widget.autoplay) {
            flickManager.flickControlManager?.play();
            if (feedsCubit.preferredMuteVal) {
              flickManager.flickControlManager?.mute();
            }
            setState(() {
              videoPaused = false;
            });
          }
        }
      },
      child: InkWell(
          onTap: () {
            logg('video clicked');
            if (flickManager.flickVideoManager!.isPlaying) {
              flickManager.flickControlManager?.pause();
              setState(() {
                videoPaused = true;
              });
            } else {
              flickManager.flickControlManager?.play();
              setState(() {
                videoPaused = false;
              });
            }
          },
          child: Stack(
            children: [
              MyFlickFeedScrollVideo(
                widget: widget,
                flickManager: flickManager,
              ),
              if (widget.menaFeed != null && videoPaused)

                /// menafeed null means only full screen
                Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/svg/icons/play video.svg',
                      height: 0.1.sh,
                    )),
              if (widget.menaFeed != null)
                Align(
                    alignment: Alignment.bottomRight,
                    child: VideoFeedSideActionBar(
                      menaFeed: widget.menaFeed!,
                      flickManager: flickManager,
                      comingFromDetails: widget.comingFromDetails,
                    )),
              if (widget.menaFeed != null && widget.menaFeed!.user != null)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: UserSimpleCard(
                        user: widget.menaFeed!.user!,
                      ),
                    ))
            ],
          )),
    );
  }
}

class UserSimpleCard extends StatelessWidget {
  const UserSimpleCard({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 8.0, horizontal: defaultHorizontalPadding),
        child: DefaultContainer(
          height: 60.h,
          backColor: Colors.white.withOpacity(0.2),
          withoutBorder: true,
          // borderColor: newDarkGreyColor.withOpacity(0.4),
          withBoxShadow: false,
          childWidget: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widthBox(12.w),
                // ProfileBubble(
                //     radius: 27.h,
                //     isOnline: false,
                //     pictureUrl: user.personalPicture),
                // widthBox(7.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            constraints: BoxConstraints(maxWidth: 180.w),
                            child: Text(
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              '${user.abbreviation == null ? '' : user.abbreviation!.name! + ' '}${user.fullName}',
                              style: mainStyle(context, 12,
                                  isBold: true,
                                  textHeight: 1,
                                  color: Colors.white),
                            ),
                          ),
                          (user.verified == '1')
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(
                                    Icons.verified,
                                    color: Color(0xff01BC62),
                                    size: 15.sp,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      // Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text:
                      //             "${provider.abbreviation==null?'':provider.abbreviation!.name} ${provider.fullName}",
                      //         style: mainStyle(context, 13,
                      //             weight: FontWeight.w600),
                      //       ),
                      //       if (provider.verified == '1')
                      //         WidgetSpan(
                      //           child: Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(
                      //                     horizontal: 8.0),
                      //             child: Icon(
                      //               Icons.verified,
                      //               color: Color(0xff01BC62),
                      //               size: 15.sp,
                      //             ),
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
                      if (user.specialities != null)
                        if (user.specialities!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heightBox(8.h),
                              Text(
                                user.specialities![0].name ?? '-',
                                style: mainStyle(context, 10,
                                    color: Colors.white,
                                    weight: FontWeight.bold),
                              ),
                              // ...provider.specialities!
                              //     .map((e) => Text(
                              //           e.name ?? '-',
                              //           style: mainStyle(context, 12,
                              //               color: mainBlueColor),
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //         ))
                              //     .toList()
                            ],
                          ),
                    ],
                  ),
                ),
                // Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           // heightBox(10.h),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.end,
                //             children: [
                //               Expanded(
                //                 child: Row(
                //                   children: [
                //                     Expanded(
                //                       child: Row(
                //                         children: [
                //                           Expanded(
                //                             flex: 4,
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: [
                //                                 Row(
                //                                   children: [
                //                                     Container(
                //                                       // color: Colors.red,
                //                                       constraints: BoxConstraints(maxWidth: 180.w),
                //                                       child: Text(
                //                                         maxLines: 1,
                //                                         softWrap: true,
                //                                         overflow: TextOverflow.ellipsis,
                //                                         '${user.abbreviation == null ? '' : user.abbreviation!.name! + ' '}${user.fullName}',
                //                                         style: mainStyle(context, 12,
                //                                             isBold: true, textHeight: 1.5),
                //                                       ),
                //                                     ),
                //                                     (user.verified == '1')
                //                                         ? Padding(
                //                                       padding: const EdgeInsets.symmetric(
                //                                           horizontal: 8.0),
                //                                       child: Icon(
                //                                         Icons.verified,
                //                                         color: Color(0xff01BC62),
                //                                         size: 15.sp,
                //                                       ),
                //                                     )
                //                                         : SizedBox()
                //                                   ],
                //                                 ),
                //                                 // Text.rich(
                //                                 //   TextSpan(
                //                                 //     children: [
                //                                 //       TextSpan(
                //                                 //         text:
                //                                 //             "${provider.abbreviation==null?'':provider.abbreviation!.name} ${provider.fullName}",
                //                                 //         style: mainStyle(context, 13,
                //                                 //             weight: FontWeight.w600),
                //                                 //       ),
                //                                 //       if (provider.verified == '1')
                //                                 //         WidgetSpan(
                //                                 //           child: Padding(
                //                                 //             padding:
                //                                 //                 const EdgeInsets.symmetric(
                //                                 //                     horizontal: 8.0),
                //                                 //             child: Icon(
                //                                 //               Icons.verified,
                //                                 //               color: Color(0xff01BC62),
                //                                 //               size: 15.sp,
                //                                 //             ),
                //                                 //           ),
                //                                 //         ),
                //                                 //     ],
                //                                 //   ),
                //                                 // ),
                //                                 if (user.specialities != null)
                //                                   if (user.specialities!.isNotEmpty)
                //                                     Column(
                //                                       crossAxisAlignment: CrossAxisAlignment.start,
                //                                       children: [
                //                                         heightBox(8.h),
                //                                         Text(
                //                                           user.specialities![0].name ?? '-',
                //                                           style: mainStyle(context, 10,
                //                                               color: mainBlueColor,
                //                                               weight: FontWeight.bold),
                //                                         ),
                //                                         // ...provider.specialities!
                //                                         //     .map((e) => Text(
                //                                         //           e.name ?? '-',
                //                                         //           style: mainStyle(context, 12,
                //                                         //               color: mainBlueColor),
                //                                         //   maxLines: 1,
                //                                         //   overflow: TextOverflow.ellipsis,
                //                                         //         ))
                //                                         //     .toList()
                //                                       ],
                //                                     ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //
                //         ],
                //       ),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoFeedSideActionBar extends StatelessWidget {
  const VideoFeedSideActionBar({
    super.key,
    required this.menaFeed,
    required this.comingFromDetails,
    required this.flickManager,
  });

  final MenaFeed menaFeed;
  final bool comingFromDetails;
  final FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);

    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              top: Platform.isIOS ? 66.h : 40.h,
              bottom: 66.h,
              right: defaultHorizontalPadding,
              left: defaultHorizontalPadding,
            ),
            child: GestureDetector(
              onTap: () {
                logg('toggle mute');
                if (flickManager.flickControlManager!.isMute) {
                  flickManager.flickControlManager!.unmute();
                  feedsCubit.updatePreferredMuteVal(false);
                } else {
                  flickManager.flickControlManager!.mute();
                  feedsCubit.updatePreferredMuteVal(true);
                }
              },
              child: Container(
                width: 33.w,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 33),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconWithTextVertical(
                          text: '',
                          inGallery: true,
                          customSize: 28.sp,
                          svgAssetLink: feedsCubit.preferredMuteVal
                              ? 'assets/svg/icons/mute_outline_28.svg'
                              : 'assets/svg/icons/volume_outline_28.svg'),
                      Column(
                        children: [
                          Column(
                            children: [
                              ProfileBubble(
                                  radius: 14.h,
                                  isOnline: false,
                                  pictureUrl: menaFeed.user!.personalPicture),
                              heightBox(6.h),
                              BlocConsumer<MainCubit, MainState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (menaFeed.user!.isFollowing!) {
                                        /// unfollow
                                        mainCubit
                                            .unfollowUser(
                                                userId: menaFeed.user!.id
                                                    .toString(),
                                                userType:
                                                    menaFeed.user!.roleName ??
                                                        '')
                                            .then((value) {
                                          menaFeed.user!.isFollowing = false;
                                        });
                                      } else {
                                        /// follow
                                        mainCubit
                                            .followUser(
                                                userId: menaFeed.user!.id
                                                    .toString(),
                                                userType:
                                                    menaFeed.user!.roleName ??
                                                        '')
                                            .then((value) {
                                          menaFeed.user!.isFollowing = true;
                                        });
                                      }
                                    },
                                    child: (state is FollowingUserState &&
                                            mainCubit
                                                    .currentTryingToFollowUser ==
                                                menaFeed.user!.id.toString())
                                        ? DefaultLoaderGrey()
                                        : Icon(
                                            menaFeed.user!.isFollowing!
                                                ? Icons.add
                                                : Icons.remove,
                                            color: Colors.white,
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                          heightBox(20.h),
                          GestureDetector(
                            onTap: () {
                              feedsCubit
                                  .toggleLikeStatus(
                                      feedId: menaFeed.id.toString(),
                                      isLiked: menaFeed.isLiked)
                                  .then((value) {
                                menaFeed.isLiked = !menaFeed.isLiked;
                                if (menaFeed.isLiked) {
                                  menaFeed.likes = menaFeed.likes + 1;
                                } else {
                                  menaFeed.likes = menaFeed.likes - 1;
                                }
                              });
                            },
                            child: IconWithTextVertical(
                                text: getFormattedNumberWithKandM(
                                    menaFeed.likes.toString()),
                                inGallery: true,
                                customSize: 28.sp,
                                svgAssetLink: menaFeed.isLiked
                                    ? 'assets/svg/icons/like_solid.svg'
                                    : 'assets/svg/icons/like_outline_36.svg'),
                          ),
                          heightBox(20.h),
                          GestureDetector(
                            onTap: () {
                              if (comingFromDetails) {
                                Navigator.pop(context);
                              } else {
                                navigateToWithoutNavBar(
                                    context,
                                    FeedDetailsLayout(menaFeed: menaFeed),
                                    'routeName');
                              }
                            },
                            child: IconWithTextVertical(
                              text: getFormattedNumberWithKandM(
                                  menaFeed.commentsCounter.toString()),
                              customSize: 28.sp,
                              inGallery: true,
                              svgAssetLink:
                                  'assets/svg/icons/comment_outline_20.svg',
                            ),
                          ),
                          heightBox(20.h),
                          IconWithTextVertical(
                            text: '167',
                            customSize: 28.sp,
                            inGallery: true,
                            svgAssetLink:
                                'assets/svg/icons/share_outline_56.svg',
                            customIconColor: newDarkGreyColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyFlickVideo extends StatelessWidget {
  const MyFlickVideo({
    super.key,
    // required this.widget,
    required this.flickManager,
    required this.videoLink,
    required this.autoplay,
    required this.comingFromDetails,
    this.customFit,
    this.menaFeed,
  });

  // final HomeScreenVideoContainer widget;
  final FlickManager flickManager;
  final String videoLink;
  final bool autoplay;
  final bool comingFromDetails;
  final BoxFit? customFit;
  final MenaFeed? menaFeed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logg('toggle full screen');
        logg(menaFeed.toString());
        navigateToWithoutNavBar(
            context,
            VideosViewOrScrollLayout(
              initialVideoLink: videoLink,
              menaFeed: menaFeed,
              comingFromDetails: comingFromDetails,
            ),
            '');
      },
      child: FlickVideoPlayer(
        flickVideoWithControls: FlickVideoWithControls(
          videoFit: customFit ?? BoxFit.fill,
          backgroundColor: newLightGreyColor,
          iconThemeData: IconThemeData(color: newDarkGreyColor),
          // controls: FlickPortraitControls(
          //   progressBarSettings: FlickProgressBarSettings(
          //     playedColor: newDarkGreyColor,
          //   ),
          //   toggleFullScreen: () {
          //     logg('toggle full screen');
          //     logg(menaFeed.toString());
          //     navigateToWithoutNavBar(
          //         context,
          //         VideosViewOrScrollLayout(
          //           initialVideoLink: videoLink,
          //           menaFeed: menaFeed,
          //           comingFromDetails: comingFromDetails,
          //         ),
          //         '');
          //   },
          // ),
          playerLoadingFallback: DefaultLoaderColor(),
        ),
        wakelockEnabledFullscreen: true,
        wakelockEnabled: true,

        // flickVideoWithControlsFullscreen: FlickVideoWithControls(
        //   videoFit: BoxFit.fill,
        //   controls: Padding(
        //     padding: EdgeInsets.only(bottom: 88.0.h),
        //     child: SafeArea(
        //       child: FlickPortraitControls(
        //         progressBarSettings: FlickProgressBarSettings(
        //           playedColor: newDarkGreyColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        flickManager: flickManager,
      ),
    );
  }
}

class MyFlickFeedScrollVideo extends StatelessWidget {
  const MyFlickFeedScrollVideo({
    super.key,
    required this.widget,
    required this.flickManager,
  });

  final FullScreenVideoContainer widget;
  final FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: widget.inPreLoader
            ? flickManager.flickVideoManager!.videoPlayerValue!.size.width >
                    flickManager
                        .flickVideoManager!.videoPlayerValue!.size.height
                ? BoxFit.contain
                : BoxFit.fitWidth
            : widget.customFit ?? BoxFit.fill,
        backgroundColor: Colors.black,
        //newLightTextGreyColor.withOpacity(0.4),
        iconThemeData: IconThemeData(color: newDarkGreyColor),
        controls: widget.menaFeed != null
            ? null
            : SafeArea(
                child: FlickPortraitControls(
                  // toggleFullScreen: null,
                  progressBarSettings: FlickProgressBarSettings(
                    playedColor: newDarkGreyColor,
                  ),
                ),
              ),
        playerLoadingFallback: DefaultLoaderColor(),
      ),
      wakelockEnabledFullscreen: true,

      wakelockEnabled: true,
      // flickVideoWithControlsFullscreen: FlickVideoWithControls(
      //   videoFit: BoxFit.fill,
      //   controls: Padding(
      //     padding: EdgeInsets.only(bottom: 88.0.h),
      //     child: SafeArea(
      //       child: FlickPortraitControls(
      //         progressBarSettings: FlickProgressBarSettings(
      //           playedColor: newDarkGreyColor,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      flickManager: flickManager,
    );
  }
}
