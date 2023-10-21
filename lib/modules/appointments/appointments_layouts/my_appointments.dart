import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/client_appointments_model.dart';
import 'package:mena/models/local_models.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_slot_prof_facility.dart';
import 'package:mena/modules/appointments/appointments_layouts/select_slot_timing.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../models/api_model/appointments_slots.dart';
import 'appointment_details.dart';

// import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';

class MyAppointmentsLayout extends StatelessWidget {
  const MyAppointmentsLayout({Key? key}) : super(key: key);

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
      body: BlocConsumer<AppointmentsCubit, AppointmentsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SafeArea(
              child: Column(
                children: [
                  HorizontalSelectorScrollable(
                    buttons: [
                      SelectorButtonModel(
                          title: 'Clients Appointments List',
                          onClickCallback: () {
                            appointmentCubit.updateSelectedView(0);
                          },
                          isSelected: appointmentCubit.selectedAppointmentView == 0),
                      SelectorButtonModel(
                          title: 'My availability',
                          onClickCallback: () {
                            appointmentCubit.updateSelectedView(1);
                          },
                          isSelected: appointmentCubit.selectedAppointmentView == 1),
                      SelectorButtonModel(
                          title: 'History',
                          onClickCallback: () {
                            appointmentCubit.updateSelectedView(2);
                          },
                          isSelected: appointmentCubit.selectedAppointmentView == 2),
                    ],
                    customFontSize: 10.5,
                  ),
                  Expanded(child: CurrentViewLayout()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: DefaultButton(
                        text: 'Create new slot',
                        onClick: () {
                          navigateTo(context, PickAppointmentTypeInSlotLayout());
                        }),
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

class CurrentViewLayout extends StatelessWidget {
  const CurrentViewLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch (appointmentCubit.selectedAppointmentView) {
              case 0:
                return ClientsAppointmentsListView();
              case 1:
                return MyAvailabilitySlotsView();
              case 2:
                return AppointmentsHistoryView();
              default:
                return ClientsAppointmentsListView();
            }
          },
        ),
      ),
    );
  }
}

class ClientsAppointmentsListView extends StatefulWidget {
  const ClientsAppointmentsListView({Key? key}) : super(key: key);

  @override
  State<ClientsAppointmentsListView> createState() => _ClientsAppointmentsListViewState();
}

class _ClientsAppointmentsListViewState extends State<ClientsAppointmentsListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appointmentCubit = AppointmentsCubit.get(context);
    appointmentCubit.updateSelectedMyAppointmentsDay(appointmentCubit.selectedWeekDays[0]);
    appointmentCubit.getClientAppointments(appointmentCubit.selectedWeekDays[0]);
    // get appointment of today;
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return BlocConsumer<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getIsTodayOrYesterday(DateTime.now()),
                          style: mainStyle(context, 12),
                        ),
                        heightBox(5.h),
                        Text(
                          getFormattedDateWithDayName(DateTime.now()),
                          style: mainStyle(context, 13, weight: FontWeight.w700),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                        // open calendar
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2022, 1, 1),
                            maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          appointmentCubit.updateSelectedWeekDays(date);
                          appointmentCubit.updateSelectedMyAppointmentsDay(
                              appointmentCubit.selectedWeekDays[0]);
                          appointmentCubit
                              .getClientAppointments(appointmentCubit.selectedWeekDays[0]);
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        //
                      },
                      child: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                    ),
                  ],
                ),
              ),
              heightBox(10.h),
              SizedBox(
                height: 68.h,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                    itemBuilder: (context, index) => CalendarCustomDayItem(
                      dateTime: appointmentCubit.selectedWeekDays[index],
                      isSelected: appointmentCubit.selectedWeekDays[index] ==
                          appointmentCubit.selectedMyAppointmentsDay,
                      callBack: () {
                        appointmentCubit.updateSelectedMyAppointmentsDay(
                            appointmentCubit.selectedWeekDays[index]);
                        appointmentCubit
                            .getClientAppointments(appointmentCubit.selectedWeekDays[index]);
                      },
                    ),
                    separatorBuilder: (c, i) => widthBox(10.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: appointmentCubit.selectedWeekDays.length,
                  ),
                ),
              ),
              heightBox(10.h),
              Container(
                height: 66.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black, width: 0.2)),
                  color: newLightTextGreyColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: Row(
                    children: [
                      Text(
                        getFormattedDateWithDayName(
                            appointmentCubit.selectedMyAppointmentsDay),
                        style: mainStyle(context, 16, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              heightBox(10.h),

              ///
              ///
              ///
              ///
              state is LoadingClientAppointment
                  ? DefaultLoaderGrey()
                  : (appointmentCubit.clientAppointmentsModel == null ||
                          appointmentCubit.clientAppointmentsModel!.data.appointments.isEmpty)
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              heightBox(20.h),
                              SvgPicture.asset(
                                'assets/svg/icons/gif.svg',
                                width: 0.2.sw,
                              ),
                              heightBox(20.h),
                              Text(
                                'You haven\'t set up any appointment slots for your clients to schedule appointments',
                                style: mainStyle(
                                  context,
                                  14,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ))
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 10.h),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => AppointmentCard(
                              appointmentItem: appointmentCubit
                                  .clientAppointmentsModel!.data.appointments[index],
                              callBack: () {
                                navigateTo(
                                    context,
                                    AppointmentDetailsLayout(
                                      appointmentItem: appointmentCubit
                                          .clientAppointmentsModel!.data.appointments[index],
                                    ));
                              },
                            ),
                            separatorBuilder: (c, i) => heightBox(10.h),
                            itemCount: appointmentCubit
                                .clientAppointmentsModel!.data.appointments.length,
                          ),
                        )
            ],
          ),
        );
      },
    );
  }
}

class MyAvailabilitySlotsView extends StatefulWidget {
  const MyAvailabilitySlotsView({Key? key}) : super(key: key);

  @override
  State<MyAvailabilitySlotsView> createState() => _MyAvailabilitySlotsViewState();
}

class _MyAvailabilitySlotsViewState extends State<MyAvailabilitySlotsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appointmentCubit = AppointmentsCubit.get(context);
    appointmentCubit.getMySlots();
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return BlocConsumer<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is DeletingSlotStateSuccess) {
          Navigator.pop(context);
          appointmentCubit.getMySlots();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: state is LoadingMySlotsAppointment
              ? DefaultLoaderGrey()
              : (appointmentCubit.mySlotsModel == null ||
                      appointmentCubit.mySlotsModel!.data.slots.isEmpty)
                  ? EmptyListLayout()
                  : ListView.separated(
                      padding: EdgeInsets.only(bottom: 10.h),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => AppointmentAvailabilityCard(
                        mySLot: appointmentCubit.mySlotsModel!.data.slots[index],
                      ),
                      separatorBuilder: (c, i) => heightBox(10.h),
                      itemCount: appointmentCubit.mySlotsModel!.data.slots.length,
                    ),
        );
      },
    );
  }
}

class AppointmentsHistoryView extends StatefulWidget {
  const AppointmentsHistoryView({Key? key}) : super(key: key);

  @override
  State<AppointmentsHistoryView> createState() => _AppointmentsHistoryViewState();
}

class _AppointmentsHistoryViewState extends State<AppointmentsHistoryView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appointmentCubit = AppointmentsCubit.get(context);

    appointmentCubit.getAppointmentHistory();
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'January',
                    style: mainStyle(context, 13),
                  ),
                  PullDownButton(
                    itemBuilder: (context) => appointmentCubit.localAppStates
                        .map((e) => PullDownMenuItem(
                              onTap: () {
                                // jumpToCategory(widget.buttons.indexOf(e));
                                // e.onClickCallback();
                                appointmentCubit.getAppointmentHistory(state: e.id);
                              },
                              title: e.name,
                              textStyle: mainStyle(context, 13,
                                  weight:
                                      // e.isSelected ? FontWeight.w900 :
                                      FontWeight.w600,
                                  color:
                                      // e.isSelected ?
                                      mainBlueColor
                                  // : Colors.black
                                  ),
                            ))
                        .toList(),
                    position: PullDownMenuPosition.over,
                    backgroundColor: Colors.white.withOpacity(0.75),
                    offset: const Offset(-2, 1),
                    applyOpacity: true,
                    widthConfiguration: PullDownMenuWidthConfiguration(0.77.sw),
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Text(
                            'Filter',
                            style: mainStyle(context, 13,
                                color: mainBlueColor, weight: FontWeight.bold),
                          ),
                          widthBox(5.w),
                          SvgPicture.asset('assets/svg/icons/filter.svg'),
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     logg('view filters');
                  //
                  //   },
                  //   child:
                  //
                  //   Row(
                  //     children: [
                  //       Text(
                  //         'Filter',
                  //         style: mainStyle(context, 13,
                  //             color: mainBlueColor, weight: FontWeight.bold),
                  //       ),
                  //       widthBox(5.w),
                  //       SvgPicture.asset('assets/svg/icons/filter.svg'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              heightBox(10.h),
              Expanded(
                child: state is LoadingAppointmentHistory
                    ? DefaultLoaderGrey()
                    : (appointmentCubit.historyAppointmentsModel == null ||
                            appointmentCubit
                                .historyAppointmentsModel!.data.appointments.isEmpty)
                        ? EmptyListLayout()
                        : ListView.separated(
                            padding: EdgeInsets.only(bottom: 10.h),
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => AppointmentCard(
                              appointmentItem: appointmentCubit
                                  .historyAppointmentsModel!.data.appointments[index],
                            ),
                            separatorBuilder: (c, i) => heightBox(10.h),
                            itemCount: appointmentCubit
                                .historyAppointmentsModel!.data.appointments.length,
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CalendarCustomDayItem extends StatelessWidget {
  const CalendarCustomDayItem({
    super.key,
    required this.dateTime,
    required this.isSelected,
    required this.callBack,
    this.viewDate = true,
  });

  final DateTime dateTime;
  final bool isSelected;
  final bool viewDate;
  final Function() callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultContainer(
          customConstraints: BoxConstraints(minWidth: 0.107.sw),
          backColor: isSelected ? mainBlueColor : softBlueColor,
          radius: 55.sp,
          withoutBorder: true,
          childWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(dateTime),
                  style: mainStyle(context, 11,
                      weight: FontWeight.w700,
                      color: isSelected ? Colors.white : mainBlueColor),
                ),
                if (viewDate)
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Text(DateFormat('d').format(dateTime),
                        style: mainStyle(context, 11,
                            weight: FontWeight.w700,
                            color: isSelected ? Colors.white : mainBlueColor)),
                  ),
              ],
            ),
          )),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    this.callBack,
    required this.appointmentItem,
  });

  final Function()? callBack;

  final AppointmentItemModel appointmentItem;

  // final
  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return // Figma Flutter Generator Frame2688Widget - FRAME - HORIZONTAL
        GestureDetector(
      onTap: callBack,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
            bottomLeft: Radius.circular(10.sp),
            bottomRight: Radius.circular(10.sp),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(32, 32, 32, 0.25),
              offset: Offset(0, 2),
              blurRadius: 4,
            )
          ],
          color: Color.fromRGBO(250, 250, 250, 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Stack(
          children: [
            appointmentItem.userData == null
                ? SizedBox()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 99.h,
                        child: Stack(
                          children: [
                            Container(
                              height: 99.h,
                              width: 0.3.sw,
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    height: 99.h,
                                    width: 0.22.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.sp),
                                        // topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10.sp),
                                        // bottomRight: Radius.circular(10),
                                      ),
                                      color: Color.fromRGBO(18, 135, 221, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              // getFormattedDateOnlyTime(date),
                                              DateFormat('MMM').format(appointmentItem
                                                  .appointmentSlotData.dateTime),
                                              textAlign: TextAlign.center,
                                              style: mainStyle(context, 11,
                                                  color: Colors.white,
                                                  weight: FontWeight.w700),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              DateFormat('dd').format(appointmentItem
                                                  .appointmentSlotData.dateTime),
                                              textAlign: TextAlign.center,
                                              style: mainStyle(context, 20,
                                                  color: Colors.white,
                                                  weight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        widthBox(15.w)
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 23),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 0.3.sw,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                // mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 0.08.sw,
                                      child: ProfileBubble(
                                        pictureUrl: appointmentItem.userData!.personalPicture,
                                        isOnline: false,
                                        radius: 0.074.sw,
                                      )
                                      // CircleAvatar(
                                      //   backgroundColor: Colors.grey,
                                      //   radius: 0.072.sw,
                                      //   child: ClipR(
                                      //     child: Image.network(
                                      //         appointmentItem.userData.personalPicture),
                                      //   ),
                                      // ),
                                      ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      appointmentCubit
                                          .getLocalAppointmentParam(appointmentItem
                                                  .appointmentSlotData
                                                  .appointmentTypeData
                                                  .type )
                                          .svgAssetLink!,
                                      color: disabledGreyColor,
                                    ),
                                    widthBox(4.w),
                                    Text(
                                      '${appointmentCubit.getLocalAppointmentParam(appointmentItem.appointmentSlotData.appointmentTypeData.type).name}',
                                      textAlign: TextAlign.left,
                                      style: mainStyle(context, 9,
                                          weight: FontWeight.bold, color: softGreyColor),
                                    ),
                                  ],
                                ),
                              ),
                              heightBox(5.h),
                              Row(
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    constraints: BoxConstraints(maxWidth: 150.w),
                                    child: Text(
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      '${appointmentItem.fullName}',
                                      style: mainStyle(
                                        context,
                                        15,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' - 60 min ',
                                    textAlign: TextAlign.left,
                                    style: mainStyle(
                                      context,
                                      12,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Text(
                              //         '${appointmentItem.fullName}',
                              //         textAlign: TextAlign.left,
                              //         style: mainStyle(
                              //           context,
                              //           12,
                              //           weight: FontWeight.bold,
                              //
                              //         ),
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //
                              //   ],
                              // ),

                              heightBox(5.h),
                              appointmentItem.facilityData != null
                                  ? Text(
                                      '${appointmentItem.facilityData!.fullName}',
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: mainStyle(context, 9,
                                          weight: FontWeight.bold, color: mainBlueColor),
                                    )
                                  : appointmentItem.professionalData != null
                                      ? Text(
                                          '${appointmentItem.professionalData!.fullName}',
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: mainStyle(context, 9,
                                              weight: FontWeight.bold, color: mainBlueColor),
                                        )
                                      : Text('null'),
                              heightBox(5.h),
                              Text(
                                getFormattedDate(appointmentItem.appointmentSlotData.dateTime),
                                textAlign: TextAlign.left,
                                style: mainStyle(context, 9,
                                    weight: FontWeight.bold, color: softGreyColor),
                              ),
                              // SizedBox(
                              //   // width:double.maxFinite,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       Text('sdkj')
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 99.h,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: appointmentItem.state == '1'
                        ?


                        /// confirmed
                        mainBlueColor
                        : appointmentItem.state == '2'
                            ?

                            /// rescheduled
                            chatBlueColor
                            :

                            /// 3 or 4
                            /// canceled or deleted
                            alertRedColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.sp),
                      // topRight: Radius.circular(10.sp),
                      // bottomLeft: Radius.circular(10.sp),
                      bottomRight: Radius.circular(10.sp),
                    ),
                  ),
                  width: 66.w,
                  height: 28.h,
                  child: Center(
                    child: Text(
                      appointmentItem.state == '1'
                          ?

                          /// confirmed
                          'Confirmed'
                          : appointmentItem.state == '2'
                              ?

                              /// rescheduled
                              'Rescheduled'
                              : appointmentItem.state == '3'
                                  ?

                                  /// 3
                                  /// canceled
                                  'Canceled'
                                  : appointmentItem.state == '4'
                                      ?

                                      /// deleted
                                      'Deleted'
                                      : 'Unknown',
                      style: mainStyle(context, 9,
                          color: appointmentItem.state == '1'
                              ?

                              /// confirmed
                              Colors.white
                              : appointmentItem.state == '2'
                                  ?

                                  /// rescheduled
                                  mainBlueColor
                                  :

                                  /// 3
                                  /// canceled

                                  Colors.white,
                          weight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentAvailabilityCard extends StatelessWidget {
  const AppointmentAvailabilityCard({
    super.key,
    required this.mySLot,
  });

  final MySLot mySLot;

  // final
  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DefaultContainer(
        withoutBorder: true,
        withBoxShadow: true,
        childWidget: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SvgPicture.asset(
                    appointmentCubit
                            .getLocalAppointmentParam(
                                mySLot.appointmentTypeData.type.toString())
                            .svgAssetLink ??
                        '',
                    width: 28.sp,
                    color: mainBlueColor,
                  ),
                  widthBox(7.w),
                  Text(
                    mySLot.appointmentTypeData.title,
                    textAlign: TextAlign.left,
                    style: mainStyle(context, 13, color: mainBlueColor, isBold: true),
                  ),
                ],
              ),
              heightBox(10.h),
              Row(
                children: [
                  SizedBox(
                      width: 28.sp,
                      child: Center(
                          child: SvgPicture.asset(
                        'assets/svg/icons/apointment_building.svg',
                        width: 16.sp,
                        // color: mainBlueColor,
                      ))),
                  widthBox(7.w),
                  mySLot.facilityData == null
                      ? SizedBox()
                      : Text(
                          mySLot.facilityData!.fullName ?? '-',
                          textAlign: TextAlign.left,
                          style: mainStyle(context, 12, weight: FontWeight.w700),
                        ),
                ],
              ),
              heightBox(20.h),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 28.sp,
                            child: Center(
                                child: SvgPicture.asset(
                              'assets/svg/icons/calendar.svg',
                              color: Colors.black,
                              width: 16.sp,
                            ))),
                        widthBox(7.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // mySLot.da
                                '${mySLot.days == null ? 'null' : mySLot.days!.map((e) =>
                                    getDayOfWeekByOrder(int.parse(e)))
                                    .toString().replaceAll('(', '')
                                    .replaceAll(')', '')}',
                                textAlign: TextAlign.left,
                                style: mainStyle(context, 11,
                                    color: Colors.grey, weight: FontWeight.w700),
                              ),
                              SizedBox(height: 10.h),
                              ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Text(
                                      '${mySLot.times[index].fromTime} - ${mySLot.times[index].toTime}',
                                      style: mainStyle(context, 12,
                                          color: Colors.grey,
                                          weight: FontWeight.w700,
                                          letterSpacing: 1.5),
                                    );
                                  },
                                  shrinkWrap: true,
                                  separatorBuilder: (c, i) => heightBox(12.h),
                                  itemCount: mySLot.times.length),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    mySLot.price,
                    textAlign: TextAlign.left,
                    style: mainStyle(context, 13, weight: FontWeight.w700),
                  ),
                ],
              ),
              heightBox(17.h),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showMyAlertDialog(context, 'Confirm',
                            alertDialogContent: Text(
                              '\nYOu are about deleting this item \n Are you sure?',
                              style: mainStyle(context, 14),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('NO')),
                              TextButton(
                                  onPressed: () {
                                    var appointmentCubit = AppointmentsCubit.get(context);

                                    appointmentCubit.deleteSlot(mySLot.id.toString());
                                  },
                                  child: Text('YES'))
                            ]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(227, 0, 0, 1),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: mainStyle(context, 13, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // viewMySnackBar(context, text, actionLabel, () => null)
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                color: Colors.white,
                                height: 0.4.sh,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: SafeArea(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Edit:',
                                          style:
                                              mainStyle(context, 13, weight: FontWeight.w700),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              heightBox(7.h),
                                              DefaultButton(
                                                onClick: () {
                                                  navigateTo(
                                                      context,
                                                      PickAppointmentTypeInSlotLayout(
                                                        customSlot: mySLot,
                                                      ));
                                                },
                                                text: 'Appointment Type',
                                                backColor: Colors.transparent,
                                                titleColor: mainBlueColor,
                                              ),
                                              heightBox(7.h),
                                              DefaultButton(
                                                onClick: () {
                                                  navigateTo(
                                                      context,
                                                      SelectSlotTimeLayout(
                                                        customSlot: mySLot,
                                                      ));
                                                },
                                                text: 'Date & Time',
                                                backColor: Colors.transparent,
                                                titleColor: mainBlueColor,
                                              ),
                                              heightBox(7.h),
                                              DefaultButton(
                                                onClick: () {
                                                  navigateTo(
                                                      context,
                                                      PickProfessionalProviderLayout(
                                                        customSlot: mySLot,
                                                      ));
                                                },
                                                text: 'Provider and price',
                                                backColor: Colors.transparent,
                                                titleColor: mainBlueColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultButton(
                                          onClick: () {
                                            Navigator.pop(context);
                                          },
                                          text: 'Cancel',
                                          backColor: softBlueColor,
                                          borderColor: softBlueColor,
                                          titleColor: mainBlueColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Color.fromRGBO(1, 112, 204, 1),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Edit',
                          textAlign: TextAlign.center,
                          style: mainStyle(context, 13, color: mainBlueColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// enum AppointmentStatus{
//  Canceled,Confirmed,Rescheduled,Occured
// }
