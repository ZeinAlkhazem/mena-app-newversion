import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/create_live/cubit/create_live_cubit.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';
import 'package:mena/modules/create_live/widget/live_option_button.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/live_screen.dart';
import 'package:mena/modules/live_screens/start_live_form.dart';
import 'package:mena/modules/start_live/start_live_page.dart';
import 'package:mena/modules/start_live/test.dart';

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
  int count = 4;
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

  void startCountdown() {
    // Create a periodic timer that fires every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          // When count reaches zero, navigate to the next page
          MainCubit.get(context).socketInitial();
          navigateToWithoutNavBar(context, StartLivePage(), '',
              onBackToScreen: () {
            logg('sdjkfhkjdsfn');
          });
          timer.cancel(); // Cancel the timer
        }
      });
    });
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
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
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
                            width:
                                100, // the actual width is not important here
                            child: CameraPreview(
                              _controller,
                            ))))
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      Navigator.of(context)
                                          .pop(false); // Return false
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // Return true
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            Navigator.of(context)
                                .pop(); // Go back to the previous page
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/new_icons/zain/cross_large_outline_28.svg",
                          height: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                /// add title widget
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 40.w,
                  ),
                  padding: EdgeInsets.only(left: 6.w, top: 6.h, bottom: 6.h),
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
                          pictureUrl: user.personalPicture),
                      widthBox(10.w),
                      Expanded(
                        // padding: const EdgeInsets.all(8.0),
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
                        onTap: () {
                          liveCubit.onPressChooseLiveTopic(context);
                        },
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
                              widthBox(15),
                              BlocConsumer<LiveCubit, LiveState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    return Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 60.w),
                                      child: new Text(
                                        liveCubit.selectedTopic,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'PNfont',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }),
                              widthBox(10),
                            ],
                          ),
                        ),
                      ),
                      widthBox(10.h),

                      /// Add topic
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff363434).withOpacity(0.2)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/new_icons/Goal.svg',
                                height: 20,
                              ),
                              widthBox(10),
                              Container(
                                  width: 100.w,
                                  height: 28.h,
                                  child: Padding(
                                    child: TextField(
                                      controller: goalController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Add a goal",
                                        fillColor: Colors.white,
                                        hintStyle: TextStyle(
                                            fontSize: 13.sp,
                                            fontFamily: 'PNfont',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: 'PNfont',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    padding: EdgeInsets.only(top: 0.h),
                                  )),
                              widthBox(10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                heightBox(280.h),

                /// option buttons
                Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50.w, right: 50.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LiveOptionButton(
                                  title: "Flip",
                                  iconSize: 35,
                                  icon: "assets/new_icons/zain/camera.svg",
                                  btnClick: () async {
                                    startCamera();
                                  }),
                              heightBox(10.h),
                              LiveOptionButton(
                                  title: "Setting",
                                  iconSize: 35,
                                  icon: "assets/new_icons/zain/settings_24.svg",
                                  btnClick: () {}),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LiveOptionButton(
                                  title: "Poll",
                                  iconSize: 35,
                                  icon:
                                      "assets/new_icons/zain/poll_outline_20.svg",
                                  btnClick: () {}),
                              heightBox(10.h),
                              LiveOptionButton(
                                  title: "Live Center",
                                  iconSize: 35,
                                  icon:
                                      "assets/new_icons/zain/home_outline_20.svg",
                                  btnClick: () {}),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LiveOptionButton(
                                  title: "Product",
                                  iconSize: 35,
                                  icon: "assets/new_icons/z6.svg",
                                  btnClick: () {}),
                            ],
                          ),
                          widthBox(5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LiveOptionButton(
                                  title: "Link",
                                  iconSize: 35,
                                  icon: "assets/new_icons/zain/linked_24.svg",
                                  btnClick: () {}),
                            ],
                          ),
                          widthBox(5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LiveOptionButton(
                                  title: "Share",
                                  iconSize: 35,
                                  icon: "assets/new_icons/z2.svg",
                                  btnClick: () {}),
                            ],
                          ),
                        ],
                      ),
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
                    onClick: () async {
                      await liveCubit
                          .goLiveAndGetLiveFromServer(
                        title: titleController.text,
                        goal: goalController.text,
                        topic: liveCubit.selectedTopicId,
                        liveNowCategoryId: liveCubit.selectedStartLiveCat ?? '',
                      )
                          .then((value) async {
                        if (liveCubit.goLiveModel != null) {
                          // Navigator.of(context, rootNavigator: true).pop();
                          logg(
                              'room id: ${liveCubit.goLiveModel!.data.roomId.toString()}');
                          startCountdown();
                        }
                      });
                      logg('now test response and navigate');
                    }),
                heightBox(15.h),
                Wrap(
                  children: [
                    Row(
                      children: [
                        widthBox(60.w),
                        LiveOptionButtonExtra(
                            title: "Voice hub",
                            iconSize: 20,
                            // width: 15,
                            icon:
                                "assets/new_icons/voice-square-svgrepo-com.svg",
                            btnClick: () {}),
                        widthBox(20.w),
                        LiveOptionButtonExtra(
                            title: "Device camera",
                            iconSize: 20,
                            // width: 15,
                            icon: "assets/new_icons/Device_Camera.svg",
                            btnClick: () {}),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(.7),
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.w,
                        ),
                      ),
                    )),
              ),
              visible: count != 4 && count != 0,
            ),
          ],
        ),
      ),
    );
  }
}
