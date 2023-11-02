import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';
import 'package:mena/modules/create_live/widget/live_option_button.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'cubit/create_live_cubit.dart';

class CreateLivePage extends StatefulWidget {
  const CreateLivePage({super.key});

  @override
  State<CreateLivePage> createState() => _CreateLivePageState();
}

class _CreateLivePageState extends State<CreateLivePage> {
  CameraController? _controller;
  bool isCameraReady = false;
  Future<void>? _initializeControllerFuture;
  bool isBack = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (isBack) {
      isBack = false;
    } else {
      isBack = true;
    }

    setState(() {
      isCameraReady = false;
    });
    final cameras = await availableCameras();
    final firstCamera = isBack ? cameras.first : cameras.last;
    setState(() {
      _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
      _initializeControllerFuture = _controller!.initialize();
    });
    if (!mounted) {
      return;
    }
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isCameraReady = true;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller!.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    var createLiveCubit = CreateLiveCubit.get(context)
      ..toggleAutoValidate(false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            isCameraReady
                ? Center(
                    child: Transform.scale(
                      // scale: _controller!.value.aspectRatio / deviceRatio,
                      scale: _controller!.value.aspectRatio! / (16 / 9)* deviceRatio,
                      child: new AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: new CameraPreview(
                          _controller!,
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
            Column(
              children: [
                /// create live widget
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {},
                          // onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                              "assets/new_icons/Livestream_Logo.svg",
                              height: 30)),
                      SizedBox(
                        width: 230.w,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Are you sure?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                      Navigator.of(context).pop(); // Go back to the previous page
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/new_icons/Close_Icon.svg",
                          height: 28,
                        ),
                      ),

                      // Text(
                      //   "Create Live",
                      //   style: TextStyle(
                      //       fontSize: 18.sp,
                      //       fontFamily: 'PNfont',
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold),
                      // )
                    ],
                  ),
                ),

                /// add title widget
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFdbdbdb).withOpacity(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarForLive(
                          radius: 30.sp,
                          isOnline: true,
                          customRingColor: mainBlueColor,
                          pictureUrl:
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
                      widthBox(10.w),
                      Expanded(
                        child: Row(
                          children: [
                            TextField(
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none, // Remove borders
                                enabledBorder: InputBorder.none, // Remove borders
                                focusedBorder: InputBorder.none, // Remove borders
                                hintText: "Add Title", // Placeholder text
                                hintStyle: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'PNfont',
                                  color: Colors.white.withOpacity(0.5), // Placeholder text color
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){},
                              iconSize: 40,
                              icon: SvgPicture.asset(
                              "assets/new_icons/Write_title.svg",
                              fit: BoxFit.contain,
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

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
                              horizontal: 5.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
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
                              widthBox( 15),
                            ],
                          ),
                        ),
                      ),

                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
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
                heightBox(250.h),

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
                                  _initializeCamera();
                                }),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Poll",
                                iconSize: 48,
                                icon: "assets/new_icons/Add_poll.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Product",
                                iconSize: 41,
                                icon: "assets/new_icons/Add_Producat.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Link",
                                iconSize: 34,
                                icon: "assets/new_icons/Add_Link.svg",
                                btnClick: () {}),
                          ],
                        ),
                        heightBox(25.h),
                        Row(
                          children: [
                            widthBox(65.w),
                            LiveOptionButton(
                                title: "Share",
                                iconSize: 25,
                                icon: "assets/new_icons/Share_icon_white.svg",
                                btnClick: () {}),
                            widthBox(25.w),
                            LiveOptionButton(
                                title: "Setting",
                                iconSize: 30,
                                icon: "assets/new_icons/Device_Camera.svg",
                                btnClick: () {}),
                            widthBox(15.w),
                            LiveOptionButton(
                                title: "Live Center",
                                iconSize: 25,
                                icon: "assets/new_icons/home-wifi-svgrepo-com.svg",
                                btnClick: () {}),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                heightBox(10.h),
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
                heightBox(10.h),
                Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){},
                        iconSize: 40,
            icon: SvgPicture.asset("assets/new_icons/voice-square-svgrepo-com.svg"),
                      ),
                      widthBox(3.w),
                      Text(
                        "Voice hub",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'PNfont',
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      widthBox(10.w),
                      IconButton(
                        onPressed: (){},
                        iconSize: 30,
                        icon: SvgPicture.asset("assets/new_icons/Device_Camera.svg"),
                      ),
                      widthBox(3.w),
                      Text(
                        "Device camera",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'PNfont',
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // Wrap(
                //   children: [
                //     Expanded(
                //       child: LiveOptionButtonExtra(
                //         title: "Voice hub",
                //         iconSize: 30,
                //         icon: "assets/new_icons/voice-square-svgrepo-com.svg",
                //         btnClick: () async {
                //           _initializeCamera();
                //         },
                //       ),
                //     ),
                //     SizedBox(width: 50.w), // You can also use an expanded SizedBox
                //     Expanded(
                //       child: LiveOptionButtonExtra(
                //         title: "Device camera",
                //         iconSize: 30,
                //         icon: "assets/new_icons/Device_Camera.svg",
                //         btnClick: () {},
                //       ),
                //     ),
                //   ],
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
