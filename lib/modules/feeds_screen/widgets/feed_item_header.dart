import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/cache/cache.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../../../models/local_models.dart';
import '../../messenger/chat_layout.dart';
import '../../platform_provider/provider_home/provider_profile.dart';
import '../cubit/feeds_cubit.dart';
import '../feeds_screen.dart';
import '../post_a_feed.dart';
import 'follow_user_button.dart';

class FeedItemHeader extends StatelessWidget {
  const FeedItemHeader({
    Key? key,
    required this.menaFeed,
    required this.inPublicFeeds,
    required this.isMyFeeds,
  }) : super(key: key);
  final MenaFeed menaFeed;

  final bool inPublicFeeds;

  final bool isMyFeeds;

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  navigateToWithoutNavBar(
                      context,
                      ProviderProfileLayout(providerId: menaFeed.user!.id.toString(), lastPageAppbarTitle: 'back'),
                      'routeName');
                },
                child: Row(
                  children: [
                    ProfileBubble(
                      isOnline: false,
                      radius: 21.sp,
                      pictureUrl: menaFeed.user!.personalPicture,
                    ),
                    widthBox(10.w),
                    Flexible(
                      child: SizedBox(
                        // height: 44.sp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      constraints: BoxConstraints(maxWidth: 133.w),
                                      child: Text(
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        '${menaFeed.user!.abbreviation == null ? '' : '${menaFeed.user!.abbreviation!.name} '}${menaFeed.user!.fullName}',
                                        style: mainStyle(context, 13, weight: FontWeight.w800),
                                      ),
                                    ),
                                    (menaFeed.user!.verified == '1')
                                        ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Icon(
                                        Icons.verified,
                                        color: Color(0xff01BC62),
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
                              menaFeed.user!.speciality == null
                                  ? menaFeed.user!.specialities!.isNotEmpty
                                  ? menaFeed.user!.specialities![0].name
                                  : '--'
                                  : menaFeed.user!.speciality,
                              style: mainStyle(context, 10, color: mainBlueColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                if (!isMyFeeds)
                  FollowUSerButton(
                    user: menaFeed.user!,
                  ),
                widthBox(1.w),
                PullDownButton(
                  itemBuilder: (innerContext) {
                    List<FeedActionItem> actionItems = isMyFeeds
                        ? [
                      FeedActionItem(
                        id: '0',
                        title: getTranslatedStrings(context).hide,
                      ),
                      FeedActionItem(
                        id: '1',
                        title: getTranslatedStrings(context).report,
                      ),
                      FeedActionItem(
                        id: '2',
                        title: getTranslatedStrings(context).delete,
                      ),
                      FeedActionItem(
                        id: '3',
                        title: getTranslatedStrings(context).edit,
                      ),
                    ]
                        : [
                      FeedActionItem(
                        id: '0',
                        title: getTranslatedStrings(context).hide,
                      ),
                      FeedActionItem(
                        id: '1',
                        title: getTranslatedStrings(context).report,
                      ),
                    ];
                    return actionItems
                        .map((e) => PullDownMenuItem(
                      onTap: () async {
                        if (e.id == '0') {
                          showMyAlertDialog(
                            context,
                            getTranslatedStrings(context).hideFeed,
                            isTitleBold: true,
                            alertDialogContent: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslatedStrings(context).areYouSureYouWatHideFeed,
                                  style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                ),
                                heightBox(15.h),
                                Text(
                                  getTranslatedStrings(context).thePrivacyWillChangeToOnlyMe,
                                  // textAlign: TextAlign.center,
                                  style: mainStyle(context, 11,
                                      color: newLightTextGreyColor, weight: FontWeight.w700),
                                ),
                                heightBox(10.h),
                                Center(
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 0.5.sw),
                                    child: BlocConsumer<FeedsCubit, FeedsState>(
                                      listener: (context, state) {
                                        // TODO: implement listener
                                      },
                                      builder: (context, state) {
                                        return state is DeletingFeedsState
                                            ? LinearProgressIndicator()
                                            : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DefaultButton(
                                              height: 28.h,
                                              withoutPadding: true,
                                              onClick: () {
                                                feedsCubit
                                                    .hideFeed(feedId: menaFeed.id.toString())
                                                    .then((value) {
                                                  feedsCubit.getFeeds(
                                                      providerId: isMyFeeds
                                                          ? menaFeed.user!.id.toString()
                                                          : null);
                                                  Navigator.pop(context);
                                                });
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
                            context, getTranslatedStrings(context).deleteFeed,
                            isTitleBold: true,
                            alertDialogContent: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  getTranslatedStrings(context).areYouSureDelete,
                                  style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                ),
                                heightBox(10.h),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 0.5.sw),
                                  child: Row(
                                    children: [
                                      BlocConsumer<FeedsCubit, FeedsState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                        },
                                        builder: (context, state) {
                                          return state is DeletingFeedsState
                                              ? LinearProgressIndicator()
                                              : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DefaultButton(
                                                  height: 28.h,
                                                  withoutPadding: true,
                                                  onClick: () {
                                                    feedsCubit
                                                        .deleteFeed(feedId: menaFeed.id.toString())
                                                        .then((value) {
                                                      feedsCubit.getFeeds(
                                                          providerId: (isMyFeeds && !inPublicFeeds)
                                                              ? menaFeed.user!.id.toString()
                                                              : null);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  text: getTranslatedStrings(context).yes),
                                            ),
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DefaultButton(
                                              height: 28.h,
                                              withoutPadding: true,
                                              // width: 0.1.sw,
                                              backColor: newLightTextGreyColor,
                                              borderColor: newLightTextGreyColor,
                                              titleColor: Colors.black,
                                              onClick: () {
                                                Navigator.pop(context);
                                              },
                                              text: getTranslatedStrings(context).no),
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
                          TextEditingController textEditingController = TextEditingController();
                          showMyBottomSheet(
                              context: context,
                              title: getTranslatedStrings(context).report,
                              body: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslatedStrings(context).reportDescription,
                                      style:
                                      mainStyle(context, 14, color: Colors.black, weight: FontWeight.w700),
                                    ),
                                    Text(
                                      '0/200',
                                      style: mainStyle(context, 12,
                                          color: newDarkGreyColor, weight: FontWeight.w700),
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
                                  controller: textEditingController,
                                  focusedBorderColor: Colors.transparent,
                                  unFocusedBorderColor: Colors.transparent,
                                  floatingLabelAlignment: FloatingLabelAlignment.start,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  // customHintText: 'Provide details to help us understand the problem',
                                  withoutLabelPadding: true,
                                  maxLines: 3,
                                  label: getTranslatedStrings(context).provideDetailsHelpUnderstandProblem,
                                  // labelWidget: Text(
                                  //   getTranslatedStrings(context).provideDetailsHelpUnderstandProblem,
                                  //   style: mainStyle(context, 10, color: newDarkGreyColor),
                                  // ),
                                ),
                                heightBox(15.h),
                                BlocConsumer<FeedsCubit, FeedsState>(
                                  listener: (context, state) {
                                    // TODO: implement listener
                                  },
                                  builder: (context, state) {
                                    var feedsCubit = FeedsCubit.get(context);
                                    return Container(
                                      height: 0.22.sw,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return AttachedFileHandle(
                                                  xfile: feedsCubit.attachedReportFiles[index],
                                                  customWidthForHorizontalView: 0.18.sw,
                                                  customHeight: double.maxFinite,
                                                  fn: () {
                                                    feedsCubit.removeReportAttachments(index);
                                                  },
                                                );
                                              },
                                              separatorBuilder: (c, i) => widthBox(0.w),
                                              itemCount: feedsCubit.attachedReportFiles.length,
                                            ),
                                            if (feedsCubit.attachedReportFiles.length < 4)
                                              GestureDetector(
                                                onTap: () async {
                                                  logg('picking file');
                                                  final ImagePicker _picker = ImagePicker();
                                                  final List<XFile>? photos = await _picker.pickMultiImage();
                                                  if (photos != null) {
                                                    feedsCubit.updateReportAttachedFile(null, xFiles: photos);
                                                  }
                                                },
                                                child: DefaultContainer(
                                                    height: double.maxFinite,
                                                    width: 0.18.sw,
                                                    borderColor: Colors.transparent,
                                                    backColor: newLightGreyColor,
                                                    childWidget: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/svg/icons/gallery.svg',
                                                              color: newDarkGreyColor,
                                                            ),
                                                            heightBox(5.h),
                                                            Text(
                                                              '${feedsCubit.attachedReportFiles.length}/4',
                                                              style: mainStyle(context, 12,
                                                                  color: newDarkGreyColor, weight: FontWeight.w700),
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
                                  getTranslatedStrings(context).immediatePhysicalDanger,
                                  style: mainStyle(context, 12, color: newDarkGreyColor),
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
                                      child: BlocConsumer<FeedsCubit, FeedsState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                        },
                                        builder: (context, state) {
                                          return state is ReportingFeedsState
                                              ? LinearProgressIndicator()
                                              : DefaultButton(
                                              height: 33.h,
                                              withoutPadding: true,
                                              onClick: () {
                                                if (textEditingController.text.isNotEmpty) {
                                                  feedsCubit
                                                      .reportFeed(
                                                      feedId: menaFeed.id.toString(),
                                                      reason: textEditingController.text)
                                                      .then((value) {
                                                    logg('jskhajdkfh: $inPublicFeeds , $isMyFeeds');
                                                    feedsCubit.getFeeds(
                                                        providerId: inPublicFeeds
                                                            ? null
                                                            : isMyFeeds
                                                            ? menaFeed.user!.id.toString()
                                                            : null);
                                                    Navigator.pop(context);
                                                  });
                                                } else {
                                                  showMyAlertDialog(context,
                                                      getTranslatedStrings(context).reportReasonRequired,
                                                      alertDialogContent: Text(
                                                          getTranslatedStrings(context).explainReasons));
                                                }
                                              },
                                              text: getTranslatedStrings(context).sendReport);
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
                          navigateToWithoutNavBar(context, PostAFeedLayout(feed: menaFeed), '');
                        } else {}
                      },
                      title: e.title,
                      textStyle: mainStyle(context, 13, weight: FontWeight.w600, color: Colors.black),
                    ))
                        .toList();
                  },
                  position: PullDownMenuPosition.over,
                  backgroundColor: Colors.white.withOpacity(0.75),
                  offset: const Offset(-2, 1),
                  applyOpacity: true,
                  widthConfiguration: PullDownMenuWidthConfiguration(0.4.sw),
                  buttonBuilder: (context, showMenu) => CupertinoButton(
                    onPressed: showMenu,
                    padding: EdgeInsets.zero,
                    child: SvgPicture.asset('assets/svg/icons/3dots.svg'),
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
        );
      },
    );
  }
}
