import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/appointments_slots.dart';
import 'package:mena/models/local_models.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_slot_prof_facility.dart';
import 'package:mena/modules/appointments/appointments_layouts/status_layout.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';
import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../feeds_screen/feeds_screen.dart';
import '../../feeds_screen/widgets/follow_user_button.dart';
import 'book_appointment_form.dart';
import 'confirm_details_of_your_appointment_slot.dart';
import 'my_appointments.dart';

class SelectSlotTimeLayout extends StatefulWidget {
  const SelectSlotTimeLayout({Key? key, this.customSlot}) : super(key: key);
  final MySLot? customSlot;

  @override
  State<SelectSlotTimeLayout> createState() => _SelectSlotTimeLayoutState();
}

class _SelectSlotTimeLayoutState extends State<SelectSlotTimeLayout> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Back',
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding, vertical: 8),
          child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
            listener: (context, state) {
              // TODO: implement listener

              if (state is SuccessUpdatingSlotState) {
                navigateTo(context,
                    StatusLayout(status: StatusEnum.successUpdatingSlot));
                // navigateBackToHome(context);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Slot timing:',
                          style:
                              mainStyle(context, 12, weight: FontWeight.w600),
                        ),
                        heightBox(10.h),
                        SizedBox(
                          height: 68.h,
                          child: Center(
                            child: ListView.separated(
                              shrinkWrap: true,
                              // padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                              itemBuilder: (context, index) =>
                                  CalendarCustomDayItem(
                                dateTime: appointmentCubit.slotPickDays[index],
                                viewDate: false,
                                isSelected: appointmentCubit
                                    .selectedSlotPickDays
                                    .contains(
                                        appointmentCubit.slotPickDays[index]),
                                callBack: () {
                                  appointmentCubit.updateSelectedSlotTiming(
                                      appointmentCubit.slotPickDays[index]);
                                },
                              ),
                              separatorBuilder: (c, i) => widthBox(10.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: appointmentCubit.slotPickDays.length,
                            ),
                          ),
                        ),
                        heightBox(44.h),
                        Expanded(
                          child: appointmentCubit.selectedSlotPickDays.isEmpty
                              ? SizedBox()
                              : SingleChildScrollView(
                                  controller: controller,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Time ranges: ',
                                        style: mainStyle(context, 12,
                                            weight: FontWeight.w600),
                                      ),
                                      appointmentCubit.slotTimeRanges.isEmpty
                                          ? heightBox(15.h)
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: 15.h, bottom: 44.h),
                                              itemBuilder: (context, index) {
                                                return TimeSlotRow(
                                                  fromTime:
                                                      getFormattedDateOnlyTime(
                                                          appointmentCubit
                                                              .slotTimeRanges[
                                                                  index]
                                                              .from),
                                                  toTime:
                                                      getFormattedDateOnlyTime(
                                                          appointmentCubit
                                                              .slotTimeRanges[
                                                                  index]
                                                              .to),
                                                  assetName:
                                                      'assets/svg/icons/remove_circle.svg',
                                                  isSlotStashed: true,
                                                  onIconTap: () {
                                                    appointmentCubit
                                                        .removeSlotTimeRanges(
                                                            appointmentCubit
                                                                    .slotTimeRanges[
                                                                index]);
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      heightBox(7.h),
                                              itemCount: appointmentCubit
                                                  .slotTimeRanges.length,
                                            ),
                                      TimeSlotRow(
                                        fromTime: appointmentCubit
                                                    .tempFromTime ==
                                                null
                                            ? '--:-- AM'
                                            : getFormattedDateOnlyTime(
                                                appointmentCubit.tempFromTime!),
                                        toTime: appointmentCubit.tempToTime ==
                                                null
                                            ? '--:-- PM'
                                            : getFormattedDateOnlyTime(
                                                appointmentCubit.tempToTime!),
                                        assetName:
                                            'assets/svg/icons/addIcon.svg',
                                        isSlotStashed: false,
                                        onFromTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                var now = DateTime.now();
                                                return SpinnerDateTimePicker(
                                                  initialDateTime: now,
                                                  maximumDate: now
                                                      .add(Duration(days: 7)),
                                                  minimumDate: now.subtract(
                                                      Duration(days: 1)),
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  use24hFormat: true,
                                                  didSetTime: (value) {
                                                    logg(
                                                        "did set time: $value");
                                                    logg(
                                                        "picked time: ${getFormattedDateOnlyTime(value)}");
                                                    appointmentCubit
                                                        .updateTempFromTime(
                                                            value);
                                                  },
                                                );
                                              });
                                        },
                                        onToTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              var now = DateTime.now();
                                              return SpinnerDateTimePicker(
                                                initialDateTime: now,
                                                maximumDate:
                                                    now.add(Duration(days: 7)),
                                                minimumDate: now.subtract(
                                                    Duration(days: 1)),
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                use24hFormat: true,
                                                didSetTime: (value) {
                                                  logg(
                                                      "did set time val: $value");
                                                  logg(
                                                      "picked time: ${getFormattedDateOnlyTime(value)}");
                                                  appointmentCubit
                                                      .updateTempToTime(value);
                                                },
                                              );
                                            },
                                          );
                                        },
                                        onIconTap: () async {
                                          appointmentCubit.addSlotTimeRanges(
                                              TimeRange(
                                                  from: appointmentCubit
                                                      .tempFromTime!,
                                                  to: appointmentCubit
                                                      .tempToTime!));
                                          appointmentCubit.resetTempRange();
                                          await Future.delayed(
                                              Duration(milliseconds: 100));
                                          controller.animateTo(
                                              controller
                                                  .position.maxScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 100),
                                              curve: Curves.easeIn);
                                        },
                                        isIconEnabled:
                                            (appointmentCubit.tempFromTime !=
                                                    null &&
                                                appointmentCubit.tempToTime !=
                                                    null
                                            // &&
                                            // (appointmentCubit.tempFromTime!
                                            //     .isBefore(appointmentCubit.tempToTime!))
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                        heightBox(10.h),

                        ///
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: state is UpdatingSlotState
                        ? DefaultLoaderGrey()
                        : DefaultButton(
                            text: widget.customSlot == null ? 'Next' : 'Save',
                            onClick: () {
                              widget.customSlot == null
                                  ? navigateTo(
                                      context, PickProfessionalProviderLayout())
                                  : appointmentCubit.updateSlot(
                                      widget.customSlot!.id.toString(),
                                      UpdateVal.dateTime);
                            },
                            isEnabled:
                                appointmentCubit.slotTimeRanges.isNotEmpty),
                  )
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  //   child: DefaultButton(
                  //       text: 'Next',
                  //       onClick: () {
                  //
                  //
                  //         navigateTo(context, PickProfessionalProviderLayout());
                  //       },
                  //       isEnabled: appointmentCubit.slotTimeRanges.isNotEmpty),
                  // )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TimeSlotRow extends StatelessWidget {
  const TimeSlotRow({
    super.key,
    required this.onIconTap,
    required this.fromTime,
    required this.toTime,
    required this.assetName,
    required this.isSlotStashed,
    this.onFromTap,
    this.onToTap,
    this.isIconEnabled = true,
  });

  final Function() onIconTap;
  final Function()? onFromTap;
  final Function()? onToTap;
  final String fromTime;
  final String toTime;
  final String assetName;
  final bool isSlotStashed;
  final bool isIconEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: GestureDetector(
                  onTap: onFromTap,
                  child: DefaultSoftButton(
                    label: fromTime,
                    customHeight: 37.h,
                    customColor: isSlotStashed ? mainBlueColor : softBlueColor,
                    customFontColor:
                        isSlotStashed ? Colors.white : mainBlueColor,
                  ),
                ),
              ),
            ),
            Text(
              'To',
              style: mainStyle(context, 13),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: GestureDetector(
                  onTap: onToTap,
                  child: DefaultSoftButton(
                    label: toTime,
                    customHeight: 37.h,
                    customColor: isSlotStashed ? mainBlueColor : softBlueColor,
                    customFontColor:
                        isSlotStashed ? Colors.white : mainBlueColor,
                  ),
                ),
              ),
            ),
          ],
        )),

        ///
        ///
        ///
        ///
        GestureDetector(
          onTap: isIconEnabled ? onIconTap : null,
          child: SvgPicture.asset(
            assetName,
            color: isIconEnabled ? null : disabledGreyColor,
            height: 37.h,
          ),
        ),
      ],
    );
  }
}
