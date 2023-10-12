import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/appointments_layouts/confirm_details_of_your_appointment_slot.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'package:mena/modules/appointments/appointments_layouts/status_layout.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';
import 'package:mena/modules/messenger/chat_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/client_appointments_model.dart';
import '../../platform_provider/provider_home/provider_profile.dart';
import 'appointment_confirm_details.dart';

class AppointmentDetailsLayout extends StatelessWidget {
  const AppointmentDetailsLayout({Key? key, required this.appointmentItem}) : super(key: key);

  final AppointmentItemModel appointmentItem;

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
            return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding, vertical: defaultHorizontalPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: appointmentItem.userData == null
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          navigateTo(
                                              context,
                                              ChatLayout(
                                                user: appointmentItem.userData,
                                              ));
                                        },
                                        child: DefaultContainer(
                                          backColor: softBlueColor,
                                          radius: 5,
                                          withoutBorder: true,
                                          childWidget: Padding(
                                            padding: EdgeInsets.all(10.0.sp),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/icons/messages.svg',
                                                ),
                                                widthBox(8.w),
                                                Expanded(
                                                  child: Text(
                                                    'Chat with ${appointmentItem.userData!.fullName}',
                                                    style: mainStyle(context, 11,
                                                        color: mainBlueColor,
                                                        weight: FontWeight.w700),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                      widthBox(10.w),
                                      Expanded(
                                          child: DefaultContainer(
                                        backColor: softBlueColor,
                                        radius: 5,
                                        withoutBorder: true,
                                        childWidget: Padding(
                                          padding: EdgeInsets.all(10.0.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svg/icons/video camera 24.svg',
                                              ),
                                              widthBox(8.w),
                                              Expanded(
                                                child: Text(
                                                  'Call Client – Video',
                                                  style: mainStyle(context, 11,
                                                      color: mainBlueColor,
                                                      weight: FontWeight.w700),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),

                                  // heightBox(13.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Divider(
                                      thickness: 1.5,
                                      height: 33.h,
                                    ),
                                  ),
                                  TableRowKeyVal(
                                    myKey: 'Client name',
                                    val: appointmentItem.fullName,
                                  ),
                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Date of Birth',
                                    val: getFormattedDateOnlyDate(appointmentItem.birthdate),
                                  ),
                                  // heightBox(7.h),
                                  // TableRowKeyVal(
                                  //   myKey: 'Location',
                                  //   val: appointmentItem.facilityData.fullName,
                                  // ),
                                  appointmentItem.professionalData == null
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            heightBox(7.h),
                                            TableRowKeyVal(
                                              myKey: 'Professional name',
                                              val: appointmentItem.professionalData == null
                                                  ? 'null'
                                                  : appointmentItem
                                                          .professionalData!.fullName ??
                                                      '-',
                                            ),
                                          ],
                                        ),

                                  appointmentItem.facilityData == null
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            heightBox(7.h),
                                            TableRowKeyVal(
                                              myKey: 'Facility name',
                                              val: appointmentItem.facilityData == null
                                                  ? 'null'
                                                  : appointmentItem.facilityData!.fullName ??
                                                      '-',
                                            ),
                                          ],
                                        ),

                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Appointment type',
                                    val: appointmentCubit
                                        .getLocalAppointmentParam(appointmentItem
                                            .appointmentSlotData.appointmentTypeData.type)
                                        .name,
                                  ),
                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Fee',
                                    keySvg: 'assets/svg/icons/fee.svg',
                                    val: appointmentItem.appointmentSlotData.fees,
                                  ),
                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Date',
                                    keySvg: 'assets/svg/icons/date.svg',
                                    val: getFormattedDateOnlyDate(
                                        appointmentItem.appointmentSlotData.dateTime),
                                  ),
                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Time',
                                    keySvg: 'assets/svg/icons/alarm clock time.svg',
                                    val: getFormattedDateOnlyTime(
                                        appointmentItem.appointmentSlotData.dateTime),
                                  ),
                                  // heightBox(7.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Divider(
                                      thickness: 1.5,
                                      height: 33.h,
                                    ),
                                  ),
                                  Text(
                                    'Contact',
                                    style: mainStyle(context, 14),
                                  ),
                                  heightBox(12.h),
                                  TableRowKeyVal(
                                    myKey: 'Phone',
                                    keySvg: 'assets/svg/icons/phone call.svg',
                                    val: appointmentItem.mobileNumber,
                                    valCallback: () async {
                                      Uri uri = Uri(
                                          scheme: 'tel', path: appointmentItem.mobileNumber);
                                      if (!await launchUrl(uri)) {
                                        throw 'Could not launch ${uri}';
                                      }
                                    },
                                  ),
                                  heightBox(7.h),
                                  TableRowKeyVal(
                                    myKey: 'Email',
                                    keySvg: 'assets/svg/icons/email.svg',
                                    val: appointmentItem.email,
                                    valCallback: () async {
                                      Uri uri = Uri(
                                        scheme: 'mailto',
                                        path: appointmentItem.email,
                                        query: encodeQueryParameters(<String, String>{
                                          'subject': 'Subject',
                                        }),
                                      );

                                      if (!await launchUrl(uri)) {
                                        throw 'Could not launch ${uri}';
                                      }
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                    state is UpdatingClientAppointment
                        ? DefaultLoaderColor()
                        : Row(
                            children: [
                              CustomButton(
                                text: 'Confirm',
                                fn: () {
                                  appointmentCubit
                                      .updateClientAppointmentState(
                                          appointmentItem.id.toString(), '1')
                                      .then((value) => navigateToAndFinish(
                                          context,
                                          StatusLayout(
                                              backToHome: false,
                                              status: StatusEnum.confirmAppointment)));
                                },
                                backColor: mainBlueColor,
                                textColor: Colors.white,
                              ),
                              widthBox(8.w),
                              CustomButton(
                                text: 'Reschedule',
                                fn: () {
                                  appointmentCubit
                                      .updateClientAppointmentState(
                                          appointmentItem.id.toString(), '2')
                                      .then((value) => navigateToAndFinish(
                                          context,
                                          StatusLayout(
                                              backToHome: false,
                                              status: StatusEnum.rescheduleAppointment)));
                                },
                                backColor: softBlueColor,
                                textColor: mainBlueColor,
                              ),
                              widthBox(8.w),
                              CustomButton(
                                text: 'Cancel',
                                fn: () {
                                  appointmentCubit
                                      .updateClientAppointmentState(
                                          appointmentItem.id.toString(), '3')
                                      .then((value) => navigateToAndFinish(
                                          context,
                                          StatusLayout(
                                              backToHome: false,
                                              status: StatusEnum.canceledAppointment)));
                                },
                                backColor: alertRedColor,
                                textColor: Colors.white,
                              ),
                            ],
                          )
                  ],
                ));
          },
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.fn,
    required this.backColor,
    required this.textColor,
    required this.text,
  });

  final Function()? fn;
  final Color backColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: fn,
        child: DefaultContainer(
          backColor: backColor,
          withoutBorder: true,
          radius: 5.sp,
          childWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
            child: Center(
                child: Text(
              text,
              style: mainStyle(context, 12, color: textColor),
            )),
          ),
        ),
      ),
    );
  }
}
