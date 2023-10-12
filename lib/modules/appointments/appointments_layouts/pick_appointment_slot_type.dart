import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/appointments_slots.dart';
import 'package:mena/modules/appointments/appointments_layouts/confirm_details_of_your_appointment_slot.dart';
import 'package:mena/modules/appointments/appointments_layouts/select_slot_timing.dart';
import 'package:mena/modules/appointments/appointments_layouts/status_layout.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';

import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/config_model.dart';
import '../../../models/local_models.dart';
import 'book_appointment_form.dart';

class PickAppointmentTypeInSlotLayout extends StatefulWidget {
  const PickAppointmentTypeInSlotLayout({Key? key, this.customSlot}) : super(key: key);

  final MySLot? customSlot;

  /// so edit not new
  @override
  State<PickAppointmentTypeInSlotLayout> createState() =>
      _PickAppointmentTypeInSlotLayoutState();
}

class _PickAppointmentTypeInSlotLayoutState extends State<PickAppointmentTypeInSlotLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appointmentCubit = AppointmentsCubit.get(context);

    List<AppointmentType> appointmentTypes = [];
    appointmentTypes = MainCubit.get(context).configModel!.data.appointmentTypes;

    appointmentCubit.updateAppointmentTypesToView(appointmentTypes);
    appointmentCubit
        .updateSelectedAppTypeModelItem(appointmentCubit.appointmentTypeItemsToView[0]);
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Create new slot',
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
          listener: (context, state) {
            // TODO: implement listener

            if(state is SuccessUpdatingSlotState){
              navigateTo(context, StatusLayout(status: StatusEnum.successUpdatingSlot));
              // navigateBackToHome(context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppointmentHeader(
                    title:
                        'Use the scheduling tool to select appointment, Type and dates and times when you are available.',
                    image: 'assets/svg/icons/gif.svg',
                  ),
                  heightBox(10.h),
                  Text(
                    'Select Appointment Type:',
                    style: mainStyle(context, 12, weight: FontWeight.w600),
                  ),
                  Expanded(
                      child: GridView.count(
                          padding: EdgeInsets.all(18),
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.h,
                          crossAxisSpacing: 20.w,
                          childAspectRatio: 1.3,
                          children: appointmentCubit.appointmentTypeItemsToView
                              .map((e) => AppointmentTypeItemWidget(
                                    appointmentType: e,
                                    isSelected: e == appointmentCubit.selectedAppTypeModelItem,
                                    callBack: () =>
                                        appointmentCubit.updateSelectedAppTypeModelItem(e),
                                  ))
                              .toList())),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child:
                    state is UpdatingSlotState?DefaultLoaderColor():
                    DefaultButton(
                        text: widget.customSlot == null ? 'Next' : 'Save',
                        onClick: () {
                          widget.customSlot == null
                              ? navigateTo(context, SelectSlotTimeLayout())
                              :         appointmentCubit.updateSlot(widget.customSlot!.id.toString(),UpdateVal.type);
                        }),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
enum UpdateVal{
  type,
  dateTime,
  profFacPrice,



}
class AppointmentTypeItemWidget extends StatelessWidget {
  const AppointmentTypeItemWidget(
      {super.key, required this.appointmentType, this.isSelected = false, this.callBack});

  final AppointmentType appointmentType;
  final bool isSelected;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultContainer(
        backColor: isSelected ? secBlueColor : Colors.transparent,
        borderColor: secBlueColor,
        radius: 5.sp,
        childWidget: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                          appointmentType.type == '0'
                              ? 'assets/svg/icons/online_apppointment_type.svg'
                              : 'assets/svg/icons/in-person.svg',
                          height: 24.h,
                          color: isSelected ? Colors.white : Colors.black),
                      heightBox(8.h),
                      Text(
                        appointmentType.title,
                        style: mainStyle(context, 13,
                            textHeight: 1.4, color: isSelected ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
                // if (appointmentType.title != null)
                //   Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       heightBox(4.h),
                //       Text(
                //         appointmentType.title!,
                //         style: mainStyle(context, 11,
                //             color: isSelected ? Colors.white : Colors.grey),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
