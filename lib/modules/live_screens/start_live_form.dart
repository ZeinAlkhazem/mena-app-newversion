import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'live_screen.dart';

class StartLiveFormLayout extends StatefulWidget {
  const StartLiveFormLayout({Key? key}) : super(key: key);

  @override
  State<StartLiveFormLayout> createState() => _StartLiveFormLayoutState();
}

class _StartLiveFormLayoutState extends State<StartLiveFormLayout> {
  var formKey = GlobalKey<FormState>();

  // late OverlayEntry _overlayEntry;
  // final GlobalKey dropdownKey = GlobalKey();
  // final dropdownKey = GlobalKey<DropdownButton2State>();

  TextEditingController titleController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController publishedDateCont = TextEditingController();
  TextEditingController timeCont = TextEditingController();
  TextEditingController pickedThumbCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    // liveCubit.changeSelectedStartLiveCat(liveCubit.nowLiveCategoriesModel!.liveCategories[0].id.toString());
    liveCubit.updateThumbnailFile(null);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Start Live',
          customTitleWidget: Row(
            children: [
              SvgPicture.asset('assets/svg/icons/menalive.svg'),
            ],
          ),
        ),
      ),
      body: BlocConsumer<LiveCubit, LiveState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          DateTime? pickedDate;
          Future _selectDate() async {
            pickedDate = await showDatePicker(
                context: context,
                initialDate: new DateTime.now(),
                firstDate: new DateTime(2020),
                lastDate: new DateTime(2030));
            if (pickedDate != null) publishedDateCont.text = pickedDate.toString();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heightBox(30.h),
                    ProfileBubble(
                      isOnline: true,
                      radius: 44.sp,
                      customRingColor: mainBlueColor,
                      pictureUrl: MainCubit.get(context).userInfoModel!.data.user.personalPicture,
                    ),
                    heightBox(33.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ///
                            ///
                            liveCubit.nowLiveCategoriesModel == null
                                ? SizedBox()
                                : liveCubit.nowLiveCategoriesModel!.liveCategories.isEmpty
                                    ? SizedBox()
                                    : DropdownButtonFormField2<String>(
                                        decoration: InputDecoration(
                                          errorMaxLines: 3,
                                          isDense: true,
                                          filled: true,
                                          hintText: '-',
                                          // floatingLabelBehavior: floatingLabelBehavior,
                                          hintStyle:
                                              mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: Responsive.isMobile(context) ? 10 : 15.0, horizontal: 0.0),
                                          border: const OutlineInputBorder(),
                                          // suffixIcon: Padding(
                                          //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                                          //   child: suffixIcon,
                                          // ),
                                          suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
                                          labelStyle:
                                              mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                          // labelText: label,
                                          // label: Text( 'sakldkl'),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(horizontal: withoutLabelPadding ? 0.0 : 2.0),
                                          //   child: labelWidget,
                                          // ),
                                          fillColor: newLightGreyColor,
                                          focusColor: newLightGreyColor,
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red, width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red.withOpacity(0.6), width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: mainBlueColor, width: 1.0),
                                              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: mainBlueColor.withOpacity(0.7), width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: mainBlueColor.withOpacity(0.7), width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),
                                        ),
                                        isExpanded: true,
                                        hint: Text('Select livestream Category',
                                            style: mainStyle(context, 13,
                                                color: newDarkGreyColor, weight: FontWeight.w700)),
                                        items: liveCubit.nowLiveCategoriesModel!.liveCategories
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item.id.toString(),
                                                  child: Text(item.name,
                                                      style: mainStyle(context, 13,
                                                          color: newDarkGreyColor, weight: FontWeight.w700)),
                                                ))
                                            .toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select livestream Category';
                                          }
                                          return null;
                                        },
                                        value: liveCubit.selectedStartLiveCat,
                                        onChanged: (value) {
                                          //Do something when changing the item if you want.
                                          liveCubit.changeSelectedStartLiveCat(value.toString());
                                        },
                                        onSaved: (value) {
                                          // selectedValue = value.toString();
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          // height: 60,
                                          padding: EdgeInsets.only(left: 0, right: 10),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.black45,
                                          ),
                                          iconSize: 30,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(defaultRadiusVal),
                                          ),
                                        ),
                                      ),

                            ///
                            heightBox(10.h),
                            DefaultInputField(
                              label: 'Title',
                              validate: normalInputValidate,
                              controller: titleController,
                            ),
                            heightBox(10.h),
                            DefaultInputField(
                              label: 'Target',
                              validate: normalInputValidate,
                              controller: goalController,
                            ),
                            // heightBox(10.h),
                            // DefaultInputField(
                            //   label: 'Topic',
                            //   validate: normalInputValidate(context),
                            //   controller: topicController,
                            // ),
                            heightBox(10.h),
                            DefaultInputField(
                              validate: normalInputValidate,
                              label: 'Select date',
                              // labelWidget: Text(
                              //   'Date of birth',
                              //   style: mainStyle(context, 13, color: mainBlueColor),
                              // ),
                              controller: publishedDateCont,
                              readOnly: true,
                              onTap: () {
                                _selectDate();
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              suffixIcon: SvgPicture.asset(
                                'assets/svg/icons/calendar.svg',
                                height: 22.h,
                                width: 22.h,
                              ),
                            ),
                            heightBox(10.h),
                            DefaultInputField(
                              validate: normalInputValidate,
                              label: 'Select time',
                              // labelWidget: Text(
                              //   'Date of birth',
                              //   style: mainStyle(context, 13, color: mainBlueColor),
                              // ),
                              controller: timeCont,
                              readOnly: true,
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      var now = DateTime.now();
                                      return SpinnerDateTimePicker(
                                        initialDateTime: now,
                                        maximumDate: now.add(Duration(days: 7)),
                                        minimumDate: now.subtract(Duration(days: 1)),
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        didSetTime: (value) {
                                          logg("did set time: $value");
                                          logg("picked time: ${getFormattedDateOnlyTime(value)}");
                                          liveCubit.updateTempFromTime(value);
                                          timeCont.text = liveCubit.pickedLiveTime.toString();
                                        },
                                      );
                                    });
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              suffixIcon: SvgPicture.asset(
                                'assets/svg/icons/alarm clock time.svg',
                                height: 22.h,
                                width: 22.h,
                              ),
                            ),
                            heightBox(10.h),
                            DefaultInputField(
                              validate: normalInputValidate,
                              label: 'Upload live cover',
                              // labelWidget: Text(
                              //   'Date of birth',
                              //   style: mainStyle(context, 13, color: mainBlueColor),
                              // ),
                              controller: pickedThumbCont,
                              readOnly: true,
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                // Pick an image
                                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                liveCubit.updateThumbnailFile(image);
                                pickedThumbCont.text =
                                    liveCubit.thumbnailFile!.path.substring(liveCubit.thumbnailFile!.path.length - 10);
                              },
                              suffixIcon: SvgPicture.asset(
                                'assets/svg/icons/picture_plus_outline_28.svg',
                                height: 22.h,
                                width: 22.h,
                                color: mainBlueColor,
                              ),
                            ),
                            heightBox(10.h),
                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border.all(width: 1.0, color: mainBlueColor.withOpacity(0.3)),
                            //       borderRadius: BorderRadius.all(Radius.circular(5.0.sp))),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text(
                            //           liveCubit.thumbnailFile == null
                            //               ? 'Live Thumbnail'
                            //               : liveCubit.thumbnailFile!.path
                            //                   .substring(liveCubit.thumbnailFile!.path.length - 10),
                            //           style: mainStyle(context, 12, color: softGreyColor),
                            //         ),
                            //         TextButton(
                            //             onPressed: () async {
                            //               final ImagePicker _picker = ImagePicker();
                            //               // Pick an image
                            //               final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            //               liveCubit.updateThumbnailFile(image);
                            //             },
                            //             child: Text('Browse'))
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    heightBox(10.h),
                    ///
                    ///
                    state is GettingGoLiveAndGetLiveFromServer
                        ? LinearProgressIndicator()
                        : DefaultButton(
                            text: 'Create',
                            onClick: () async {
                              if (formKey.currentState!.validate()) {
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
                                    logg('room id: ${liveCubit.goLiveModel!.data.roomId.toString()}');
                                    await navigateToWithoutNavBar(
                                        context,
                                        LivePage(
                                          liveID: liveCubit.goLiveModel!.data.roomId.toString(),
                                          isHost: true,
                                          liveTitle: liveCubit.goLiveModel!.data.title,
                                          liveGoal: liveCubit.goLiveModel!.data.goal,
                                          liveTopic: liveCubit.goLiveModel!.data.topic,
                                          /// audience false
                                          /// true for host
                                          /// this will change the layout view behaviour
                                        ),
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
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
