import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/appointments/appointments_layouts/status_layout.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import 'appointment_confirm_details.dart';
import 'book_appointment_form.dart';

class ConfirmCreateAppointmentSlot extends StatelessWidget {
  const ConfirmCreateAppointmentSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultBackTitleAppBar(title: 'Back')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              AppointmentHeader(
                title: 'Confirm the details of your appointment',
                image: 'assets/svg/icons/gif.svg',
              ),
              heightBox(10.h),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableRowKeyVal(
                      myKey: 'Creating date',
                      val: '${getFormattedDateWithDayName(DateTime.now())}',
                    ),
                    // TableRowKeyVal(
                    //   myKey: 'Slot Days',
                    //   val: '${appointmentCubit.selectedSlotPickDays}',
                    // ),
                    // TableRowKeyVal(
                    //   myKey: 'Slot Times',
                    //   val: '${appointmentCubit.slotTimeRanges.map((e) => '${getFormattedDateOnlyTime(e.from)} - ${getFormattedDateOnlyTime(e.to)}\n')}',
                    // ),
                    Divider(
                      thickness: 1.5,
                      height: 40.h,
                    ),
                    TableRowKeyVal(
                      myKey: 'Slot type',
                      val: appointmentCubit.selectedAppTypeModelItem!.title,
                    ),
                    // TableRowKeyVal(
                    //   myKey: 'Location',
                    //   val: 'Location',
                    // ),
                    TableRowKeyVal(
                      myKey: 'Facility',
                      val: appointmentCubit.selectedSlotFacilityProf!.fullName!,
                    ),
                    Divider(
                      thickness: 1.5,
                      height: 40.h,
                    ),
                    TableRowKeyVal(
                      myKey: 'Fee',
                      keySvg: 'assets/svg/icons/fee.svg',
                      val: appointmentCubit.freeVal ? 'Free' : appointmentCubit.feesVal,
                    ),
                    TableRowKeyVal(
                      myKey: 'Days',
                      keySvg: 'assets/svg/icons/date.svg',
                      val: appointmentCubit.selectedSlotPickDays
                          .map((e) => '${getFormattedDateOnlyDayName(e)}\n')
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')
                          .replaceAll(',', '\n')
                          .replaceAll(' ', ''),
                    ),
                    // TableRowKeyVal(
                    //   myKey: 'DaysNum',
                    //   keySvg: 'assets/svg/icons/date.svg',
                    //   val: appointmentCubit.selectedSlotPickDays
                    //       .map((e) => '${getWeekDayOrder(getFormattedDateOnlyDayName(e))}/')
                    //       .toString()
                    //       .replaceAll('(', '')
                    //       .replaceAll(')', '')
                    //       .replaceAll(',', '')
                    //       .replaceAll(' ', ''),
                    // ),
                    TableRowKeyVal(
                      myKey: 'Time',
                      keySvg: 'assets/svg/icons/alarm clock time.svg',
                      val: appointmentCubit.slotTimeRanges
                          .map((e) =>
                              '${getFormattedDateOnlyTime(e.from)} - ${getFormattedDateOnlyTime(e.to)}\n')
                          .toString()
                          .replaceAll('(', '')
                          .replaceAll(')', '')
                          .replaceAll(',', '\n')
                          .replaceAll(' ', ''),
                    ),
                  ],
                ),
              )),
              BlocConsumer<AppointmentsCubit, AppointmentsState>(
                listener: (context, state) {
                  // TODO: implement listener

                  if( state is SuccessConfirmingSlotState){
                    navigateToAndFinish(context, StatusLayout(status: StatusEnum.successSavingSlot));
                  }
                },
                builder: (context, state) {
                  return state is ConfirmingSlotState
                      ? DefaultLoaderColor()
                      : DefaultButton(
                          text: 'Confirm',
                          onClick: () {
                            // logg('appointmentCubit.confirmSlot();');
                            appointmentCubit.confirmSlot();
                          });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
enum StatusEnum{
  successSavingSlot,
  successUpdatingSlot,
  confirmAppointment,
  rescheduleAppointment,
  canceledAppointment,
}