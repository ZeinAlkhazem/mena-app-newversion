
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/validators.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/main_cubit/main_cubit.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../models/api_model/my_blog_info_model.dart';
import '../../../../models/api_model/home_section_model.dart';
import '../../../../models/local_models.dart';
import '../../../my_profile/cubit/profile_cubit.dart';
import '../../../my_profile/my_profile.dart';
import '../../../platform_provider/provider_home/provider_profile.dart';



class MyBlogSimpleUserCard extends StatefulWidget {
  const MyBlogSimpleUserCard({
    Key? key,
    this.justView = false,
    this.isInEdit = false,
    required this.provider,
    required this.currentLayout,
    this.customCallback,
    this.customBubbleCallback,
  }) : super(key: key);

  final bool justView;
  final bool isInEdit;
  final Data provider;
  final String? currentLayout;
  final Function()? customCallback;
  final Function()? customBubbleCallback;

  @override
  State<MyBlogSimpleUserCard> createState() => _MyBlogSimpleUserCardState();
}

class _MyBlogSimpleUserCardState extends State<MyBlogSimpleUserCard> {
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);
    return GestureDetector(
      onTap: widget.customCallback != null
          ? widget.customCallback
          : () {
           widget.justView
            ? null
            :
        // comingSoonAlertDialog(context);
        navigateToWithoutNavBar(
            context,
            ProviderProfileLayout(
              providerId: widget.provider.provider.id.toString(),
              lastPageAppbarTitle: widget.currentLayout ?? 'back',
            ),
            '');
      },
      child: DefaultShadowedContainer(
        // radius: defaultRadiusVal,
        radius: 0,
        withoutBorder: true,
        width: double.maxFinite,
        // borderColor: Colors.transparent,
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap:
                    (){
                      if (widget.isInEdit) log(feedsCubit.isChangeIcon.toString() );
                      if ( widget.provider.provider.isFollowing!) {
                        /// unfollow
                        mainCubit.unfollowUser(userId:  widget.provider.provider!.id.toString(), userType: widget.provider.provider!.roleName ?? '')
                            .then((value) {
                          widget.provider..provider!.isFollowing = false;
                        });
                      } else {
                        /// follow
                        mainCubit.followUser(userId: widget.provider.provider!.id.toString(),
                            userType:widget.provider.provider!.roleName ?? '')
                            .then((value) {
                          widget.provider.provider!.isFollowing = true;
                        });
                      }

                      setState(() =>   widget.provider.provider!.isFollowing = !  widget.provider.provider!.isFollowing!);

                      log(feedsCubit.isChangeIcon.toString() );

                    },

                    child: ProfileBubble(
                        radius: 33.sp,
                        isOnline: true,
                        customRingColor: mainBlueColor,
                        pictureUrl: widget.provider.provider.personalPicture),
                  ),
                ),
                if (widget.isInEdit)
                  Align(
                      // alignment: Alignment.bottomCenter,

                      child: CircleAvatar(
                        radius: 12.sp,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: newLightGreyColor,
                          radius: 10.sp,
                          child:
                          widget.provider.provider.isFollowing == true ?
                          SvgPicture.asset(
                            'assets/icons/follow.svg',
                            width: 16.sp,
                          ):
                          SvgPicture.asset(
                            'assets/icons/plus.svg',
                            width: 16.sp,
                          ),
                        ),
                      ))
              ],
            ),
            heightBox(5.h),
            Text(
              '${widget.provider.provider.fullName}',
              style: mainStyle(context
                  , 16,
                  isBold: true,
                  color: AppColors.blackgreyColor,
                  textHeight: 1.5),
            ),
            heightBox(2.h),
            Text(
              '${
                  widget.provider.provider.platform.name
            }',
              style: mainStyle(context, 12, isBold: false, color: AppColors.gray, textHeight: 1.5),
            ),

            Text(
              '${widget.provider.followers.toString() + " Followers"}',
              style: mainStyle(context, 10, isBold: false,color: AppColors.gray, textHeight: 1.5),
            ),
            heightBox(5.h),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Row(children: [
                      SvgPicture.asset(
                        'assets/icons/article_28.svg',
                        width: 22.sp,
                        color: Color(0XFF2A87EA),
                      ),
                      Text(
                        ' ${widget.provider.blogsCount} Articles',
                        style: mainStyle(context, 12, isBold: false,color: AppColors.gray, textHeight: 1.5),
                      ),
                    ],),


                    Row(children: [
                      SvgPicture.asset(
                        'assets/icons/view_28.svg',
                        color: Color(0XFF2A87EA),
                        width: 22.sp,
                      ),
                      Text(
                        '${widget.provider.totalReaders.toString()} Reader',
                        style: mainStyle(context, 12, isBold: false,color: AppColors.gray, textHeight: 1.5),
                      ),
                    ],),

                  ],
                ),
              ),
            ),
            // if (isInEdit)
            //   Column(
            //     children: [
            //       heightBox(7.h),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 1.5),
            //         child: DefaultButton(
            //           text: 'Edit Account information and speciality',
            //           customChild: Padding(
            //             padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Expanded(
            //                   child: Text(
            //                     'Edit Account information and speciality',
            //                     style: mainStyle(context, 12, color: newDarkGreyColor, isBold: true),
            //                   ),
            //                 ),
            //                 Icon(
            //                   Icons.arrow_forward_ios_rounded,
            //                   color: mainBlueColor,
            //                   size: 13.sp,
            //                 )
            //               ],
            //             ),
            //           ),
            //           backColor: newLightGreyColor,
            //           borderColor: newLightGreyColor,
            //           titleColor: newDarkGreyColor,
            //           fontSize: 11,
            //           onClick: () {
            //             showMyAlertDialog(context, 'Edit Account',
            //                 isTitleBold: true,
            //                 alertDialogContent: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Text(
            //                       'Access provider dashboard with login, modify account specialty',
            //                       style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
            //                     ),
            //                     heightBox(17.h),
            //                     Row(
            //                       children: [
            //                         Expanded(
            //                             child: DefaultButton(
            //                               text: 'Cancel',
            //                               onClick: () {
            //                                 Navigator.pop(context);
            //                               },
            //                               backColor: newLightGreyColor,
            //                               borderColor: newLightGreyColor,
            //                               titleColor: newDarkGreyColor,
            //                             )),
            //                         widthBox(8.w),
            //                         Expanded(
            //                             child: DefaultButton(
            //                                 text: 'Continue',
            //                                 onClick: () {
            //                                   launchUrl(Uri.parse('https://dashboard.menaplatforms.com/'));
            //                                 })),
            //                       ],
            //                     )
            //                   ],
            //                 ));
            //           },
            //         ),
            //       ),
            //       heightBox(15.h),
            //
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}