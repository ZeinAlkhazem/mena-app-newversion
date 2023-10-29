import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/feeds_model.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';

import '../../models/api_model/home_section_model.dart';
import '../messenger/chat_layout.dart';
import 'widgets/alert_dialog.dart';

class PostAFeedLayout extends StatefulWidget {
  const PostAFeedLayout({Key? key, this.feed}) : super(key: key);

  final MenaFeed? feed;

  @override
  State<PostAFeedLayout> createState() => _PostAFeedLayoutState();
}

class _PostAFeedLayoutState extends State<PostAFeedLayout> {
  // final User currentUser;
  double inDy = 0;
  double lastDy = 0;
  final TextEditingController feedInputController = TextEditingController();

  @override
  void initState() {
    if (widget.feed == null) {
      /// new feed
      feedInputController.text = '';
      FeedsCubit.get(context).updateFeedAudience('Everyone');
      FeedsCubit.get(context).resetAttachedFiles();
      FeedsCubit.get(context).updatePickedFeedLocation(null);
    } else {
      /// update feed
      feedInputController.text = widget.feed!.text ?? '';
      FeedsCubit.get(context).updateFeedAudience(widget.feed!.audience);
      logg(widget.feed!.files.toString());
      if (widget.feed!.files != null) {
        logg('x');
        if (widget.feed!.files!.isNotEmpty) {
          logg('y');
          //todo check
          FeedsCubit.get(context).attachedFiles.clear();
          widget.feed!.files!.forEach((element) async {
            logg('z');
            var file = await DefaultCacheManager().getSingleFile(element.path!);
            XFile result = await XFile(file.path);
            FeedsCubit.get(context).updateAttachedFile(result);
          });
        }
      } else {
        logg('yt');
      }

      if (widget.feed!.lat != null && widget.feed!.lng != null) {
        FeedsCubit.get(context).updatePickedFeedLocation(PickedLocationModel(
            name: 'Location picked', latLng: LatLng(double.tryParse(widget.feed!.lat!) ?? 0, double.tryParse(widget.feed!.lng!) ?? 0)));
      }

      /// make loop on files thn update attached files
      /// check location
      /// check audience
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// if not logged in will not arrive here so no need to check
    User currentUser = MainCubit.get(context).userInfoModel!.data.user;
    var feedsCubit = FeedsCubit.get(context);

    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        if (state is NoDataToSendState) {
          showMyAlertDialog(context, 'Please add a content to share');
        }

        if (state is SuccessSendingFeedState) {
          feedsCubit.resetAttachedFiles();
          feedsCubit.updatePickedFeedLocation(null);
          ///
          ///
          ///

          // feedsCubit.getFeeds();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Listener(
          onPointerDown: (e) {
            inDy = e.localPosition.dy;
          },
          onPointerUp: (event) {
            lastDy = event.localPosition.dy;
            logg('iny: ${inDy.toString()}');
            logg('lastDy: ${lastDy.toString()}');
            if (lastDy != inDy) {
              logg('pointer moved');
            } else {
              logg('pointer not moved');
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: newLightGreyColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56.0.h),
                child: DefaultBackTitleAppBar(
                  // title: getTranslatedStrings(context).newPost,
                  customTitleWidget: Padding(
                    padding: const EdgeInsets.only (left:8.0),
                    child: Text(getTranslatedStrings(context).newPost, style:mainStyle(context, 22, weight: FontWeight.w500, color: Colors.black, isBold: true, letterSpacing: 0.2)),
                  ),
                  customIcon: SvgPicture.asset("assets/svg/icons/close.svg", color: nesWecBlueColor,),
                  suffix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                    child: state is SendingFeedState
                        ? DefaultLoaderColor()
                        : DefaultButton(
                            width: 0.2.sw,
                            height: 25.h,
                            fontSize: 18,
                            backColor: newLightGreyColor,
                            borderColor: newLightGreyColor,
                            withoutPadding: true,
                            titleColor: nesWecBlueColor,
                            text: getTranslatedStrings(context).create,
                            onClick: () {
                              // if (feedInputController.text.isNotEmpty || feedsCubit.attachedFiles.isNotEmpty) {
                                feedsCubit.postFeed(feed: widget.feed, feedText: feedInputController.text);
                              // }
                            }),
                  ),
                  // suffix: GestureDetector(
                  //   onTap: () {},
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //     child: SvgPicture.asset('assets/svg/icons/search.svg'),
                  //   ),
                  // ),
                ),
              ),
              // appBar: AppBar(
              //   backgroundColor: Colors.white,
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: state is SendingFeedState
              //           ? DefaultLoaderColor()
              //           : DefaultButton(
              //               width: 0.2.sw,
              //               fontSize: 12,
              //               text: getTranslatedStrings(context).share.toUpperCase(),
              //               onClick: () {
              //                 feedsCubit.postFeed(feed: widget.feed, feedText: feedInputController.text);
              //               }),
              //     )
              //   ],
              //   iconTheme: IconThemeData(color: mainBlueColor),
              //   elevation: 0.3,
              //   title: Text(
              //     '',
              //     style: mainStyle(context, 13, color: mainBlueColor),
              //   ),
              //   centerTitle: true,
              // ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: defaultHorizontalPadding),
                  child: Column(
                    children: [

                      heightBox(10.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     ProfileBubble(
                              //       isOnline: false,
                              //       pictureUrl: currentUser.personalPicture,
                              //       radius: 15.h,
                              //     ),

                                  
                              //     widthBox(10.w),
                              //     // GestureDetector(
                              //     //     onTap: () {
                              //     //       showMyAlertDialog(context, 'Privacy',
                              //     //           alertDialogContent: BlocConsumer<FeedsCubit, FeedsState>(
                              //     //             listener: (context, state) {
                              //     //               // TODO: implement listener
                              //     //             },
                              //     //             builder: (context, state) {
                              //     //               return Column(
                              //     //                 mainAxisSize: MainAxisSize.min,
                              //     //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //     //                 children: [
                              //     //                   Text(
                              //     //                     'Who can view this post',
                              //     //                     style: mainStyle(context, 12, color: newDarkGreyColor),
                              //     //                   ),
                              //     //                   heightBox(7.h),
                              //     //                   Column(
                              //     //                     mainAxisSize: MainAxisSize.min,
                              //     //                     children: ['Everyone', 'Providers', 'Only me']
                              //     //                         .map((e) => Padding(
                              //     //                               padding: const EdgeInsets.all(4.0),
                              //     //                               child: GestureDetector(
                              //     //                                 onTap: () {
                              //     //                                   feedsCubit.updateFeedAudience(e);
                              //     //                                 },
                              //     //                                 child: AlertDialogSelectorItem(
                              //     //                                   label: e,
                              //     //                                   isSelected: feedsCubit.currentAudience == e,
                              //     //                                   customFontColor: feedsCubit.currentAudience == e
                              //     //                                       ? Colors.white
                              //     //                                       : mainBlueColor,
                              //     //                                   customColor: feedsCubit.currentAudience == e
                              //     //                                       ? mainBlueColor
                              //     //                                       : softBlueColor,
                              //     //                                 ),
                              //     //                               ),
                              //     //                             ))
                              //     //                         .toList(),
                              //     //                   ),
                              //     //                 ],
                              //     //               );
                              //     //             },
                              //     //           ));
                              //     //     },
                              //     //     child: DefaultContainer(
                              //     //       radius: 5,
                              //     //       backColor: Colors.transparent,
                              //     //       borderColor: newDarkGreyColor,
                              //     //       childWidget: Padding(
                              //     //         padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                              //     //         child: Row(
                              //     //           children: [
                              //     //             // SvgPicture.asset(
                              //     //             //   'assets/svg/icons/profile face.svg',
                              //     //             //   color: mainBlueColor,
                              //     //             //   height: 15.h,
                              //     //             // ),
                              //     //             // widthBox(10.w),
                              //     //             Text(
                              //     //               feedsCubit.currentAudience,
                              //     //               style: mainStyle(context, 10),
                              //     //             ),
                              //     //             widthBox(10.w),
                              //     //             SvgPicture.asset('assets/svg/icons/arrow_down_base.svg')
                              //     //           ],
                              //     //         ),
                              //     //       ),
                              //     //     )),
                              //   ],
                              // ),
                              heightBox(12.h),
                              SizedBox(
                                height: 300,
                                child:
                              
                                 TextFormField(
                                  decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: getTranslatedStrings(context).whatIsNew
                                  ),
                                  
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                
                                  controller: feedInputController,
                                  // labelWidget: Text(
                                  //   getTranslatedStrings(context).shareYourThoughts,
                                  //   style: mainStyle(context, 14, isBold: true, color: newDarkGreyColor),
                                  // ),
                                ),
                              ),
                              if (feedsCubit.attachedFiles.isNotEmpty)
                                ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AttachedFileHandle(
                                      xfile: feedsCubit.attachedFiles[index],
                                      fn: () {
                                        feedsCubit.removeAttachments(index);
                                      },
                                    );
                                  },
                                  separatorBuilder: (_, i) => Divider(),
                                  itemCount: feedsCubit.attachedFiles.length,
                                ),
                              // Text('Add a pictures'),
                              // heightBox(5.h),
                              // Container(
                              //   child: GridView.count(
                              //     crossAxisCount: 4,
                              //     shrinkWrap: true,
                              //     children: [
                              //       Container(
                              //         color: auxSoftGreyColor,
                              //         child: Center(
                              //           child: Icon(Icons.add),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          feedsCubit.pickedFeedLocation == null
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: mainBlueColor,
                                    ),
                                    widthBox(4.w),
                                    Expanded(
                                      child: Text(
                                        '${feedsCubit.pickedFeedLocation!.name}',
                                        style: mainStyle(context, 12, color: mainBlueColor),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        feedsCubit.updatePickedFeedLocation(null);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                          Divider(
                            color: Colors.black38,
                            thickness: 0.2,
                          ),

                          PostAFeedActionItem(
                            label: getTranslatedStrings(context).photoVideo,
                            customIcon: SvgPicture.asset('assets/svg/icons/photo_colored.svg', height: 35,),
                            fn: () async {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      // height: 0.22.sh,
                                      color: Colors.white,
                                      child: SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                getTranslatedStrings(context).pickImagesVideos,
                                                style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                              ),
                                              heightBox(15.h),
                                              Row(
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
                                                              getTranslatedStrings(context).images,
                                                              style: mainStyle(context, 13,
                                                                  color: newDarkGreyColor, isBold: true),
                                                            ),
                                                            widthBox(7.w),
                                                            SvgPicture.asset('assets/svg/icons/camera.svg')
                                                          ],
                                                        ),
                                                        onClick: () async {
                                                          logg('picking file');
                                                          final ImagePicker _picker = ImagePicker();
                                                          final List<XFile>? photos = await _picker.pickMultiImage();
                                                          if (photos != null) {
                                                            feedsCubit.updateAttachedFile(null, xFiles: photos);
                                                            Navigator.pop(context);
                                                          }
                                                        }),
                                                  ),
                                                  widthBox(10.w),
                                                  Expanded(
                                                    child: DefaultButton(
                                                      height: 0.07.sh,
                                                      backColor: newLightGreyColor,
                                                      borderColor: Colors.transparent,
                                                      text: getTranslatedStrings(context).video,
                                                      customChild: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            getTranslatedStrings(context).videos,
                                                            style: mainStyle(context, 13,
                                                                color: newDarkGreyColor, isBold: true),
                                                          ),
                                                          widthBox(7.w),
                                                          SvgPicture.asset('assets/svg/icons/video camera.svg')
                                                        ],
                                                      ),
                                                      onClick: () async {
                                                        logg('picking video');
                                                        final ImagePicker _picker = ImagePicker();
                                                        final XFile? photo =
                                                            await _picker.pickVideo(source: ImageSource.gallery);
                                                        if (photo != null) {
                                                          logg('adding video to attachment');
                                                          feedsCubit.updateAttachedFile(photo);
                                                          Navigator.pop(context);
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          // Divider(
                          //   color: Colors.greenAccent,
                          //   thickness: 0.2,
                          // ),
                          // PostAFeedActionItem(
                          //   label: 'Video',
                          //   icon: Icon(
                          //     Icons.video_call,
                          //     color: mainBlueColor,
                          //   ),
                          //   fn: () async {
                          //     logg('picking video');
                          //     final ImagePicker _picker = ImagePicker();
                          //     final XFile? photo = await _picker.pickVideo(source: ImageSource.gallery);
                          //     if (photo != null) {
                          //       logg('adding video to attachment');
                          //       feedsCubit.updateAttachedFile(photo);
                          //     }
                          //   },
                          // ),
                          Divider(
                            color: Colors.black38,
                            thickness: 0.2,
                          ),
                          PostAFeedActionItem(
                            label: getTranslatedStrings(context).camera,
                            customIcon: SvgPicture.asset('assets/svg/icons/camera_colored.svg', height: 35,),
                            fn: () async {
                              logg('picking file');
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      // height: 0.22.sh,
                                      color: Colors.white,
                                      child: SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                getTranslatedStrings(context).takePhotoRecordVideo,
                                                style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                              ),
                                              heightBox(15.h),
                                              Row(
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
                                                              getTranslatedStrings(context).images,
                                                              style: mainStyle(context, 13,
                                                                  color: newDarkGreyColor, isBold: true),
                                                            ),
                                                            widthBox(7.w),
                                                            SvgPicture.asset('assets/svg/icons/camera.svg')
                                                          ],
                                                        ),
                                                        onClick: () async {
                                                          final ImagePicker _picker = ImagePicker();
                                                          final XFile? photo =
                                                              await _picker.pickImage(source: ImageSource.camera);
                                                          if (photo != null) {
                                                            feedsCubit.updateAttachedFile(photo);
                                                            Navigator.pop(context);
                                                          }
                                                        }),
                                                  ),
                                                  widthBox(10.w),
                                                  Expanded(
                                                    child: DefaultButton(
                                                      height: 0.07.sh,
                                                      backColor: newLightGreyColor,
                                                      borderColor: Colors.transparent,
                                                      text: getTranslatedStrings(context).video,
                                                      customChild: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            getTranslatedStrings(context).videos,
                                                            style: mainStyle(context, 13,
                                                                color: newDarkGreyColor, isBold: true),
                                                          ),
                                                          widthBox(7.w),
                                                          SvgPicture.asset('assets/svg/icons/video camera.svg')
                                                        ],
                                                      ),
                                                      onClick: () async {
                                                        final ImagePicker _picker = ImagePicker();
                                                        final XFile? photo =
                                                            await _picker.pickVideo(source: ImageSource.camera,);
                                                        if (photo != null) {
                                                          feedsCubit.updateAttachedFile(photo);
                                                          Navigator.pop(context);
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          Divider(
                            color: Colors.black38,
                            thickness: 0.2,
                          ),
                          PostAFeedActionItem(
                            label: getTranslatedStrings(context).file,
                            customIcon: SvgPicture.asset('assets/svg/icons/file_colored.svg', height: 35,),

                            fn: () async {
                              logg('picking file');
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  // 'jpg',
                                  'pdf',
                                  'doc',
                                  // 'mp4'
                                ],
                              );
                              if (result != null) {
                                File file = File(result.files.single.path!);
                                XFile xFile = new XFile(file.path);
                                feedsCubit.updateAttachedFile(xFile);
                              } else {
                                // User canceled the picker
                                logg('useer canceled the pick');
                              }
                            },
                          ),
                          Divider(
                            color: Colors.black38,
                            thickness: 0.2,
                          ),
                        heightBox(7.h),

                          Row(children: [
                            GestureDetector(
                                      onTap: () {
                                        showMyAlertDialog(context, getTranslatedStrings(context).privacy,
                                            alertDialogContent: BlocConsumer<FeedsCubit, FeedsState>(
                                              listener: (context, state) {
                                                // TODO: implement listener
                                              },
                                              builder: (context, state) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getTranslatedStrings(context).whoCanViewPost,
                                                      style: mainStyle(context, 12,
                                                          color: newDarkGreyColor, weight: FontWeight.w700),
                                                    ),
                                                    heightBox(15.h),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: ['Everyone', 'Providers', 'Only me']
                                                          .map((e) => Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    feedsCubit.updateFeedAudience(e);
                                                                  },
                                                                  child: AlertDialogSelectorItem(
                                                                    label: privacyAudienceTranslatedText(context, e),
                                                                    isSelected: feedsCubit.currentAudience == e,
                                                                    customFontColor: feedsCubit.currentAudience == e
                                                                        ? Colors.white
                                                                        : mainBlueColor,
                                                                    customColor: feedsCubit.currentAudience == e
                                                                        ? mainBlueColor
                                                                        : softBlueColor,
                                                                  ),
                                                                ),
                                                              ))
                                                          .toList(),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ));
                                      },
                                      child: Row(
                                            children: [
                                              Icon(Icons.lock, size: 30,color: disabledGreyColor,),
                                              widthBox(10.w),
                                              Text(
                                                feedsCubit.currentAudience,
                                                style: mainStyle(context, 14,
                                                    color: newDarkGreyColor, weight: FontWeight.w700),
                                              ),
                                              // widthBox(10.w),
                                              // SvgPicture.asset(
                                              //   'assets/svg/icons/arrow_down_base.svg',
                                              //   color: newDarkGreyColor,
                                              // )
                                            ],
                                          ),
                                      ),
                                      Expanded(child: Container()),
                                      Row(
                                        children: [
                                          GestureDetector(
                                               onTap: () {
                                                                      },
                                                                      child: SvgPicture.asset("assets/svg/icons/setting_with_border.svg", width: 30,),
                                                                    ), 
                                                                    widthBox(4.w),
                                                                    Text(
                                                getTranslatedStrings(context).setting,
                                                style: mainStyle(context, 14,
                                                    color: newDarkGreyColor, weight: FontWeight.w700),
                                              ),
                                        ],
                                      )
                          ],)
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}

class PostAFeedActionItem extends StatelessWidget {
  const PostAFeedActionItem({
    Key? key,
    required this.fn,
    this.icon,
    this.label,
    this.customIcon
  }) :  assert(icon == null || customIcon == null, "you can not provide both icon and custom icon"),super(key: key);

  final Function() fn;
  final Icon? icon;
  final Widget? customIcon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              icon ?? customIcon ?? SizedBox(),
              widthBox(10.w),
              label == null
                  ? SizedBox()
                  : Text(
                      label!,
                      style: mainStyle(
                        context,
                        16,
                      weight: FontWeight.w600
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlacePickerLayout extends StatefulWidget {
  const PlacePickerLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<PlacePickerLayout> createState() => _PlacePickerLayoutState();
}

class _PlacePickerLayoutState extends State<PlacePickerLayout> {
  // final Completer<GoogleMapController> _controller = Completer();
  // static const CameraPosition _kGooglePlex =  CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  //
  // static const CameraPosition _kLake =   CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    return PlacePicker(
      apiKey: "AIzaSyC9AEfwxO9TCxGzZgugExbTuW2xWzTqv_o",
      onPlacePicked: (result) {
        // locationCubit.updatePosition(
        //     LatLng(
        //         result.geometry!.location.lat, result.geometry!.location.lng),
        //     result.formattedAddress ?? '--');
        Navigator.of(context).pop();
      },
      enableMyLocationButton: true,
      onMapCreated: (googleMapController) {},
      /* introModalWidgetBuilder: (modalContext, test) {
        return SafeArea(
          child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  color: Colors.red,
                  child: TextButton(
                      onPressed: (){
                        Navigator.pop(modalContext);
                      },
                      child: Text('sakdjsd')))),
        );
      },*/
      // outsideOfPickAreaText: 'This area not available',
      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
        return isSearchBarFocused
            ? Container()
            // Use FloatingCard or just create your own Widget.
            : FloatingCard(
                bottomPosition: 0.0,

                // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                leftPosition: 0.0,
                rightPosition: 0.0,
                // width: 500,
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: state == SearchingState.Searching
                      ? const Center(child: LinearProgressIndicator())
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${selectedPlace?.formattedAddress}',
                              style: mainStyle(context, 16, color: mainBlueColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            DefaultButton(
                              // title: getTranslated(context).save,
                              backColor: mainBlueColor,
                              titleColor: Colors.white,
                              onClick: () {
                                // locationCubit.updatePosition(
                                //     LatLng(
                                //         selectedPlace!.geometry!.location.lat,
                                //         selectedPlace.geometry!.location.lng),
                                //     selectedPlace.formattedAddress ?? '--');

                                feedsCubit.updatePickedFeedLocation(PickedLocationModel(
                                  name: selectedPlace?.name ??
                                      selectedPlace?.formattedAddress ??
                                      selectedPlace?.adrAddress,
                                  latLng: LatLng(
                                      selectedPlace!.geometry!.location.lat, selectedPlace.geometry!.location.lng),
                                ));
                                Navigator.of(context).pop();
                              },
                              text: 'Pick location',
                            )
                          ],
                        ),
                ),
              );
      },
      initialPosition: LatLng(35.5, 35.5),
      useCurrentLocation: true,
    );
  }
}
