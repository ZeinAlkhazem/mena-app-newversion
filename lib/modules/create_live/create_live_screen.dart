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
  late CameraController _controller;
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
    if (cameras != null) {
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
                          onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                              "assets/live_create/Whiteboards.svg",
                              height: 30)),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Create Live",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'PNfont',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                /// add title widget
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFdbdbdb).withOpacity(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AvatarForLive(
                          radius: 30.sp,
                          isOnline: true,
                          customRingColor: mainBlueColor,
                          pictureUrl:
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
                      widthBox(10.w),
                      new Flexible(
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add Title",
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'PNfont',
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
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
                      ///  new Flexible(
                      new Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 0.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: topicController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add Topic",
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: 'PNfont',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      widthBox(10.w),
                      new Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 0.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFdbdbdb).withOpacity(0.5)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: goalController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add Goal",
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: 'PNfont',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'PNfont',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      /// Add topic
                      // InkWell(
                      //   onTap: () {},
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 30.w, vertical: 10.h),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Color(0xFFdbdbdb).withOpacity(0.5)),
                      //     child: Text(
                      //       "Add a LIVE goal",
                      //       style: TextStyle(
                      //           fontSize: 16.sp,
                      //           fontFamily: 'PNfont',
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //   ),
                      // ),
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
                    onClick: () async {
                      await liveCubit
                          .goLiveAndGetLiveFromServer(
                        title: titleController.text,
                        goal: goalController.text,
                        topic: topicController.text,
                        liveNowCategoryId: liveCubit.selectedStartLiveCat ?? '',
                      )
                          .then((value) async {
                        if (liveCubit.goLiveModel != null) {
                          Navigator.of(context, rootNavigator: true).pop();
                          logg(
                              'room id: ${liveCubit.goLiveModel!.data.roomId.toString()}');

                              MainCubit.get(context).socketInitial();
                          await navigateToWithoutNavBar(
                              context,
                              StartLivePage(),
                              '', onBackToScreen: () {
                            logg('sdjkfhkjdsfn');
                            // setState(() {
                            //   ScreenUtil.init(context,
                            //       designSize: const Size(360, 770),
                            //       splitScreenMode: true
                            //     // width: 750, height: 1334, allowFontScaling: false
                            //   );
                            // });
                          });
                        }
                      });
                      logg('now test response and navigate');
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
