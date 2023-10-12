import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/appointments_layouts/confirm_details_of_your_appointment_slot.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';

import '../../../core/shared_widgets/shared_widgets.dart';

class StatusLayout extends StatelessWidget {
  const StatusLayout(
      {Key? key, required this.status, this.backToHome = true, this.customCallBack})
      : super(key: key);

  final StatusEnum status;
  final bool backToHome;
  final Function()? customCallBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  status == StatusEnum.confirmAppointment
                      ? 'assets/svg/icons/appointment_success.svg'
                      : status == StatusEnum.rescheduleAppointment
                          ? 'assets/svg/icons/appointment_rescheduled.svg'
                          : status == StatusEnum.canceledAppointment
                              ? 'assets/svg/icons/appointment_canceled.svg'
                              : 'assets/svg/icons/gif.svg',
                  height: 55.h,
                ),
                heightBox(20.h),
                Text(
                  status == StatusEnum.successSavingSlot
                      ? 'Your scheduled slot has been added to the MENA appointment system and is now visible to the relevant parties.'
                      : status == StatusEnum.successUpdatingSlot
                          ? 'Slot has been updated in MENA appointment system and is now visible to the relevant parties.'
                          : status == StatusEnum.confirmAppointment
                              ? 'Appointment Confirmed'
                              : status == StatusEnum.rescheduleAppointment
                                  ? 'appointment Rescheduled'
                                  : status == StatusEnum.canceledAppointment
                                      ? 'Appointment Cancelled'
                                      : '',
                  textAlign: TextAlign.center,
                  style: mainStyle(context, 14, weight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                heightBox(66.h),
                DefaultButton(
                  text: 'Done',
                  onClick: () {
                    if (backToHome) {
                      navigateBackToHome(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  radius: 5.sp,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
