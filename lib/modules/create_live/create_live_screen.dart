import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/create_live/cubit/create_live_cubit.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';
import 'package:mena/modules/create_live/widget/live_option_button.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/live_screen.dart';
import 'package:mena/modules/live_screens/start_live_form.dart';
import 'package:mena/modules/start_live/start_live_page.dart';

class CreateLivePage extends StatefulWidget {
  const CreateLivePage({super.key});

  @override
  State<CreateLivePage> createState() => _CreateLivePageState();
}

class _CreateLivePageState extends State<CreateLivePage> {
  bool isCameraReady = false;
  Future<void>? _initializeControllerFuture;
  bool isBack = false;
  late List<CameraDescription> cameras;

  late  CameraController _controller;

  Future<void>? camerasValue;

  TextEditingController titleController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController publishedDateCont = TextEditingController();
  TextEditingController timeCont = TextEditingController();
  TextEditingController pickedThumbCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    startCamera();
    // _initializeCamera();
  }

  void startCamera() async {
    cameras = await availableCameras();
    if (isBack) {
      isBack = false;
    } else {
      isBack = true;
    }
    final firstCamera = isBack ? cameras.last : cameras.first;

    if(cameras != null){

      _controller = CameraController(firstCamera, ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      camerasValue = _controller.initialize().then((value) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      camerasValue == null
          ? camerasValue = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    var liveCubit = LiveCubit.get(context);
    // liveCubit.changeSelectedStartLiveCat(liveCubit.nowLiveCategoriesModel!.liveCategories[0].id.toString());
    liveCubit.updateThumbnailFile(null);
    var createLiveCubit = CreateLiveCubit.get(context)
      ..toggleAutoValidate(false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            camerasValue != null
                ? Container(
                width: size.width,
                height: size.height,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: Container(
                        width: 100, // the actual width is not important here
                        child: CameraPreview(

                          _controller,
                        )
                    )))

                : Center(child: CircularProgressIndicator()),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// create live widget
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.w),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {},
                          // onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                              "assets/new_icons/Livestream_Logo.svg",
                              height: 27)),
                      SizedBox(
                        width: 230.w,
                      ),
                      InkWell(
                        onTap: () async {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Are you sure?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Return false
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // Return true
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            Navigator.of(context).pop(); // Go back to the previous page
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/new_icons/Close_Icon.svg",
                          height: 28,
                        ),
                      ),


                    ],
                  ),
                ),

                /// add title widget
                Container(
                  margin:
                  EdgeInsets.symmetric(horizontal: 40.w,),
                  padding:
                  EdgeInsets.only(left: 6.w, top: 6.h, bottom: 6.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff363434).withOpacity(0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarForLive(
                          radius: 30.sp,
                          isOnline: true,
                          customRingColor: mainBlueColor,
                          onlyView: false,
                          pictureUrl:
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
                      widthBox(10.w),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                          Text(
                            "Add Title",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                            widthBox(5.w),
                            SvgPicture.asset(
                              "assets/new_icons/Write_title.svg",
                              fit: BoxFit.contain,
                              width: 20,
                            )
                            // TextField(
                            //   style: TextStyle(
                            //     fontSize: 18.sp,
                            //     fontFamily: 'PNfont',
                            //     // color: Colors.white,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            //   decoration: InputDecoration(
                            //     border: InputBorder.none, // Remove borders
                            //     enabledBorder: InputBorder.none, // Remove borders
                            //     focusedBorder: InputBorder.none, // Remove borders
                            //     hintText: "Add Title", // Placeholder text
                            //     hintStyle: TextStyle(
                            //       fontSize: 18.sp,
                            //       fontFamily: 'PNfont',
                            //       color: Colors.white.withOpacity(0.5), // Placeholder text color
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox(10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff363434).withOpacity(0.2)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/new_icons/Goal.svg',
                                height: 20,
                              ),
                              widthBox( 15),
                              Text(
                                "Add Topic",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'PNfont',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              widthBox( 10),
                            ],
                          ),
                        ),
                      ),
                      heightBox(10.h),
                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff363434).withOpacity(0.2)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/new_icons/Goal.svg',
                                height: 20,
                              ),
                              widthBox( 15),
                              Text(
                                "Add a LIVE goal",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'PNfont',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              widthBox( 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox(260.h),

                /// option buttons
                Wrap(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            widthBox(60.w),
                            LiveOptionButton(
                                title: "Flip",
                                iconSize: 48,
                                icon: "assets/new_icons/Flip.svg",
                                btnClick: () async {
                                  startCamera();
                                }),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Poll",
                                iconSize: 52,
                                icon: "assets/new_icons/Add_poll.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Product",
                                iconSize: 50,
                                hieght: 9,
                                icon: "assets/new_icons/Add_Producat.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Link",
                                iconSize: 34,
                                hieght: 20,
                                icon: "assets/new_icons/Add_Link.svg",
                                btnClick: () {}),
                          ],
                        ),
                        heightBox(12.h),
                        Row(
                          children: [
                            widthBox(65.w),
                            LiveOptionButton(
                                title: "Share",
                                iconSize: 25,
                                hieght: 15,
                                icon: "assets/new_icons/Share_icon_white.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Setting",
                                iconSize: 35,
                                hieght: 22,
                                icon: "assets/new_icons/Device_Camera.svg",
                                btnClick: () {}),
                            widthBox(15.w),
                            LiveOptionButton(
                                title: "Live Center",
                                iconSize: 25,
                                hieght: 15,
                                icon: "assets/new_icons/home-wifi-svgrepo-com.svg",
                                btnClick: () {}),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                heightBox(15.h),
                DefaultButton(
                    borderColor: Color(0xFFF22E52),
                    backColor: Color(0xFFF22E52),
                    width: 250.w,
                    height: 50.h,
                    radius: 30,
                    text: "Go Live",
                    onClick: () {
                      createLiveCubit.createLive();
                    }),
                heightBox(15.h),
                Wrap(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          widthBox(60.w),
                          LiveOptionButtonExtra(
                              title: "Voice hub",
                              iconSize: 20,
                              // width: 15,
                              icon: "assets/new_icons/voice-square-svgrepo-com.svg",
                              btnClick: () {}),
                          widthBox(40.w),
                          LiveOptionButtonExtra(
                              title: "Device camera",
                              iconSize: 20,
                              // width: 15,
                              icon: "assets/new_icons/Device_Camera.svg",
                              btnClick: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 50),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       LiveOptionButtonExtra(
                //           title: "Voice hub",
                //           iconSize: 25,
                //           // width: 15,
                //           icon: "assets/new_icons/voice-square-svgrepo-com.svg",
                //           btnClick: () {}),
                //       LiveOptionButtonExtra(
                //           title: "Device camera",
                //           iconSize: 25,
                //           // width: 15,
                //           icon: "assets/new_icons/Device_Camera.svg",
                //           btnClick: () {}),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
        // appBar: defaultAppBarForLive(
        //   context,
        // ),
        // body: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
        //   child: Form(
        //       key: createLiveCubit.formKey,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           SingleChildScrollView(
        //             child: Column(children: [
        //               heightBox(20.h),
        //               AvatarForLive(
        //                   radius: 40.sp,
        //                   isOnline: true,
        //                   customRingColor: mainBlueColor,
        //                   pictureUrl:
        //                       "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
        //               heightBox(20.h),
        //               LiveInputField(
        //                 label: 'Title',
        //                 controller: createLiveCubit.title,
        //                 validate: normalInputValidate(context,
        //                     customText: 'It cannot be empty'),
        //               ),
        //               heightBox(20.h),
        //               LiveInputField(
        //                 label: 'Target',
        //                 controller: createLiveCubit.target,
        //                 validate: normalInputValidate(context,
        //                     customText: 'It cannot be empty'),
        //               ),
        //               heightBox(20.h),
        //               LiveInputField(
        //                 label: 'Goal',
        //                 controller: createLiveCubit.goal,
        //                 validate: normalInputValidate(context,
        //                     customText: 'It cannot be empty'),
        //               ),
        //               heightBox(40.h),
        //               BlocConsumer<CreateLiveCubit, CreateLiveState>(
        //                   listener: (context, state) {},
        //                   builder: (context, state) {
        //                     return MoreOptionRow(
        //                       title: "Record live streams",
        //                       onChanged: (value) =>
        //                           createLiveCubit.onPressRecordlive(value),
        //                       value: createLiveCubit.valueRecordlive,
        //                     );
        //                   }),
        //               heightBox(20.h),
        //               BlocConsumer<CreateLiveCubit, CreateLiveState>(
        //                   listener: (context, state) {},
        //                   builder: (context, state) {
        //                     return MoreOptionRow(
        //                       title: "Share My live on my feed page",
        //                       onChanged: (value) => createLiveCubit
        //                           .onPressShareMyLive(context, value),
        //                       value: createLiveCubit.valueShareMyLive,
        //                     );
        //                   }),
        //             ]),
        //           ),
        //           const Spacer(),
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                     elevation: 0, backgroundColor: Colors.white),
        //                 onPressed: () => navigateTo(
        //                     context, const AddPeopleToLiveScreenPage()),
        //                 child: SvgPicture.asset(
        //                   'assets/svg/user_add.svg',
        //                   height: Responsive.isMobile(context) ? 28.w : 12.w,
        //                 ),
        //               ),
        //               DefaultButton(
        //                 width: 150.w,
        //                 text: "Star Streaming",
        //                 onClick: () {
        //                   // createLiveCubit.onPressStarStreaming(context);
        //                   createLiveCubit.createLive();
        //                 },
        //               ),
        //               ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                     elevation: 0, backgroundColor: Colors.white),
        //                 onPressed: () {
        //                   createLiveCubit.onPressLinked(context);
        //                 },
        //                 child: SvgPicture.asset(
        //                   'assets/svg/linked_outline.svg',
        //                   height: Responsive.isMobile(context) ? 28.w : 12.w,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           heightBox(20.h),
        //         ],
        //       )),
        // ),
      ),
    );
  }
}

