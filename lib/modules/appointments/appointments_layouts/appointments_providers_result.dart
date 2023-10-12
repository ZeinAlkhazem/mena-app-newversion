import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/appointments_layouts/appointments_facilities_result.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_insurance.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../platform_provider/provider_home/platform_provider_home.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import 'appointment_calendar_layout.dart';
import 'book_appointment_form.dart';

class AppointmentProfessionalsResults extends StatefulWidget {
  const AppointmentProfessionalsResults(
      {Key? key,
      required this.searchKey,
      this.selectedInsuranceIds,
      required this.searchingBy,
      required this.selectedFacilityId,
      this.selectedSpecs,
      this.selectedSpecGroups})
      : super(key: key);

  final SearchingBy searchingBy;
  final String? searchKey;
  final String? selectedFacilityId;
  final List<String>? selectedInsuranceIds;
  final List<String>? selectedSpecs;
  final List<String>? selectedSpecGroups;

  // if(selectedInsuranceId !=null)
  //   so we selected insurance no need to navigate to insurance
  @override
  State<AppointmentProfessionalsResults> createState() =>
      _AppointmentProfessionalsResultsState();
}

class _AppointmentProfessionalsResultsState extends State<AppointmentProfessionalsResults> {

  TextEditingController searchController = TextEditingController();


  // List<User> users=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logg('asdjbaskjdhjk');
    var appointmentsCubit = AppointmentsCubit.get(context);
    appointmentsCubit.updateSelectedProfessionalId(null);
    appointmentsCubit.searchForProfessionalsFacilities(
        searchKey: widget.searchingBy == SearchingBy.filters ? null : widget.searchKey,
        providerId: null,
        /// on start
        facilityId: widget.selectedFacilityId,
        /// on start
        specialities: widget.searchingBy == SearchingBy.filters ? AuthCubit.get(context).selectedSpecialities?.map((e) => e.id.toString()).toList() : null,
        specialityGroups:
        widget.searchingBy == SearchingBy.filters ?  [AuthCubit.get(context).selectedSubMenaCategory.id.toString()] : null,
        insuranceProviders: appointmentsCubit.selectedInsurance).then((value) {
          // users=appointmentsCubit.resultsModel!.data.users;
        }

    );




    ///
    /// get data due to (selected insurance and filter)
    /// or due to search key
    /// then set the type
    ///
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
        backgroundColor: Colors.white,
        body: BlocConsumer<AppointmentsCubit, AppointmentsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12.w,vertical: 18),
                  child: Column(
                    children: [
                      AppointmentHeader(
                        title: 'Select Professional.',
                        image: 'assets/svg/icons/gif.svg',
                      ),
                      heightBox(10.h),
                      Expanded(
                        child: state is SearchingProFacState ?DefaultLoaderColor():
                        appointmentCubit.resultsModel == null
                            ? SizedBox()
                            : Column(
                              children: [
                                heightBox(15.h),
                                SearchContainer(
                                  text: 'By professional',
                                  searchCont: searchController,
                                  onSearchClicked: () {
                                    if (searchController.text.length > 3) {
                                    } else {
                                      /// <3 add characters

                                      appointmentCubit.updateFilteredProviders(searchController.text);
                                      logg('please write at least 3 characters');
                                    }
                                  },
                                  onFieldChanged: (val){
                                    appointmentCubit.updateFilteredProviders(val);
                                  },
                                ),
                                heightBox(22.h),
                                appointmentCubit.filteredProviders.isEmpty
                                    ? EmptyListLayout()
                                    : Expanded(
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                /// if speciality selected to calendar if not to facilities
                                                ///
                                                appointmentCubit.updateSelectedProfessionalId(appointmentCubit.filteredProviders[index].id
                                                    .toString());
                                                if (appointmentCubit.selectedFacilityId != null) {
                                                  /// now 2 selected so check if from search go to insurance else to calendar
                                                  if (widget.searchingBy == SearchingBy.search) {
                                                    navigateTo(
                                                        context,
                                                        PickAppointmentInsuranceLayout(
                                                            searchingBy: SearchingBy.search));
                                                  } else {
                                                    navigateTo(context, AppointmentCalendarLayout());
                                                  }
                                                } else {
                                                  /// facility not selected yet
                                                  navigateTo(
                                                      context,
                                                      AppointmentFacilitiesResults(
                                                        searchKey: widget.searchKey,
                                                        searchingBy: widget.searchingBy,
                                                        selectedProfessionalId: appointmentCubit.filteredProviders[index].id.toString(),
                                                      ));
                                                }
                                              },
                                              child: AppointmentProviderCard(
                                                provider:appointmentCubit.filteredProviders[index],
                                                justView: true,
                                                currentLayout: null,
                                              ),
                                            );
                                          },
                                          separatorBuilder: (c, i) => heightBox(10.h),
                                          itemCount: appointmentCubit.filteredProviders.length,
                                        ),
                                    ),
                              ],
                            ),
                      ),

                      // DefaultButton(text: 'Next', onClick: (){
                      //   /// if speciality selected to calendar if not to facilities
                      //   ///
                      //   appointmentsCubit.updateSelectedProfessionalId(null);
                      //   if (appointmentsCubit.selectedFacilityId != null) {
                      //     /// now 2 selected so check if from search go to insurance else to calendar
                      //     if (widget.searchingBy == SearchingBy.search) {
                      //       navigateTo(
                      //           context,
                      //           PickAppointmentInsuranceLayout(
                      //               searchingBy: SearchingBy.search));
                      //     } else {
                      //       navigateTo(context, AppointmentCalendarLayout());
                      //     }
                      //   } else {
                      //     /// facility not selected yet
                      //     navigateTo(
                      //         context,
                      //         AppointmentFacilitiesResults(
                      //           searchKey: widget.searchKey,
                      //           searchingBy: widget.searchingBy,
                      //           selectedProfessionalId: null,
                      //         ));
                      //   }
                      // })
                    ],
                  )),
            );
          },
        ));
  }
}
