import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/appointments/appointments_layouts/book_appointment_form.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'package:mena/modules/appointments/appointments_layouts/status_layout.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/appointments_slots.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../home_screen/sections_widgets/sections_widgets.dart';
import '../../platform_provider/provider_home/platform_provider_home.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import 'confirm_details_of_your_appointment_slot.dart';

class PickProfessionalProviderLayout extends StatefulWidget {
  const PickProfessionalProviderLayout({Key? key, this.customSlot}) : super(key: key);

  final MySLot? customSlot;

  @override
  State<PickProfessionalProviderLayout> createState() =>
      _PickProfessionalProviderLayoutState();
}

class _PickProfessionalProviderLayoutState extends State<PickProfessionalProviderLayout> {
  TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appointmentCubit = AppointmentsCubit.get(context);
    appointmentCubit.getProvidersProfessionalForCreatingSlot();
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultBackTitleAppBar(title: 'Back')),
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
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppointmentHeader(
                    title:
                        'Let us know which location you will be at on the designated date and time.',
                    image: 'assets/svg/icons/gif.svg',
                  ),
                  heightBox(10.h),
                  Expanded(
                    child: state is GettingProfProvidersList
                        ? DefaultLoaderColor()
                        : Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select appointment Location :',
                                    style: mainStyle(context, 14),
                                  ),
                                  heightBox(7.h),
                                  SearchContainer(
                                      text: appointmentCubit.profFacilityModel!.data.type ==
                                              'facilities'
                                          ? 'By facility'
                                          : 'By professional',
                                      searchCont: searchCont),
                                ],
                              ),
                              // heightBox(10.h),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  itemBuilder: (context, index) {
                                    User provider =
                                        appointmentCubit.profFacilityModel!.data.users[index];
                                    return ProviderCard(
                                      provider: provider,
                                      customCallback: () {
                                        logg('view fees bottom sheet');
                                        appointmentCubit.updateSelectedSlotFacilityProf( appointmentCubit.profFacilityModel!.data.users[index]);
                                        viewFeesBottomSheet(context);
                                      },
                                      justView: true, currentLayout: '',
                                      // currentLayout: currentCategoryName,
                                    );
                                  },
                                  separatorBuilder: (_, index) => heightBox(10.h),
                                  itemCount:
                                      appointmentCubit.profFacilityModel!.data.users.length,
                                ),
                              ),
                            ],
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

  Future<dynamic> viewFeesBottomSheet(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // padding: MediaQuery.of(context).viewInsets,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Container(
                  height: 0.33.sh,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Fees Details :',
                            style: mainStyle(context, 14),
                          ),
                          heightBox(7.h),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.resolveWith(
                                          (states) => mainBlueColor),
                                      value: appointmentCubit.freeVal,
                                      onChanged: (bool? value) {
                                        appointmentCubit.changeFreeVal(value??false);
                                        // setState(() {
                                        //   isChecked = value!;
                                        // });
                                      },
                                    ),
                                    widthBox(7.w),
                                    Text(
                                      'Free',
                                      style: mainStyle(context, 14),
                                    )
                                  ],
                                ),
                                heightBox(4.h),
                                appointmentCubit.freeVal?
                                    SizedBox():
                                DefaultInputField(
                                  label: 'Fees',
                                  // labelWidget: Text('Fees'),
                                  onFieldChanged: (String val){
                                    appointmentCubit.updateFeesVal(val);
                                  },
                                  // readOnly: appointmentCubit.freeVal,
                                ),
                              ],
                            ),
                          ),
                        state is UpdatingSlotState?DefaultLoaderGrey():  DefaultButton(
                              text: widget.customSlot == null ? 'Next' : 'Save',
                              onClick: () {
                                widget.customSlot == null
                                    ? navigateTo(context, ConfirmCreateAppointmentSlot())
                                    : appointmentCubit.updateSlot(widget.customSlot!.id.toString(), UpdateVal.profFacPrice);
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
