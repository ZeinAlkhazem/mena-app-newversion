import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_live/cubit/create_live_cubit.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';
import 'package:mena/modules/create_live/widget/live_option_button.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    startCamera();
    // _initializeCamera();
  }
  void startCamera() async{
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
    }else{
      print("NO any camera found");
    }

  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  // Future<void> _initializeCamera() async {
  //   if (isBack) {
  //     isBack = false;
  //   } else {
  //     isBack = true;
  //   }

  //   setState(() {
  //     isCameraReady = false;
  //   });



  //   // final firstCamera = isBack ? cameras.first : cameras.last;
  //   // logg('firstCamera ${firstCamera}');
  //   // setState(() {
  //   //   _controller = CameraController(firstCamera, RelutionPreset.ultraHigh);
  //   //   _initializeControllerFuture = _controller!.initialize();
  //   // });



  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      camerasValue == null
          ? camerasValue = _controller!.initialize()
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
            camerasValue != null
                ? CameraPreview(
              _controller,
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
                      color: Color(0xff504e4e).withOpacity(0.2)),
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
                            // IconButton(
                            //   onPressed: (){},
                            //   iconSize: 40,
                            //   icon: SvgPicture.asset(
                            //     "assets/new_icons/Write_title.svg",
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                          ],
                        ),
                      ),


                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
                          child: Text(
                            "Add Topic",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
                          child: Text(
                            "Add a LIVE goal",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox(200.h),

                /// option buttons
                Wrap(
                  children: [
                    LiveOptionButton(
                        title: "Flip",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () async {
                          startCamera();
                        }),
                    LiveOptionButton(
                        title: "Setting",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                    LiveOptionButton(
                        title: "Share",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                    LiveOptionButton(
                        title: "Poll",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                    LiveOptionButton(
                        title: "Product",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                    LiveOptionButton(
                        title: "Live Center",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                    LiveOptionButton(
                        title: "Link",
                        icon: "assets/live_create/Whiteboards.svg",
                        btnClick: () {}),
                  ],
                ),
                heightBox(10.h),
                DefaultButton(
                    backColor: Color(0xFFF22E52),
                    width: 250.w,
                    height: 50.h,
                    radius: 15,
                    text: "Go Live",
                    onClick: () {
                      createLiveCubit.createLive();
                    }),
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