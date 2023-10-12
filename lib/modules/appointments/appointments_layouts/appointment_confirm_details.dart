import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';

import 'appointment_saved_success.dart';
import 'book_appointment_form.dart';

class AppointmentConfirmDetailsLayout extends StatelessWidget {
  const AppointmentConfirmDetailsLayout({Key? key}) : super(key: key);

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

          if (state is SuccessSaveAppointmentState) {
            navigateTo(
              context,
              AppointmentSavedSuccess(),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('data'),
                        AppointmentHeader(
                          title: 'Confirm the details of your appointment',
                          image: 'assets/svg/icons/gif.svg',
                        ),

                        heightBox(10.h),
                        TableRowKeyVal(
                          myKey: 'Booking Date & Time',
                          val: getFormattedDate(
                              appointmentCubit.selectedDateTimeSlot!.dateTime),
                        ),
                        Divider(
                          thickness: 2,
                          height: 5.h,
                        ),
                        TableRowKeyVal(
                          myKey: 'Legal Full Name',
                          val: appointmentCubit.fNameVal ?? '-',
                        ),
                        TableRowKeyVal(
                          myKey: 'Date of Birth',
                          val: appointmentCubit.dobVal ?? '-',
                        ),
                        // TableRowKeyVal(
                        //   myKey: 'Location',
                        //   val: 'Location',
                        // ),
                        TableRowKeyVal(
                          myKey: 'Facility Name',
                          val: appointmentCubit.selectedFacilityId ?? '-',
                        ),
                        TableRowKeyVal(
                          myKey: 'Appointment with',
                          val: appointmentCubit.selectedProfessionalId ?? '-',
                        ),
                        TableRowKeyVal(
                          myKey: 'Appointment type',
                          val: appointmentCubit.selectedAppointmentType!.title,
                        ),
                        TableRowKeyVal(
                          myKey: 'Insurance provider',
                          val: appointmentCubit.selectedInsurance.isEmpty
                              ? '-'
                              : appointmentCubit.selectedInsurance
                                  .map((e) => e.toString())
                                  .toString(),
                        ),
                        TableRowKeyVal(
                          myKey: 'Mobile No',
                          val: appointmentCubit.mobileVal ?? '-',
                        ),
                        TableRowKeyVal(
                          myKey: 'E-mail',
                          val: appointmentCubit.emailVal ?? '-',
                        ),
                        Divider(
                          thickness: 2,
                          height: 5.h,
                        ),
                        TableRowKeyVal(
                          keySvg: 'assets/svg/icons/fee.svg',
                          myKey: 'Fee',
                          val: appointmentCubit.selectedDateTimeSlot!.fees ?? '-',
                        ),
                        TableRowKeyVal(
                          keySvg: 'assets/svg/icons/date.svg',
                          myKey: 'Date',
                          val: getFormattedDateOnlyDate(
                              appointmentCubit.selectedDateTimeSlot!.dateTime),
                        ),
                        TableRowKeyVal(
                          keySvg: 'assets/svg/icons/alarm clock time.svg',
                          myKey: 'Time',
                          val: getFormattedDateOnlyTime(
                              appointmentCubit.selectedDateTimeSlot!.dateTime),
                        ),
                      ],
                    ),
                  ),
                ),
                state is SavingAppointmentState
                    ? DefaultLoaderGrey()
                    : DefaultButton(
                        text: 'Confirm appointment',
                        onClick: () {
                          appointmentCubit.confirmAndSaveAppointment().then((value) {});
                        },
                      ),
              ],
            ),
          );
        },
      )),
    );
  }
}

class TableRowKeyVal extends StatelessWidget {
  const TableRowKeyVal({
    super.key,
    required this.myKey,
    required this.val,
    this.keySvg,
    this.valCallback,
  });

  final String myKey;
  final String val;
  final String? keySvg;
  final Function()? valCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (keySvg != null)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      keySvg!,
                      height: 13.h,
                    ),
                  ),
                Text(
                  myKey,
                  style: mainStyle(context, 12, weight: FontWeight.w400),
                ),
              ],
            ),
            GestureDetector(
              onTap: valCallback,
              child: Container(
                constraints: BoxConstraints(maxWidth: 0.55.sw),
                child: Text(
                  val,
                  textAlign: TextAlign.end,
                  style: mainStyle(context, 12,
                      weight: FontWeight.w700,
                      color: valCallback == null ? null : mainBlueColor,
                      decoration: valCallback == null ? null : TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
