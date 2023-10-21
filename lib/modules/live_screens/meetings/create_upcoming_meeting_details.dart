import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mena/core/constants/validators.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/meetings_config.dart';
import '../../../models/api_model/my_meetings.dart';
import '../../../models/local_models.dart';
import '../live_cubit/live_cubit.dart';

class CreateUpcomingMeetingSelectDetails extends StatefulWidget {
  const CreateUpcomingMeetingSelectDetails({Key? key, this.customMeetingToEdit}) : super(key: key);

  final Meeting? customMeetingToEdit;

  @override
  State<CreateUpcomingMeetingSelectDetails> createState() => _CreateUpcomingMeetingSelectDetailsState();
}

class _CreateUpcomingMeetingSelectDetailsState extends State<CreateUpcomingMeetingSelectDetails> {
  TextEditingController meetingTitleCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();
  TextEditingController fromCont = TextEditingController();
  TextEditingController toCont = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    var liveCubit = LiveCubit.get(context);

    if (widget.customMeetingToEdit != null) {
      logg('edit meeting details ${widget.customMeetingToEdit}');
      //title
      meetingTitleCont.text = widget.customMeetingToEdit!.title ?? '';
      //date
      liveCubit.updateMeetingPickerDate(widget.customMeetingToEdit!.date!);
      //from
      liveCubit.updateMeetingFromTime(widget.customMeetingToEdit!.from!);
      //to
      liveCubit.updateMeetingToTime(widget.customMeetingToEdit!.to!);
      //time zone
      liveCubit.updateMeetingTimeZone(widget.customMeetingToEdit!.timeZone!);
      //repeat
      liveCubit.updateMeetingRepeat(widget.customMeetingToEdit!.repeat!);
      //require meeting code
      liveCubit.updateRequireMeetingPassCode(widget.customMeetingToEdit!.requirePasscode == '1' ? true : false);
      //get passcode val
      liveCubit.updatePassCode(widget.customMeetingToEdit!.passcode ?? '');
      //enable waiting room
      liveCubit.updateEnableWaitingRoom(widget.customMeetingToEdit!.waitingRoom == '1' ? true : false);

      //allow participant to join
      liveCubit.updateAllowParticipantToJoin(widget.customMeetingToEdit!.partipantBeforeHost == '1' ? true : false);
      //automatically record meeting
      liveCubit.updateAutoREcordMeeting(widget.customMeetingToEdit!.autoRecord == '1' ? true : false);

      //add to calendar
      liveCubit.updateAddToCalendar(widget.customMeetingToEdit!.toCalendar == '1' ? true : false);
      //share permission
      liveCubit.updateSharePermission(widget.customMeetingToEdit!.sharePermission == '1' ? true : false);
      //share permission
      liveCubit.updatePublishTheLiveToMenaLivePage(widget.customMeetingToEdit!.publishToLive == '1' ? true : false);
    } else {
      logg('edit meeting details ${widget.customMeetingToEdit}');
      //title
      meetingTitleCont.text = '';
      //date
      liveCubit.updateMeetingPickerDate(null);
      //from
      liveCubit.updateMeetingFromTime(null);
      //to
      liveCubit.updateMeetingToTime(null);
      //time zone
      liveCubit.updateMeetingTimeZone(null);
      //repeat
      liveCubit.updateMeetingRepeat(null);
      //require meeting code
      liveCubit.updateRequireMeetingPassCode(false);
      //get passcode val
      // liveCubit.updatePassCode(widget.customMeetingToEdit!.passcode ?? '');
      //enable waiting room
      liveCubit.updateEnableWaitingRoom(false);

      //allow participant to join
      liveCubit.updateAllowParticipantToJoin(false);
      //automatically record meeting
      liveCubit.updateAutoREcordMeeting(false);

      //add to calendar
      liveCubit.updateAddToCalendar(false);
      //share permission
      liveCubit.updateSharePermission(false);
      //share permission
      liveCubit.updatePublishTheLiveToMenaLivePage(false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: widget.customMeetingToEdit != null ? 'Edit upcoming meeting' : 'Create upcoming meeting',
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<LiveCubit, LiveState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Text(
                  //   'Meeting details',
                  //   style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                  // ),
                  Divider(),
                  heightBox(15.h),
                  if (liveCubit.meetingsConfigModel != null)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DefaultInputField(
                            controller: meetingTitleCont,
                            borderRadius: 0,
                            fillColor: Colors.white,
                            validate: normalInputValidate(context),
                            focusedBorderColor: newDarkGreyColor,
                            unFocusedBorderColor: newDarkGreyColor,
                            label: 'Meeting title',
                          ),
                          heightBox(10.h),
                          heightBox(10.h),
                          MeetingDetailsSectionTitle(
                            title: 'Date and Time Details',
                          ),
                          heightBox(10.h),
                          MeetingPickerRow(
                            title: 'Date',
                            controller: dateCont,
                            validator: normalInputValidate(context, customText: 'Please pick a date'),
                            val: liveCubit.pickedMeetingDate == null
                                ? 'Pick a date'
                                : getFormattedDateOnlyDate(liveCubit.pickedMeetingDate!),
                            onClick: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: new DateTime.now(),
                                  firstDate: new DateTime(2020),
                                  lastDate: new DateTime(2030));
                              if (pickedDate != null) {
                                liveCubit.updateMeetingPickerDate(pickedDate);
                                dateCont.text = ' ';
                              }
                              ;
                            },
                          ),
                          MeetingPickerRow(
                            title: 'From',
                            controller: fromCont,
                            validator: normalInputValidate(context, customText: 'Please pick a time'),
                            val: liveCubit.pickedMeetingFromTime == null
                                ? 'Pick a time'
                                : getFormattedDateOnlyTime(liveCubit.pickedMeetingFromTime!),
                            onClick: () async {
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
                                        liveCubit.updateMeetingFromTime(value);
                                        fromCont.text = ' ';
                                      },
                                    );
                                  });

                              ///
                            },
                          ),
                          MeetingPickerRow(
                            title: 'To',
                            controller: toCont,
                            validator: normalInputValidate(context, customText: 'Please pick a time'),
                            val: liveCubit.pickedMeetingToTime == null
                                ? 'Pick a time'
                                : getFormattedDateOnlyTime(liveCubit.pickedMeetingToTime!),
                            onClick: () async {
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
                                        liveCubit.updateMeetingToTime(value);
                                        toCont.text = ' ';
                                      },
                                    );
                                  });

                              ///
                            },
                          ),

                          DropdownButtonFormField2<Repeat>(
                            decoration: InputDecoration(
                              errorMaxLines: 3,
                              isDense: true,

                              filled: true,
                              hintText: '-',
                              // floatingLabelBehavior: floatingLabelBehavior,
                              hintStyle: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: Responsive.isMobile(context) ? 10 : 15.0, horizontal: 0.0),
                              border: const OutlineInputBorder(),
                              // suffixIcon: Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                              //   child: suffixIcon,
                              // ),
                              suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
                              errorStyle: mainStyle(context, 11, color: Colors.red, weight: FontWeight.w700),
                              labelStyle: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                              // labelText: label,
                              // label: Text( 'sakldkl'),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: withoutLabelPadding ? 0.0 : 2.0),
                              //   child: labelWidget,
                              // ),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),
                            ),
                            isExpanded: true,
                            // style: mainStyle(context, 12,color: Colors.green),
                            hint: Text('Time zone',
                                style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700)),
                            items: liveCubit.meetingsConfigModel!.data.timeZones
                                .map((item) => DropdownMenuItem<Repeat>(
                                      value: item,
                                      child: Text(item.id,
                                          style:
                                              mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700)),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return '   Please select time zone';
                              }
                              return null;
                            },
                            value: liveCubit.emptyTimeZoneForViewOnLeft,

                            onChanged: (value) {
                              //Do something when changing the item if you want.
                              liveCubit.updateMeetingTimeZone(value!.id);
                            },
                            onSaved: (value) {
                              // selectedValue = value.toString();
                            },
                            buttonStyleData: ButtonStyleData(
                              // height: 60,
                              padding: EdgeInsets.only(left: 0, right: defaultHorizontalPadding),
                            ),

                            iconStyleData: IconStyleData(
                              icon: Row(
                                children: [
                                  Text(
                                    liveCubit.pickedMeetingTimezone ?? 'Select time zone',
                                    style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                  ),
                                  widthBox(7.w),
                                  Icon(Icons.arrow_forward_ios, size: 20),
                                ],
                              ),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(defaultRadiusVal),
                                ),
                                maxHeight: 0.5.sh),
                          ),
                          Divider(
                            height: 10.h,
                            thickness: 1,
                          ),
                          DropdownButtonFormField2<Repeat>(
                            decoration: InputDecoration(
                              errorMaxLines: 3,

                              isDense: true,
                              filled: true,
                              hintText: '-',
                              // floatingLabelBehavior: floatingLabelBehavior,
                              hintStyle: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: Responsive.isMobile(context) ? 10 : 15.0, horizontal: 0.0),
                              border: const OutlineInputBorder(),
                              // suffixIcon: Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                              //   child: suffixIcon,
                              // ),
                              suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
                              errorStyle: mainStyle(context, 11, color: Colors.red, weight: FontWeight.w700),
                              labelStyle: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                              // labelText: label,
                              // label: Text( 'sakldkl'),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: withoutLabelPadding ? 0.0 : 2.0),
                              //   child: labelWidget,
                              // ),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withOpacity(0.6), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),

                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal))),
                            ),
                            isExpanded: true,
                            // style: mainStyle(context, 12,color: Colors.green),
                            hint: Text('Repeat',
                                style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700)),
                            items: liveCubit.meetingsConfigModel!.data.repeat
                                .map((item) => DropdownMenuItem<Repeat>(
                                      value: item,
                                      child: Text(item.title,
                                          style:
                                              mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700)),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return '   Please select repeat';
                              }
                              return null;
                            },
                            value: liveCubit.emptyTimeZoneForViewOnLeft,

                            onChanged: (value) {
                              //Do something when changing the item if you want.
                              liveCubit.updateMeetingRepeat(value!);
                            },
                            onSaved: (value) {
                              // selectedValue = value.toString();
                            },
                            buttonStyleData: ButtonStyleData(
                              // height: 60,
                              padding: EdgeInsets.only(left: 0, right: defaultHorizontalPadding),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Row(
                                children: [
                                  Text(
                                    liveCubit.pickedMeetingRepeat == null
                                        ? 'Select repeat'
                                        : liveCubit.pickedMeetingRepeat!.title,
                                    style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                  ),
                                  widthBox(7.w),
                                  Icon(Icons.arrow_forward_ios, size: 20),
                                ],
                              ),
                              iconSize: 20,
                            ),
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(defaultRadiusVal),
                                ),
                                maxHeight: 0.5.sh),
                          ),

                          // MeetingPickerRow(
                          //   title: 'Time zone',
                          //   val: liveCubit.pickedMeetingTimezone == null
                          //       ? 'Pick a time zone'
                          //       : getFormattedDateOnlyTime(liveCubit.pickedMeetingTimezone!),
                          //   onClick: () async {
                          //     showModalBottomSheet(
                          //         context: context,
                          //         builder: (context) {
                          //           var now = DateTime.now();
                          //           return SpinnerDateTimePicker(
                          //             initialDateTime: now,
                          //             maximumDate: now.add(Duration(days: 7)),
                          //             minimumDate: now.subtract(Duration(days: 1)),
                          //             mode: CupertinoDatePickerMode.time,
                          //             use24hFormat: true,
                          //             didSetTime: (value) {
                          //               logg("did set time: $value");
                          //               logg(
                          //                   "picked time: ${getFormattedDateOnlyTime(value)}");
                          //               liveCubit.updateMeetingTimeZone(value);
                          //             },
                          //           );
                          //         });
                          //     ///
                          //
                          //   },
                          // ),

                          ///
                          ///
                          ///
                          heightBox(10.h),
                          MeetingDetailsSectionTitle(
                            title: 'Security',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                            child: Column(
                              children: [
                                heightBox(15.h),
                                MeetingRowWithToggle(
                                  title: 'Require Meeting Passcode',
                                  subTitle:
                                      'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.requireMeetingPassCode,
                                  toggleClick: (val) {
                                    liveCubit.updateRequireMeetingPassCode(val);
                                  },
                                ),
                                Divider(
                                  height: 15.h,
                                  thickness: 1,
                                ),
                                if (liveCubit.requireMeetingPassCode)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Pass code',
                                          style: mainStyle(context, 13, weight: FontWeight.w700),
                                        ),
                                        Text(
                                          liveCubit.passCode,
                                          style: mainStyle(context, 13, weight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                if (liveCubit.requireMeetingPassCode)
                                  Divider(
                                    height: 15.h,
                                    thickness: 1,
                                  ),
                                MeetingRowWithToggle(
                                  title: 'Enable Waiting room',
                                  subTitle: 'Only users authorized by the host can participate in the meeting.',
                                  toggleVal: liveCubit.enableWaitingRoom,
                                  toggleClick: (val) {
                                    liveCubit.updateEnableWaitingRoom(val);
                                  },
                                ),
                                // Divider(
                                //   height: 15.h,
                                //   thickness: 1,
                                // ),

                                heightBox(15.h),
                              ],
                            ),
                          ),

                          MeetingDetailsSectionTitle(
                            title: 'Meeting Options',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                            child: Column(
                              children: [
                                heightBox(15.h),
                                MeetingRowWithToggle(
                                  title: 'Allow Participants to join before host',
                                  // subTitle: 'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.allowParticipantToJoin,
                                  toggleClick: (val) {
                                    liveCubit.updateAllowParticipantToJoin(val);
                                  },
                                ),
                                Divider(
                                  height: 15.h,
                                  thickness: 1,
                                ),
                                MeetingRowWithToggle(
                                  title: 'Automatically Record Meeting',
                                  // subTitle: 'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.enableAutoMeetingREcord,
                                  toggleClick: (val) {
                                    liveCubit.updateAutoREcordMeeting(val);
                                  },
                                ),
                                Divider(
                                  height: 15.h,
                                  thickness: 1,
                                ),
                                MeetingRowWithToggle(
                                  title: 'Add to Calendar',
                                  // subTitle: 'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.addToCalendar,
                                  toggleClick: (val) {
                                    liveCubit.updateAddToCalendar(val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          heightBox(15.h),
                          MeetingDetailsSectionTitle(
                            title: 'Share permission',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                            child: Column(
                              children: [
                                heightBox(15.h),
                                MeetingRowWithToggle(
                                  title: 'Publish Upcoming Meeting On Feed Page',
                                  // subTitle: 'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.publishToFeed,
                                  toggleClick: (val) {
                                    liveCubit.updateSharePermission(val);
                                  },
                                ),
                                Divider(
                                  height: 15.h,
                                  thickness: 1,
                                ),
                                MeetingRowWithToggle(
                                  title: 'Publish the live of the meeting on Mena Live Page',
                                  // subTitle: 'Only those with the invite link or passcode are eligible to join the meeting',
                                  toggleVal: liveCubit.publishTheLiveToMenaLivePage,
                                  toggleClick: (val) {
                                    liveCubit.updatePublishTheLiveToMenaLivePage(val);
                                  },
                                ),
                                heightBox(22.h),
                                Text(
                                  'If you active this option , all users in Mena will watch the meeting',
                                  textAlign: TextAlign.center,
                                  style: mainStyle(context, 13, color: Colors.red, weight: FontWeight.w700),
                                ),
                                Divider(),
                                AgreeTerms(byText: 'Clicking join')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  heightBox(22.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                    child: state is UpdatingMeetingStatus
                        ? DefaultLoaderColor()
                        : DefaultButton(
                            text: 'Save',
                            onClick: () {
                              // navigateTo(context, CreateUpcomingMeetingSelectDetails());

                              if (_formKey.currentState!.validate()) {
                                liveCubit.saveAndEditMeeting(
                                    title: meetingTitleCont.text, isEdit: widget.customMeetingToEdit != null,);
                              }
                            },
                            isEnabled: liveCubit.selectedParticipantTypeId != '-1',
                          ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MeetingPickerRow extends StatelessWidget  {
  const MeetingPickerRow({
    super.key,
    required this.title,
    required this.val,
    required this.controller,
    required this.validator,
    this.onClick,
  });

  final String title;
  final String val;
  final Function()? onClick;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultInputField(
          onTap: onClick,
          controller: controller,
          validate: validator,
          prefixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
              ),
              widthBox(7.w),

              // Text('data'),
            ],
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                val,
                style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
              ),
              widthBox(7.w),
              Icon(Icons.arrow_forward_ios),
              // widthBox(7.w),
              // Text('data'),
            ],
          ),
          readOnly: true,
          borderRadius: 0,
          fillColor: Colors.white,
          focusedBorderColor: Colors.transparent,
          unFocusedBorderColor: Colors.transparent,
          label: '',
        ),
        Divider(
          height: 10.h,
          thickness: 1,
        ),
      ],
    );
  }
}

class MeetingRowWithToggle extends StatefulWidget {
  const MeetingRowWithToggle({
    super.key,
    required this.title,
    this.subTitle,
    required this.toggleVal,
    required this.toggleClick,
  });

  final String title;
  final String? subTitle;
  final Function(bool isOn) toggleClick;
  final bool toggleVal;

  @override
  State<MeetingRowWithToggle> createState() => _MeetingRowWithToggleState();
}

class _MeetingRowWithToggleState extends State<MeetingRowWithToggle> {
  // bool toggleVal=false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: mainStyle(context, 13, weight: FontWeight.w700),
            ),
            if (widget.subTitle != null) heightBox(7.h),
            if (widget.subTitle != null)
              Text(
                widget.subTitle!,
                style: mainStyle(context, 12),
              ),
          ],
        )),
        widthBox(7.w),
        FlutterSwitch(
          // width: 125.0,
          height: 27.0.h,
          width: 47.h,
          // valueFontSize: 25.0,
          // toggleSize: 45.0,
          value: widget.toggleVal,

          // borderRadius: 30.0,
          // padding: 8.0,
          // showOnOff: true,
          onToggle: widget.toggleClick,
        ),
      ],
    );
  }
}

class MeetingDetailsSectionTitle extends StatelessWidget {
  const MeetingDetailsSectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
        ),
        Container(
          width: double.maxFinite,
          color: newLightGreyColor,
          child: Padding(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child: Text(
              title,
              style: mainStyle(context, 14, isBold: true),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
