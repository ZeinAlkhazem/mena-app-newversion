import 'dart:collection';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/main_cubit/main_cubit.dart';
import '../../../models/api_model/config_model.dart';
import '../../../models/api_model/slots_model.dart';
import '../../../models/local_models.dart';
import 'appointment_info.dart';
import 'book_appointment_form.dart';
import 'calendar_utils.dart';

class AppointmentCalendarLayout extends StatefulWidget {
  const AppointmentCalendarLayout({Key? key}) : super(key: key);

  @override
  State<AppointmentCalendarLayout> createState() => _AppointmentCalendarLayoutState();
}

class _AppointmentCalendarLayoutState extends State<AppointmentCalendarLayout> {
  late final ValueNotifier<List<Slot>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode =
      RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  // DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<AppointmentType> appointmentTypes = [];

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    var appointmentsCubit = AppointmentsCubit.get(context);

    appointmentTypes = MainCubit.get(context).configModel!.data.appointmentTypes;
    appointmentsCubit.updateSelectedAppointmentType(appointmentTypes[0]).then((value) {
      // setState(() {
      //
      // });

      _selectedDay = appointmentsCubit.focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      setState(() {
        initialized = true;
      });
    });

    // AppointmentsCubit.get(context).getSlots();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Slot> _getEventsForDay(DateTime day) {
    // Implementation example
    return AppointmentsCubit.get(context).kEvents[day] ?? [];
  }

  List<Slot> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      AppointmentsCubit.get(context).updateFocusedDay(focusedDay);
      setState(() {
        _selectedDay = selectedDay;
        // _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    AppointmentsCubit.get(context).updateFocusedDay(focusedDay);
    setState(() {
      _selectedDay = null;
      // _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

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
      body: SafeArea(
        child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return state is GettingSlotsList
                ? DefaultLoaderColor()
                : appointmentCubit.slotsModel!.allDatesAndSlots == null
                    ? Center(child: Text('no slots available'))
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18),
                        child: Column(
                          children: [
                            AppointmentHeader(
                              title: 'When would you like to schedule your appointment? ',
                              image: 'assets/svg/icons/gif.svg',
                            ),
                            heightBox(10.h),
                            HorizontalSelectorScrollable(
                              buttons: appointmentTypes
                                  .map((e) => SelectorButtonModel(
                                      title: e.title,
                                      onClickCallback: () {
                                        appointmentCubit.updateSelectedAppointmentType(e);
                                        // homeCubit.changeSelectedHomePlatform(
                                        //     e.id.toString());
                                      },
                                      isSelected:
                                          appointmentCubit.selectedAppointmentType == e))
                                  .toList(),
                            ),
                            heightBox(20.h),
                            Expanded(
                              child: !initialized
                                  ? Center(child: DefaultLoaderColor())
                                  : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Select Date',
                                            style: mainStyle(context, 12),
                                          ),
                                          TableCalendar<Slot>(
                                            firstDay: DateTime.parse(appointmentCubit
                                                        .slotsModel!
                                                        .allDatesAndSlots!
                                                        .keys
                                                        .first)
                                                    .isAfter(DateTime.now())
                                                ? DateTime.now()
                                                : DateTime.parse(appointmentCubit
                                                    .slotsModel!.allDatesAndSlots!.keys.first),
                                            lastDay: DateTime.parse(appointmentCubit
                                                        .slotsModel!
                                                        .allDatesAndSlots!
                                                        .keys
                                                        .last)
                                                    .isBefore(DateTime.now())
                                                ? DateTime.now().add(Duration(days: 1))
                                                : DateTime.parse(appointmentCubit
                                                    .slotsModel!.allDatesAndSlots!.keys.last),
                                            focusedDay: appointmentCubit.focusedDay,
                                            headerStyle: HeaderStyle(
                                              formatButtonVisible: false,
                                              titleCentered: true,
                                              titleTextStyle: mainStyle(context, 16,
                                                  weight: FontWeight.w700),
                                              rightChevronIcon: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: SvgPicture.asset(
                                                  'assets/svg/icons/rightChevronIcon.svg',
                                                  height: 33.sp,
                                                ),
                                              ),
                                              leftChevronIcon: SvgPicture.asset(
                                                  'assets/svg/icons/leftChevronIcon.svg',
                                                  height: 33.sp),
                                            ),
                                            // daysOfWeekStyle: DaysOfWeekStyle(
                                            // decoration: BoxDecoration(
                                            //   color: Colors.red
                                            // )
                                            // ),
                                            selectedDayPredicate: (day) =>
                                                isSameDay(_selectedDay, day),
                                            rangeStartDay: _rangeStart,
                                            rangeEndDay: _rangeEnd,
                                            calendarFormat: _calendarFormat,
                                            rangeSelectionMode: _rangeSelectionMode,
                                            eventLoader: _getEventsForDay,
                                            daysOfWeekHeight: 15.h,
                                            rowHeight: 55.h,
                                            // weekNumbersVisible: true,
                                            onDaySelected: _onDaySelected,
                                            // onRangeSelected: _onRangeSelected,
                                            onFormatChanged: (format) {
                                              if (_calendarFormat != format) {
                                                setState(() {
                                                  _calendarFormat = format;
                                                });
                                              }
                                            },
                                            onPageChanged: (focusedDay) {
                                              appointmentCubit.updateFocusedDay(focusedDay);
                                            },

                                            /// builders
                                            calendarBuilders: CalendarBuilders(
                                              markerBuilder: (context, date, events) {
                                                return events.length > 0
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(bottom: 13.0.sp),
                                                        child: DefaultContainer(
                                                          backColor: Colors.grey,
                                                          height: 5.sp,
                                                          width: 11.sp,
                                                          withoutBorder: true,
                                                          radius: 5.sp,
                                                        ),
                                                      )
                                                    : SizedBox();
                                              },
                                              defaultBuilder: (context, day, focusedDay) {
                                                for (DateTime d
                                                    in appointmentCubit.toHighlight) {
                                                  if (day.day == d.day &&
                                                      day.month == d.month &&
                                                      day.year == d.year) {
                                                    return CalendarDayContainer(
                                                      day: day,
                                                      isAvailable: true,
                                                    );
                                                  }
                                                }
                                                return CalendarDayContainer(
                                                  day: day,
                                                );
                                              },
                                              todayBuilder: (context, day, focusedDay) {
                                                return CalendarDayContainer(
                                                    day: day, isToday: true);
                                              },
                                              selectedBuilder: (context, day, focusedDay) {
                                                return CalendarDayContainer(
                                                    day: day, isSelected: true);
                                              },
                                              //         disabledBuilder: (context, day, focusedDay) {
                                              //   return CalendarDayContainer(day: day, isDisabled: true);
                                              // }
                                            ),

                                            startingDayOfWeek: StartingDayOfWeek.monday,
                                            /// not working with marker builder

                                            calendarStyle: CalendarStyle(
                                              // Use `CalendarStyle` to customize the UI
                                              outsideDaysVisible: false,
                                              cellPadding: EdgeInsets.all(5.sp),
                                              canMarkersOverflow: false,
                                              // defaultTextStyle: mainStyle(context, 10),
                                              // selectedTextStyle: mainStyle(context, 12, color: Colors.black),
                                              // isTodayHighlighted: true
                                              /// not working with marker builder
                                              // markersMaxCount: 4,
                                              // markersAutoAligned: true,
                                              // markerMargin: EdgeInsets.all(8),
                                              // markersAnchor: 33.sp,
                                              /// not working with marker builder

                                              ///days of month decorations
                                              ///we are using builder so no decoration
                                              // defaultDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // disabledDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // holidayDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // selectedDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // todayDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // rangeStartDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // rangeEndDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // withinRangeDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                              // weekendDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.red),

                                              /// marker decoration
                                              /// not working with marker builder
                                              // markerDecoration:
                                              //     BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                                              // todayTextStyle: mainStyle(context, 12, color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Text(
                                            'Select Time',
                                            style: mainStyle(context, 12),
                                          ),
                                          SizedBox(height: 10.h),
                                          ValueListenableBuilder<List<Slot>>(
                                            valueListenable: _selectedEvents,
                                            builder: (context, value, _) {
                                              return GridView.count(
                                                shrinkWrap: true,
                                                childAspectRatio: 2.2,
                                                crossAxisSpacing: 5.w,
                                                mainAxisSpacing: 8.h,
                                                physics: NeverScrollableScrollPhysics(),
                                                crossAxisCount: 4,
                                                children: value.map((Slot e) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      appointmentCubit
                                                          .updateSelectedDateTimeSlot(e);
                                                      logg(
                                                          'updated selected date time slot: ${appointmentCubit.selectedDateTimeSlot}');
                                                      navigateTo(context,
                                                          AppointmentInformationLayout());
                                                    },
                                                    child: DefaultContainer(
                                                      height: 27.sp,
                                                      radius: 45,
                                                      backColor: softBlueColor,
                                                      borderColor: softBlueColor,
                                                      childWidget: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 1.2 *
                                                                  defaultHorizontalPadding),
                                                          child: FittedBox(
                                                            child: Text(
                                                              getFormattedDateOnlyTime(
                                                                  e.dateTime)
                                                              // '${DateTime.parse(e.title).hour.toString()}:${DateTime.parse(e.title).minute.toString()}',
                                                              ,
                                                              maxLines: 1,
                                                              style: mainStyle(context, 13,
                                                                  weight: FontWeight.w900,
                                                                  color: mainBlueColor,
                                                                  letterSpacing: 1.2),
                                                              // maxLines: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  //   Container(
                                                  //   margin: const EdgeInsets.symmetric(
                                                  //     horizontal: 12.0,
                                                  //     vertical: 4.0,
                                                  //   ),
                                                  //   decoration: BoxDecoration(
                                                  //     border: Border.all(),
                                                  //     borderRadius: BorderRadius.circular(12.0),
                                                  //   ),
                                                  //   child: ListTile(
                                                  //     onTap: () => print('${e}'),
                                                  //     title: Text('${e}'),
                                                  //   ),
                                                  // );
                                                }).toList(),
                                                // itemCount: value.length,
                                                // itemBuilder: (context, index) {
                                                //   return Container(
                                                //     margin: const EdgeInsets.symmetric(
                                                //       horizontal: 12.0,
                                                //       vertical: 4.0,
                                                //     ),
                                                //     decoration: BoxDecoration(
                                                //       border: Border.all(),
                                                //       borderRadius: BorderRadius.circular(12.0),
                                                //     ),
                                                //     child: ListTile(
                                                //       onTap: () => print('${value[index]}'),
                                                //       title: Text('${value[index]}'),
                                                //     ),
                                                //   );
                                                // },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}

class CalendarDayContainer extends StatelessWidget {
  const CalendarDayContainer({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.isAvailable = false,
  });

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0.sp),
      child: Container(
        width: double.maxFinite,
        decoration: ShapeDecoration(
          color: isAvailable
              ? Color(0xff33B6FF).withOpacity(0.2)
              : isSelected
                  ? mainBlueColor
                  : Color(0xffA3A3A3).withOpacity(0.3),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 18.sp,
              cornerSmoothing: 0.81,
            ),
            side: BorderSide(
              color: isToday ? mainBlueColor : Colors.transparent,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0.sp),
            child: Text(
              day.day.toString(),
              style: mainStyle(context, 13,
                  color: isAvailable
                      ? mainBlueColor
                      : isSelected
                          ? Colors.white
                          : Color(0xffA3A3A3),
                  weight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
