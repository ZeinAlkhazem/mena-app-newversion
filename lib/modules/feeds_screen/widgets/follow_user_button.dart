import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';
import '../feeds_screen.dart';

class DefaultSoftButton extends StatelessWidget {
  const DefaultSoftButton({
    Key? key,
    this.label = 'View all',
    this.customColor,
    this.customFontColor,
    this.customHeight,
    this.callBack,
  }) : super(key: key);
  final String label;
  final Color? customColor;
  final Color? customFontColor;
  final double? customHeight;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultContainer(
        height: customHeight ?? 27.sp,
        radius: 45,
        backColor: customColor ?? softBlueColor,
        borderColor: softBlueColor,
        childWidget: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 1.2 * defaultHorizontalPadding),
            child: Text(
              label,
              style: mainStyle(context, 10,
                  weight: FontWeight.w700,
                  color: customFontColor ?? mainBlueColor,
                  letterSpacing: 1.2),
              // maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton({
    Key? key,
    required this.label,
    this.customColor,
    this.customFontColor,
    this.customHeight,
    this.callBack,
  }) : super(key: key);
  final IconData label;
  final Color? customColor;
  final Color? customFontColor;
  final double? customHeight;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultContainer(
        height: customHeight ?? 27.sp,
        radius: 45,
        backColor: customColor ?? softBlueColor,
        borderColor: softBlueColor,
        childWidget: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 1.2 * defaultHorizontalPadding),
            child: Icon(label, color: customFontColor ?? mainBlueColor),
          ),
        ),
      ),
    );
  }
}

class FollowUSerButton extends StatelessWidget {
  const FollowUSerButton({
    super.key,
    required this.user,
    // required this.feedsCubit,
  });

  final User user;

  // final FeedsCubit feedsCubit;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (state is FollowingUserState && mainCubit.currentTryingToFollowUser == user.id.toString())
            ? DefaultLoaderGrey()
            : DefaultSoftButton(
          callBack: () {
            if (user.isFollowing!) {
              /// unfollow
              mainCubit.unfollowUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
                user.isFollowing = false;
              });
            } else {
              /// follow
              mainCubit.followUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
                user.isFollowing = true;
              });
            }
          },
          label:
          user.isFollowing! ? getTranslatedStrings(context).unFollow : getTranslatedStrings(context).follow,
          customColor: user.isFollowing! ? newLightGreyColor : null,
        );
      },
    );
  }
}

class NewFollowUSerButton extends StatelessWidget {
  const NewFollowUSerButton({
    super.key,
    required this.user,
    required this.isJson,
    // required this.feedsCubit,
  });

  final User user;

  final bool isJson;

  // final FeedsCubit feedsCubit;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (state is FollowingUserState &&
                mainCubit.currentTryingToFollowUser == user.id.toString())
            ? DefaultLoaderGrey(
                customHeight: isJson ? 33.sp : 26.sp,
              )
            : GestureDetector(
                onTap: () {
                  if (user.isFollowing!) {
                    /// unfollow
                    mainCubit
                        .unfollowUser(
                            userId: user.id.toString(),
                            userType: user.roleName ?? '')
                        .then((value) {
                      user.isFollowing = false;
                    });
                  } else {
                    /// follow
                    mainCubit
                        .followUser(
                            userId: user.id.toString(),
                            userType: user.roleName ?? '')
                        .then((value) {
                      user.isFollowing = true;
                    });
                  }
                },
                child: (isJson)
                    ?

                    /// json follow
                    user.isFollowing!
                        ? Lottie.asset(
                            'assets/json/NhKTFINKBV.json',
                            height: 33.sp,
                            width: 0.18.sw,
                          )

                        /// json followed
                        : Lottie.asset(
                            'assets/json/NhKTFINKBV.json',
                            height: 33.sp,
                            width: 0.18.sw,
                          )
                    : OutlineGradientButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            '${user.isFollowing! ? getTranslatedStrings(context).unFollow : getTranslatedStrings(context).follow}',
                            style: mainStyle(context, 11,
                                color: newDarkGreyColor,
                                weight: FontWeight.w700),
                          ),
                        ),
                        // backgroundColor:user.isFollowing!?Color(0xffF1C98C):newLightGreyColor ,
                        gradient: LinearGradient(
                            colors: [Color(0xffF1C98C), Color(0xff3D86BD)],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            tileMode: TileMode.clamp),
                        strokeWidth: 2,

                        radius: Radius.circular(defaultRadiusVal * 2),
                        // onTap: (){
                        //   if (user.isFollowing!) {
                        //     /// unfollow
                        //     mainCubit.unfollowUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
                        //       user.isFollowing = false;
                        //     });
                        //   } else {
                        //     /// follow
                        //     mainCubit.followUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
                        //       user.isFollowing = true;
                        //     });
                        //   }
                        // },
                      ),
              );

        // DefaultSoftButton(
        //         callBack: () {
        //           if (user.isFollowing!) {
        //             /// unfollow
        //             mainCubit.unfollowUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
        //               user.isFollowing = false;
        //             });
        //           } else {
        //             /// follow
        //             mainCubit.followUser(userId: user.id.toString(), userType: user.roleName ?? '').then((value) {
        //               user.isFollowing = true;
        //             });
        //           }
        //         },
        //         label:
        //             user.isFollowing! ? getTranslatedStrings(context).unFollow : getTranslatedStrings(context).follow,
        //         customColor: user.isFollowing! ? newLightGreyColor : null,
        //       );
      },
    );
  }
}
