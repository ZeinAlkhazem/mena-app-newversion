import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/my_profile/cubit/profile_cubit.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../main_layout/main_layout.dart';
import '../platform_provider/provider_home/platform_provider_home.dart';
import '../platform_provider/provider_home/provider_profile_Sections.dart';

class UserProfileEditLayout extends StatelessWidget {
  UserProfileEditLayout({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: DefaultBackTitleAppBar(
            title: 'Profile',
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
                // widthBox(8.w),
                // SvgPicture.asset(
                //   'assets/svg/icons/addcircle.svg',
                //   color: mainBlueColor,
                //   height: Responsive.isMobile(context) ? 25.w : 12.w,
                // ),
                widthBox(defaultHorizontalPadding),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
          color: newLightGreyColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ProfileHeader(
                //   user:user
                // ),
                // if (user.moreData != null)
                BlocConsumer<MainCubit, MainState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    user = MainCubit.get(context).userInfoModel!.data.user;
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        SimpleUserCard(
                          provider: user,
                          justView: true,
                          currentLayout: 'provider',
                          isInEdit: true,
                          customBubbleCallback: () async {
                            showMyBottomSheet(
                              context: context,
                              title: 'Take a photo or pick from Gallery',
                              body: BlocConsumer<ProfileCubit, ProfileState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  return Container(
                                    // height: 0.22.sh,
                                    color: Colors.white,
                                    child: SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Text(
                                            //   '',
                                            //   style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                            // ),
                                            // heightBox(15.h),
                                            Column(
                                              children: [
                                                if (profileCubit.attachedFile != null)
                                                  Image.file(
                                                    File(profileCubit.attachedFile!.path),
                                                    height: 0.3.sh,
                                                    fit: BoxFit.contain,
                                                  ),
                                                if (profileCubit.attachedFile != null) heightBox(15.h),
                                                profileCubit.attachedFile != null
                                                    ? state is UpdatingPictureState
                                                        ? DefaultLoaderColor()
                                                        : Row(
                                                            children: [
                                                              Expanded(
                                                                  child: DefaultButton(
                                                                      text: 'Save',
                                                                      onClick: () {
                                                                        profileCubit.updateProfilePic().then((value) {
                                                                          MainCubit.get(context).getUserInfo();
                                                                          Navigator.pop(context);
                                                                        });
                                                                      })),
                                                              widthBox(10.w),
                                                              Expanded(
                                                                  child: DefaultButton(
                                                                      text: 'Retry',
                                                                      onClick: () {
                                                                        profileCubit.updateAttachedFile(null);
                                                                      })),
                                                            ],
                                                          )
                                                    : Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            child: DefaultButton(
                                                              // color: Colors.white,
                                                              backColor: newLightGreyColor,

                                                              borderColor: Colors.transparent,
                                                              height: 0.07.sh,
                                                              // width: 33.w,
                                                              text: getTranslatedStrings(context).image,
                                                              customChild: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    getTranslatedStrings(context).image,
                                                                    style: mainStyle(context, 13,
                                                                        color: newDarkGreyColor, isBold: true),
                                                                  ),
                                                                  widthBox(7.w),
                                                                  SvgPicture.asset('assets/svg/icons/camera.svg')
                                                                ],
                                                              ),
                                                              onClick: () async {
                                                                {
                                                                  // Either the permission was already granted before or the user just granted it.
                                                                  final ImagePicker _picker = ImagePicker();
                                                                  final XFile? photo = await _picker
                                                                      .pickImage(
                                                                    source: ImageSource.camera,
                                                                  )
                                                                      .then((value) async {
                                                                    logg('photo picked');
                                                                    profileCubit.updateAttachedFile(value);
                                                                    await Future.delayed(Duration(milliseconds: 100));
                                                                    // Navigator.pop(context);
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          widthBox(10.w),
                                                          Expanded(
                                                            child: DefaultButton(
                                                              // color: Colors.white,
                                                              backColor: newLightGreyColor,

                                                              borderColor: Colors.transparent,
                                                              height: 0.07.sh,
                                                              // width: 33.w,
                                                              text: getTranslatedStrings(context).image,
                                                              customChild: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    'Gallery',
                                                                    style: mainStyle(context, 13,
                                                                        color: newDarkGreyColor, isBold: true),
                                                                  ),
                                                                  widthBox(7.w),
                                                                  SvgPicture.asset('assets/svg/icons/camera.svg')
                                                                ],
                                                              ),
                                                              onClick: () async {
                                                                {
                                                                  // Either the permission was already granted before or the user just granted it.
                                                                  final ImagePicker _picker = ImagePicker();
                                                                  final XFile? photo = await _picker
                                                                      .pickImage(source: ImageSource.gallery)
                                                                      .then((value) async {
                                                                    logg('photo picked');
                                                                    profileCubit.updateAttachedFile(value);
                                                                    await Future.delayed(Duration(milliseconds: 100));
                                                                    // Navigator.pop(context);
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );

                            ///
                            /// old implement
                            ///
                            logg('picking PIC');
                            // var status = await Permission
                            //     .camera.status;
                            // logg(status.name.toString());
                            // {
                            //   // Either the permission was already granted before or the user just granted it.
                            //   final ImagePicker _picker =
                            //       ImagePicker();
                            //   final XFile? photo =
                            //       await _picker
                            //           .pickImage(
                            //     source: ImageSource.camera,
                            //   )
                            //           .then((value) {
                            //     logg('photo picked');
                            //     messengerCubit
                            //         .updateAttachedFile(
                            //             value);
                            //   });
                            // }
                            // if (await Permission.camera
                            //     .request()
                            //     .isRestricted)
                            // {
                            //   showMyAlertDialog(
                            //       context, 'No permission',
                            //       alertDialogContent: Column(
                            //         mainAxisSize:
                            //         MainAxisSize.min,
                            //         children: [
                            //           Text(
                            //             'You don\'t have permission to access',
                            //             style: mainStyle(
                            //                 context, 13),
                            //             textAlign:
                            //             TextAlign.center,
                            //           ),
                            //           heightBox(10.h),
                            //           Text(
                            //             'You can edit permission settings in your device to proceed',
                            //             style: mainStyle(
                            //                 context, 13),
                            //             textAlign:
                            //             TextAlign.center,
                            //           ),
                            //           heightBox(10.h),
                            //           DefaultButton(
                            //               text:
                            //               'Open app setting',
                            //               onClick: () {
                            //                 openAppSettings();
                            //               })
                            //         ],
                            //       ));
                            // }else
                          },
                        ),
                        heightBox(10.h),
                        ProfileCompletionSection(
                            // completionInfo: MainCubit.get(context).userInfoModel!.data.dataCompleted,
                            ),
                      ],
                    );
                  },
                ),
                heightBox(10.h),
                if(user.moreData!=null)
                Column(
                  children: [
                    AboutSection(
                      about: user.moreData!.about,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    EducationSection(
                      educations: user.moreData == null ? [] : user.moreData!.educations,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    ExperienceSection(
                      experiences: user.moreData == null ? [] : user.moreData!.experiences,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    PublicationSection(
                      publications: user.moreData == null ? [] : user.moreData!.publications,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    CertificationsSection(
                      certifications: user.moreData == null ? [] : user.moreData!.certifications,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    MembershipSection(
                      memberships: user.moreData == null ? [] : user.moreData!.memberships,
                      inEditProfile: true,
                    ),
                    heightBox(10.h),
                    RewardsSection(
                      rewards: user.moreData == null ? [] : user.moreData!.rewards,
                      inEditProfile: true,
                    ),
                  ],
                ),
                // heightBox(10.h),
              ],
            ),
          ),
        )));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return DefaultShadowedContainer(
        width: double.maxFinite,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleUserCard(
                provider: user,
                justView: true,
                currentLayout: 'provider',
              ),
            ],
          ),
        ));
  }
}
