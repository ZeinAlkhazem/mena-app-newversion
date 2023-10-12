import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/validators.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';
import 'package:mena/modules/my_profile/cubit/profile_cubit.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile_Sections.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/cache/cache.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/local_models.dart';
import '../../feeds_screen/widgets/follow_user_button.dart';
import '../../messenger/chat_layout.dart';
import '../../my_profile/my_profile.dart';

class PlatformProviderHomePage extends StatelessWidget {
  const PlatformProviderHomePage({Key? key, required this.provider}) : super(key: key);

  final User provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: '%Provider name',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalSelectorScrollable(
            buttons: [
              SelectorButtonModel(title: 'test', onClickCallback: () {}, isSelected: true),
              SelectorButtonModel(title: 'test', onClickCallback: () {}, isSelected: true),
              SelectorButtonModel(title: 'ejfhn', onClickCallback: () {}, isSelected: true),
            ],
          ),
          heightBox(7.h),

          /// last branch view
          /// what's wrong here
          LastBranchView(
            provider: provider,
          ),
          // const ProviderSupplierItem()
        ],
      ),
    );
  }
}

class LastBranchView extends StatelessWidget {
  const LastBranchView({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final User provider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: const Text('Hospital professional on air'),
            ),
            heightBox(7.h),
            SizedBox(
              height: 90.sp,
              child: Row(
                children: [
                  widthBox(defaultHorizontalPadding),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, builder) => LiveProfileBubble(
                        requiredWidth: 70.sp,
                        name: 'test',
                        thumbnailUrl: '',
                        liveId: null,
                        liveTitle: '',
                        liveGoal: '',
                        liveTopic: '',
                      ),
                      separatorBuilder: (ctx, index) => widthBox(10.w),
                      itemCount: 8,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, builder) => ProviderCard(
                  provider: provider,
                  currentLayout: 'Branches',
                ),
                separatorBuilder: (ctx, index) => heightBox(15.h),
                itemCount: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    Key? key,
    this.justView = false,
    required this.provider,
    required this.currentLayout,
    this.customCallback,
  }) : super(key: key);

  final bool justView;
  final User provider;
  final String? currentLayout;
  final Function()? customCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: customCallback != null
          ? customCallback
          : () {
              justView
                  ? null
                  :
                  // comingSoonAlertDialog(context);
                  navigateToWithoutNavBar(
                      context,
                      ProviderProfileLayout(
                        providerId: provider.id.toString(),
                        lastPageAppbarTitle: currentLayout ?? 'back',
                      ),
                      '');
            },
      child: DefaultShadowedContainer(
        radius: defaultRadiusVal,
        borderColor: Colors.transparent,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 12.sp),
          child: Column(
            children: [
              ProviderCardBody(
                justView: justView,
                provider: provider,
              ),
              heightBox(15.h),
              ProviderCardActionBar(
                provider: provider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewProviderCard extends StatelessWidget {
  const NewProviderCard({
    Key? key,
    this.justView = false,
    required this.provider,
    required this.currentLayout,
    this.customCallback,
  }) : super(key: key);

  final bool justView;
  final User provider;
  final String? currentLayout;
  final Function()? customCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: customCallback != null
          ? customCallback
          : () {
              justView
                  ? null
                  : navigateToWithoutNavBar(
                      context,
                      ProviderProfileLayout(
                        providerId: provider.id.toString(),
                        lastPageAppbarTitle: currentLayout ?? 'back',
                      ),
                      '');
            },
      child: DefaultShadowedContainer(
        radius: defaultRadiusVal,
        borderColor: Colors.transparent,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              // color: Colors.red,
                              constraints: BoxConstraints(maxWidth: 240.w),
                              child: Text(
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
                                style: mainStyle(context, 12, isBold: true, textHeight: 1.5),
                              ),
                            ),
                            (provider.verified == '1')
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.verified,
                                      color: Color(0xff01BC62),
                                      size: 15.sp,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/icons/colored_share.svg',
                        height: 18.sp,
                      ),
                    ],
                  ),
                  heightBox(10.h),
                  if (provider.specialities != null)
                    if (provider.specialities!.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // heightBox(8.h),
                          Text(
                            provider.specialities![0].name ?? '-',
                            style: mainStyle(context, 10, color: mainBlueColor, isBold: true),
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
                  heightBox(2.h),
                  Divider(
                    thickness: 1.2,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: NewProviderCardBody(
                      justView: justView,
                      provider: provider,
                    ),
                  ),
                ],
              ),
              heightBox(7.h),
              Container(child: NewProviderCardActionPanel(provider: provider)),
              // Text('data')
              // ProviderCardActionBar(
              //   provider: provider,
              // ),

              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     if (provider.specialities != null)
              //       if (provider.specialities!.isNotEmpty)
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             // heightBox(8.h),
              //             Text(
              //               provider.specialities![0].name ?? '-',
              //               style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
              //             ),
              //             RichText(
              //               text: TextSpan(
              //                 text: 'Registration No: ',
              //                 style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
              //                 children: <TextSpan>[
              //                   TextSpan(
              //                     text: provider.registrationNumber ?? '-',
              //                     style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             // ...provider.specialities!
              //             //     .map((e) => Text(
              //             //           e.name ?? '-',
              //             //           style: mainStyle(context, 12,
              //             //               color: mainBlueColor),
              //             //   maxLines: 1,
              //             //   overflow: TextOverflow.ellipsis,
              //             //         ))
              //             //     .toList()
              //           ],
              //         ),
              //     Divider(
              //       thickness: 1.2,
              //     ),
              //     Row(
              //       children: [
              //         Expanded(
              //           child: Row(
              //             children: [
              //               Container(
              //                 // color: Colors.red,
              //                 constraints: BoxConstraints(maxWidth: 240.w),
              //                 child: Text(
              //                   maxLines: 1,
              //                   softWrap: true,
              //                   overflow: TextOverflow.ellipsis,
              //                   '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
              //                   style: mainStyle(context, 12, isBold: true, textHeight: 1.5),
              //                 ),
              //               ),
              //               (provider.verified == '1')
              //                   ? Padding(
              //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //                       child: Icon(
              //                         Icons.verified,
              //                         color: Color(0xff01BC62),
              //                         size: 15.sp,
              //                       ),
              //                     )
              //                   : SizedBox()
              //             ],
              //           ),
              //         ),
              //         SvgPicture.asset(
              //           'assets/svg/icons/colored_share.svg',
              //           height: 18.sp,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),

              // ProfileFooterTitle(
              //   text: '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
              //   tealWidget:      SvgPicture.asset(
              //     'assets/svg/icons/colored_share.svg',
              //     height: 18.sp,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class NewProviderCardActionPanel extends StatelessWidget {
  const NewProviderCardActionPanel({
    super.key,
    required this.provider,
    this.isJson = true,
  });

  final User provider;

  final bool isJson;

  @override
  Widget build(BuildContext context) {
    // var grad=new Gradient(
    //     colors: [
    //       Colors.red,
    //       Colors.black
    //     ],
    //     transform: GradientTransform(
    //
    //     ),
    //     stops: []
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionItem(
          customHeight: 70.sp,
          actionItemHead: NewFollowUSerButton(user: provider, isJson: isJson),
          title: '${provider.followers == null ? '0' : getFormattedNumberWithKandM(provider.followers!)}',
          subTitle: 'followers',
          // title: '${provider.followers==null?'0':getFormattedNumberWithKandM('17003') } followers',
        ),
        ActionItem(
          customHeight: 70.sp,
          title: provider.country ?? 'UAE',
          subTitle: provider.distance ?? '0',
          actionItemHead: isJson
              ? Lottie.asset(
                  'assets/json/34716-google-icons-maps.json',
                  height: 33.sp,
                  width: 0.18.sw,
                )
              : SvgPicture.asset(
                  'assets/svg/icons/distance.svg',
                  height: 26.sp,
                ),
        ),
        ActionItem(
          customHeight: 70.sp,
          title: provider.reviewsCount ?? '0',
          subTitle: 'reviews',
          actionItemHead: isJson
              ? Lottie.asset(
                  'assets/json/104709-5-star-rating-animation-yellowgold.json',
                  height: 33.sp,
                  width: 0.18.sw,
                )
              : SvgPicture.asset(
                  'assets/svg/icons/review.svg',
                  height: 26.sp,
                ),
          onClick: () {
            showMyBottomSheet(
              context: context,
              title: 'Reviews',
              titleActionWidget: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20.sp,
                  ),
                  Text(
                    '${provider.moreData!.reviews!.totalSize.toString()} Reviews',
                    style: mainStyle(context, 13, color: mainBlueColor, weight: FontWeight.w600, textHeight: 1.5),
                  ),
                ],
              ),
              body: Expanded(
                child: ReviewsSection(
                  reviews: provider.moreData!.reviews,
                ),
              ),
            );
          },
        ),
        ActionItem(
          customHeight: 70.sp,
          title: 'Chat',
          subTitle: 'Now',
          actionItemHead: isJson
              ? Lottie.asset(
                  'assets/json/WXHfftq4mv.json',
                  height: 33.sp,
                  width: 0.18.sw,
                )
              : SvgPicture.asset(
                  'assets/svg/icons/chat.svg',
                  height: 26.sp,
                ),
          onClick: () {
            logg('chat');
            getCachedToken() == null
                ? viewMessengerLoginAlertDialog(context)
                : navigateTo(
                    context,
                    ChatLayout(
                      user: provider,
                    ));
          },
        ),
      ],
    );
  }
}

class SimpleUserCard extends StatelessWidget {
  const SimpleUserCard({
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
  final User provider;
  final String? currentLayout;
  final Function()? customCallback;
  final Function()? customBubbleCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: customCallback != null
          ? customCallback
          : () {
              justView
                  ? null
                  :
                  // comingSoonAlertDialog(context);
                  navigateToWithoutNavBar(
                      context,
                      ProviderProfileLayout(
                        providerId: provider.id.toString(),
                        lastPageAppbarTitle: currentLayout ?? 'back',
                      ),
                      '');
            },
      child: DefaultShadowedContainer(
        radius: defaultRadiusVal,
        width: double.maxFinite,
        borderColor: Colors.transparent,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: defaultHorizontalPadding,
            vertical: defaultHorizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: customBubbleCallback,
                    child: ProfileBubble(
                        radius: 33.sp,
                        isOnline: true,
                        customRingColor: mainBlueColor,
                        pictureUrl: provider.personalPicture),
                  ),
                  if (isInEdit)
                    SizedBox(
                        width: 2.2 * (33.sp),
                        height: 2 * (33.sp),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 12.sp,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: newLightGreyColor,
                                radius: 10.sp,
                                child: SvgPicture.asset(
                                  'assets/svg/icons/edit.svg',
                                  width: 12.sp,
                                ),
                              ),
                            )))
                ],
              ),
              heightBox(5.h),
              Text(
                '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
                style: mainStyle(context, 12, isBold: true, textHeight: 1.5),
              ),
              heightBox(2.h),
              Text(
                '${provider.platform!.name.toString()}',
                style: mainStyle(context, 12, isBold: true, color: mainBlueColor, textHeight: 1.5),
              ),
              if (isInEdit)
                Column(
                  children: [
                    heightBox(7.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 1.5),
                      child: DefaultButton(
                        text: 'Edit Account information and speciality',
                        customChild: Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Edit Account information and speciality',
                                  style: mainStyle(context, 12, color: newDarkGreyColor, isBold: true),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: mainBlueColor,
                                size: 13.sp,
                              )
                            ],
                          ),
                        ),
                        backColor: newLightGreyColor,
                        borderColor: newLightGreyColor,
                        titleColor: newDarkGreyColor,
                        fontSize: 11,
                        onClick: () {
                          showMyAlertDialog(context, 'Edit Account',
                              isTitleBold: true,
                              alertDialogContent: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Access provider dashboard with login, modify account specialty',
                                    style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                  ),
                                  heightBox(17.h),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: DefaultButton(
                                        text: 'Cancel',
                                        onClick: () {
                                          Navigator.pop(context);
                                        },
                                        backColor: newLightGreyColor,
                                        borderColor: newLightGreyColor,
                                        titleColor: newDarkGreyColor,
                                      )),
                                      widthBox(8.w),
                                      Expanded(
                                          child: DefaultButton(
                                              text: 'Continue',
                                              onClick: () {
                                                launchUrl(Uri.parse('https://dashboard.menaplatforms.com/'));
                                              })),
                                    ],
                                  )
                                ],
                              ));
                        },
                      ),
                    ),
                    heightBox(15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DefaultContainer(
                          backColor: newLightGreyColor,
                          borderColor: newLightGreyColor,
                          childWidget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/profile/users_3_outline_56.svg',
                                  height: 27.sp,
                                ),
                                widthBox(9.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heightBox(7.h),
                                    Text(
                                      'No connections',
                                      style: mainStyle(context, 11, isBold: true),
                                    ),
                                    heightBox(7.h),
                                    Text(
                                      '2.4K connections',
                                      style: mainStyle(context, 10, isBold: true, color: newDarkGreyColor),
                                    ),
                                    Text(
                                      '',
                                      style: mainStyle(context, 10, isBold: true, color: mainBlueColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (provider.moreData != null) widthBox(7.w),
                        if (provider.moreData != null)
                          GestureDetector(
                            onTap: () {
                              var profileCubit = ProfileCubit.get(context);
                              profileCubit.updateSelectedSourceType(null);
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController entityTitleCont = TextEditingController();
                              TextEditingController accreditedByCont = TextEditingController();
                              TextEditingController pointsCont = TextEditingController();
                              TextEditingController startYearCont = TextEditingController();
                              TextEditingController endYearCont = TextEditingController();
                              showMyBottomSheet(
                                  context: context,
                                  title: 'Add (CME / CPD / CE Points)',
                                  body: BlocConsumer<ProfileCubit, ProfileState>(
                                    listener: (context, state) {
                                      // TODO: implement listener
                                    },
                                    builder: (context, state) {
                                      return Expanded(
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ///
                                                      DefaultInputField(
                                                        controller: entityTitleCont,
                                                        label: 'Give title of this entity',
                                                        validate: normalInputValidate,
                                                      ),
                                                      heightBox(10.h),
                                                      MyPullDownButton(
                                                        svgLink: 'assets/svg/icons/addcircle.svg',
                                                        svgHeight: Responsive.isMobile(context) ? 25.w : 12.w,
                                                        customWidth: 0.485.sw,
                                                        customOffset: const Offset(7, 1),
                                                        customButtonWidget: DefaultInputField(
                                                          readOnly: true,
                                                          enabled: false,
                                                          validate: (String? val) {
                                                            if (profileCubit.selectedSourceType == null) {
                                                              return getTranslatedStrings(context).thisFieldIsRequired;
                                                            }
                                                            return null;
                                                          },
                                                          // onTap: () {
                                                          //   /// drop down (online - in person)
                                                          //
                                                          // },
                                                          label: profileCubit.selectedSourceType ??
                                                              'source type (online – in person)',
                                                        ),
                                                        items: [
                                                          ItemWithTitleAndCallback(
                                                            title: 'Online',
                                                            thumbnailLink: null,
                                                            onClickCallback: () {
                                                              logg('dshjfjkh');
                                                              profileCubit.updateSelectedSourceType('Online');
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          ItemWithTitleAndCallback(
                                                            title: 'In person',
                                                            thumbnailLink: null,
                                                            onClickCallback: () {
                                                              logg('dshjfjkh');
                                                              profileCubit.updateSelectedSourceType('In person');
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      // DefaultInputField(
                                                      //   readOnly: true,
                                                      //   onTap: () {
                                                      //     /// drop down (online - in person)
                                                      //
                                                      //   },
                                                      //   label: 'source type (online – in person)',
                                                      // ),
                                                      heightBox(10.h),
                                                      DefaultInputField(
                                                        controller: accreditedByCont,
                                                        label: 'CME Accredited by',
                                                        validate: normalInputValidate,
                                                      ),
                                                      // heightBox(10.h),
                                                      // DefaultInputField(
                                                      //   label: 'Give title of this entity',
                                                      // ),
                                                      heightBox(10.h),
                                                      DefaultInputField(
                                                        controller: pointsCont,
                                                        label: 'Enter your points',
                                                        validate: isNumberValidate(context),
                                                      ),
                                                      heightBox(10.h),
                                                      DefaultInputField(
                                                        readOnly: true,
                                                        onTap: () async {
                                                          ///
                                                          ///
                                                          ///
                                                          /// pick file
                                                          ///
                                                          ///
                                                          ///
                                                          FilePickerResult? selectedFile;

                                                          selectedFile = await FilePicker.platform.pickFiles(
                                                            type: FileType.custom,
                                                            allowedExtensions: ['pdf', 'jpg'],
                                                            //allowed extension to choose
                                                          );
                                                          File temp = File(selectedFile!.files.single.path!);
                                                          MultipartFile file;
                                                          file = await MultipartFile.fromFile(
                                                            temp.path,
                                                            filename: temp.path.split('/').last,
                                                          );
                                                          profileCubit.updateCertificateFile(file);
                                                        },
                                                        label: 'Upload certificate (optional)',
                                                      ),
                                                      heightBox(10.h),
                                                      // if (profileCubit.attachedCertificateFile != null) heightBox(10.h),
                                                      if (profileCubit.attachedCertificateFile != null)
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: defaultHorizontalPadding),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Text(profileCubit
                                                                      .attachedCertificateFile!.filename
                                                                      .toString())),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  profileCubit.updateCertificateFile(null);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      if (profileCubit.attachedCertificateFile != null) heightBox(10.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: DefaultInputField(
                                                            controller: startYearCont,
                                                            label: 'Start  year',
                                                            validate: yearBeforeCurrentValidate(context),
                                                          )),
                                                          widthBox(8.w),
                                                          Expanded(
                                                            child: DefaultInputField(
                                                              controller: endYearCont,
                                                              label: 'End Year',
                                                              validate: yearBeforeCurrentValidate(context),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      heightBox(10.h),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              state is UpdatingDataState
                                                  ? DefaultLoaderColor()
                                                  : DefaultButton(
                                                      text: 'Save',
                                                      onClick: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          profileCubit
                                                              .saveCme(
                                                            entityTitle: endYearCont.text,
                                                            accreditedBy: accreditedByCont.text,
                                                            points: pointsCont.text,
                                                            startingYear: startYearCont.text,
                                                            endingYear: endYearCont.text,
                                                          )
                                                              .then((value) {
                                                            MainCubit.get(context).getUserInfo().then((value) {
                                                              Navigator.pop(context);
                                                            });
                                                          });
                                                        }
                                                      })
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                            },
                            child: DefaultContainer(
                              backColor: newLightGreyColor,
                              borderColor: newLightGreyColor,
                              childWidget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/icons/profile/donate_outline_56.svg',
                                      height: 27.sp,
                                    ),
                                    widthBox(12.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.moreData!.cmePoints ?? '-',
                                          style: mainStyle(context, 11, isBold: true),
                                        ),
                                        heightBox(7.h),
                                        Text(
                                          'CME/ CPD Points',
                                          style: mainStyle(context, 10, isBold: true, color: newDarkGreyColor),
                                        ),
                                        heightBox(7.h),
                                        Text(
                                          'View details',
                                          style: mainStyle(context, 10, isBold: true, color: mainBlueColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentProviderCard extends StatelessWidget {
  const AppointmentProviderCard({
    Key? key,
    this.justView = false,
    required this.provider,
    required this.currentLayout,
  }) : super(key: key);

  final bool justView;
  final User provider;
  final String? currentLayout;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   justView
      //       ? null
      //       :
      //       // comingSoonAlertDialog(context);
      //       navigateToWithoutNavBar(
      //           context,
      //           ProviderProfileLayout(
      //             providerId: provider.id.toString(),
      //             lastPageAppbarTitle: currentLayout ?? 'back',
      //           ),
      //           '');
      // },
      child: DefaultShadowedContainer(
        radius: 18.sp,
        borderColor: Colors.transparent,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 1.0.sp,
            vertical: 12.sp,
          ),
          child: Column(
            children: [
              ProviderAppointmentCard(
                justView: justView,
                provider: provider,
              ),
              heightBox(15.h),
              ProviderCardAppointmentActionBar(
                provider: provider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderCardBody extends StatelessWidget {
  const ProviderCardBody({Key? key, this.justView = false, required this.provider}) : super(key: key);
  final bool justView;
  final User provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            ProfileBubble(
                radius: 28.sp, isOnline: true, customRingColor: mainBlueColor, pictureUrl: provider.personalPicture),
            heightBox(10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: const DefaultSoftButton(
                label: 'Follow',
              ),
            )
          ],
        ),
        widthBox(7.w),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // heightBox(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
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
                                            '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
                                            style: mainStyle(context, 12, isBold: true, textHeight: 1.5),
                                          ),
                                        ),
                                        (provider.verified == '1')
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    if (provider.specialities != null)
                                      if (provider.specialities!.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            heightBox(8.h),
                                            Text(
                                              provider.specialities![0].name ?? '-',
                                              style:
                                                  mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              heightBox(5.h),
              Text(
                '${provider.summary ?? '-'}',
                style: mainStyle(context, 12, textHeight: 1),
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              heightBox(5.h),
              RichText(
                text: TextSpan(
                  text: 'Registration No: ',
                  style: mainStyle(context, 9.0, textHeight: 1.5, color: mainBlueColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: provider.registrationNumber ?? '-',
                      style: mainStyle(context, 10.0, color: mainBlueColor, weight: FontWeight.w800, textHeight: 1.5),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Registration No: ${provider.registrationNumber}',
              //   style: mainStyle(context,13, color: mainBlueColor),
              // ),
              heightBox(2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Icon(
                  //   Icons.star,
                  //   size: 18.sp,
                  //   color: const Color(0xffFFC700),
                  // ),
                  provider.country == null
                      ? SizedBox()
                      : Row(
                          children: [
                            Text(
                              '${provider.country ?? '-'}',
                              style: mainStyle(
                                context,
                                11,
                              ),
                            ),
                            widthBox(7.w),
                          ],
                        ),
                  Icon(
                    Icons.location_on,
                    size: 15.sp,
                    color: mainBlueColor,
                  ),
                  widthBox(4.w),
                  Text('${provider.distance ?? '-'}', style: mainStyle(context, 11)),
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}

class NewProviderCardBody extends StatelessWidget {
  const NewProviderCardBody({Key? key, this.justView = false, required this.provider}) : super(key: key);
  final bool justView;
  final User provider;

  @override
  Widget build(BuildContext context) {
    return Container(
// color: Colors.red,
//       height: 130.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileBubble(
                      radius: 35.sp,
                      isOnline: true,
                      customRingColor: mainBlueColor,
                      pictureUrl: provider.personalPicture),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     // Icon(
                  //     //   Icons.star,
                  //     //   size: 18.sp,
                  //     //   color: const Color(0xffFFC700),
                  //     // ),
                  //     Icon(
                  //       Icons.location_on,
                  //       size: 15.sp,
                  //       color: mainBlueColor,
                  //     ),
                  //     heightBox(4.w),
                  //     provider.country == null
                  //         ? Text(
                  //             'country',
                  //             style: mainStyle(context, 11, color: newDarkGreyColor, isBold: true),
                  //           )
                  //         : Row(
                  //             children: [
                  //               Text(
                  //                 '${provider.country ?? '-'}',
                  //                 style: mainStyle(
                  //                   context,
                  //                   11,
                  //                 ),
                  //               ),
                  //               widthBox(7.w),
                  //             ],
                  //           ),
                  //     heightBox(4.w),
                  //     Text('${provider.distance ?? '-'}',
                  //         style: mainStyle(context, 11, color: newDarkGreyColor, weight: FontWeight.w700)),
                  //   ],
                  // )
                  // heightBox(10.h),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  //   child: const DefaultSoftButton(
                  //     label: 'Follow',
                  //   ),
                  // )
                ],
              ),
              widthBox(2.w),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Text(
                      //   'About',
                      //   style: mainStyle(
                      //     context,
                      //     12,
                      //     textHeight: 1,
                      //     color: newDarkGreyColor,
                      //     weight: FontWeight.w700,
                      //   ),
                      //   maxLines: 1,
                      //   textAlign: TextAlign.justify,
                      //   softWrap: false,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // // heightBox(5.h),
                      // Divider(
                      //   thickness: 2,
                      //   height: 5.h,
                      // ),
                      heightBox(5.h),
                      // heightBox(5.h),
                      // Expanded(
                      //   // child: Text(
                      //   //   '${provider.summary != null ? provider.summary!.isNotEmpty ? provider.summary : 'Lorem Ipsum is simply dummy text of printing and typesetting industry. Lorem Ipsum has industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.' : ''}',
                      //   //   style: mainStyle(
                      //   //     context,
                      //   //     12,
                      //   //     textHeight: 1,
                      //   //     color: newDarkGreyColor,
                      //   //     weight: FontWeight.w700,
                      //   //   ),
                      //   //   maxLines: 7,
                      //   //   textAlign: TextAlign.justify,
                      //   //   softWrap: false,
                      //   //   overflow: TextOverflow.ellipsis,
                      //   // ),
                      // ),
                      RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: 'Bio: ',
                          style: mainStyle(context, 11, color: mainBlueColor, weight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${provider.summary != null ? provider.summary!.isNotEmpty ? provider.summary : 'Lorem Ipsum is simply dummy text of printing and typesetting industry. Lorem Ipsum has industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.' : ''}',
                              style: mainStyle(
                                context,
                                11,
                                textHeight: 1,
                                color: newDarkGreyColor,
                                weight: FontWeight.w700,
                              ),
                              // maxLines: 7,
                              // textAlign: TextAlign.justify,
                              // softWrap: false,
                              // overflow: TextOverflow.ellipsis,                              ),
                            ),
                          ],
                        ),
                      ),
                      heightBox(4.h),
                      RichText(
                        text: TextSpan(
                          text: 'Registration No: ',
                          style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: provider.registrationNumber ?? '-',
                              style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      heightBox(4.h),

                      RichText(
                        text: TextSpan(
                          text: 'Languages spoken: ',
                          style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: provider.registrationNumber ?? '-',
                              style: mainStyle(context, 10, color: mainBlueColor, weight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // heightBox(5.h),

                      // Text(
                      //   'Registration No: ${provider.registrationNumber}',
                      //   style: mainStyle(context,13, color: mainBlueColor),
                      // ),
                      // heightBox(2.h),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class ProviderAppointmentCard extends StatelessWidget {
  const ProviderAppointmentCard({Key? key, this.justView = false, required this.provider}) : super(key: key);
  final bool justView;
  final User provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            ProfileBubble(radius: 28.sp, isOnline: false, pictureUrl: provider.personalPicture),
            // heightBox(10.h),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 1.0),
            //   child: const DefaultSoftButton(
            //     label: 'Follow',
            //   ),
            // )
          ],
        ),
        widthBox(3.w),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // heightBox(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
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
                                            '${provider.abbreviation == null ? '' : provider.abbreviation!.name! + ' '}${provider.fullName}',
                                            style: mainStyle(context, 12, isBold: true, textHeight: 1.5),
                                          ),
                                        ),
                                        (provider.verified == '1')
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    if (provider.specialities != null)
                                      if (provider.specialities!.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            heightBox(8.h),
                                            Text(
                                              provider.specialities![0].name ?? '-',
                                              style: mainStyle(context, 11,
                                                  // color: mainBlueColor,
                                                  weight: FontWeight.normal),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // heightBox(5.h),
              // Text(
              //   '${provider.summary ?? '-'}',
              //   style: mainStyle(context, 12, textHeight: 1.2),
              //   // textAlign: TextAlign.justify,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              heightBox(5.h),
              RichText(
                text: TextSpan(
                  text: 'Registration No: ',
                  style: mainStyle(context, 9.0, textHeight: 1.5, color: mainBlueColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: provider.registrationNumber ?? '-',
                      style: mainStyle(context, 10.0, color: mainBlueColor, weight: FontWeight.w800, textHeight: 1.5),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Registration No: ${provider.registrationNumber}',
              //   style: mainStyle(context,13, color: mainBlueColor),
              // ),
              heightBox(7.h),
              // heightBox(5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/svg/icons/fee.svg',
                    width: 15.sp,
                    // color: mainBlueColor,
                  ),
                  widthBox(4.w),
                  Text('Fee:  ', style: mainStyle(context, 11)),
                  Text('FREE', style: mainStyle(context, 11, color: Colors.red, isBold: true)),
                ],
              ),
              heightBox(7.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/svg/icons/bag.svg',
                    width: 15.sp,
                    // color: mainBlueColor,
                  ),
                  widthBox(4.w),
                  Container(
                      constraints: BoxConstraints(maxWidth: 200.w),
                      child: Text(
                        provider.specialities!.isEmpty ? '-' : provider.specialities![0].name ?? '',
                        style: mainStyle(context, 12),
                      )),
                  widthBox(4.w),
                  if (provider.specialities!.length > 1)
                    Container(
                      color: Colors.grey.withOpacity(0.5),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2),
                        child: Text(
                          '+ ' + provider.specialities!.length.toString(),
                          style: mainStyle(context, 8, color: mainBlueColor, isBold: true),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}

class ProviderCardAppointmentActionBar extends StatelessWidget {
  const ProviderCardAppointmentActionBar({Key? key, required this.provider}) : super(key: key);

  final User provider;

  @override
  Widget build(BuildContext context) {
    List<Widget> itemActions = [
      ActionItem(
        title: 'Profile',
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/profile doc.svg',
          height: 18.sp,
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'Likes',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/love heart.svg',
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.likes ?? '-'}',
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            )
          ],
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'Followers',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/community.svg',
              color: mainBlueColor,
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.followers ?? '-'}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            )
          ],
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'Reviews',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/star.svg',
              color: mainBlueColor,
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.reviewsRate ?? '-'}',
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [...itemActions],
    );
  }
}

class ProviderCardActionBar extends StatelessWidget {
  const ProviderCardActionBar({Key? key, required this.provider}) : super(key: key);

  final User provider;

  @override
  Widget build(BuildContext context) {
    List<Widget> itemActions = [
      ActionItem(
        title: 'Likes',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/love heart.svg',
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.likes ?? '-'}',
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            )
          ],
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'Followers',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/community.svg',
              color: mainBlueColor,
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.followers ?? '-'}',
              textAlign: TextAlign.center,
              softWrap: true,
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            )
          ],
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'Reviews',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/star.svg',
              color: mainBlueColor,
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '${provider.reviewsRate ?? '-'}',
              style: mainStyle(context, 10.sp, color: mainBlueColor, textHeight: 1.4, weight: FontWeight.bold),
            ),
          ],
        ),
      ),
      const HorizontalSeparator(),
      ActionItem(
        title: 'share',
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/colored_share.svg',
          height: 18.sp,
        ),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [...itemActions],
    );
  }
}

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.7,
      color: mainBlueColor,
      height: 30.h,
    );
  }
}
