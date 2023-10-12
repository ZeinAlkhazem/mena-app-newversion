import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/insurance_providers_model.dart';
import 'package:mena/modules/appointments/appointments_layouts/book_appointment_form.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import 'appointment_calendar_layout.dart';
import 'appointments_facilities_result.dart';
import 'appointments_providers_result.dart';

class PickAppointmentInsuranceLayout extends StatefulWidget {
  const PickAppointmentInsuranceLayout(
      {Key? key, required this.searchingBy, this.customProvider, this.searchKey})
      : super(key: key);

  final SearchingBy searchingBy;
  final String? searchKey;
  final User? customProvider;

  @override
  State<PickAppointmentInsuranceLayout> createState() =>
      _PickAppointmentInsuranceLayoutState();
}

class _PickAppointmentInsuranceLayoutState extends State<PickAppointmentInsuranceLayout> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.searchingBy == SearchingBy.filters) {
      AppointmentsCubit.get(context)
          .getInsuranceList(context, user: widget.customProvider)
          .then((value) {
        AppointmentsCubit.get(context).resetSelectedInsurance();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appointmentCubit = AppointmentsCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Back',
          suffix: GestureDetector(
            onTap: () {
              AppointmentsCubit.get(context).resetSelectedInsurance();
              if (widget.searchingBy == SearchingBy.filters) {
                appointmentCubit.updateSelectedProfessionalId(null);
                appointmentCubit.updateSelectedFacilityId(null);
                appointmentCubit
                    .searchForProfessionalsFacilities(
                        searchKey: widget.searchingBy == SearchingBy.filters
                            ? null
                            : widget.searchKey,
                        providerId: null,

                        /// on start
                        facilityId: null,

                        /// on start
                        specialities: widget.searchingBy == SearchingBy.filters
                            ? AuthCubit.get(context)
                                .selectedSpecialities
                                ?.map((e) => e.id.toString())
                                .toList()
                            : null,
                        specialityGroups: widget.searchingBy == SearchingBy.filters
                            ? [AuthCubit.get(context).selectedSubMenaCategory.id.toString()]
                            : null,
                        insuranceProviders: appointmentCubit.selectedInsurance)
                    .then((value) {
                  if (appointmentCubit.type == ViewType.professional) {
                    navigateTo(
                        context,
                        AppointmentProfessionalsResults(
                          searchingBy: widget.searchingBy,
                          selectedFacilityId: null,
                          searchKey: null,
                          selectedInsuranceIds: appointmentCubit.selectedInsurance,
                          selectedSpecs: AuthCubit.get(context)
                              .selectedSpecialities
                              ?.map((e) => e.id.toString())
                              .toList(),
                          selectedSpecGroups: [
                            AuthCubit.get(context).selectedSubMenaCategory.id.toString()
                          ],
                        ));
                  } else {
                    navigateTo(
                        context,
                        AppointmentFacilitiesResults(
                          searchingBy: widget.searchingBy,
                          selectedProfessionalId: null,
                          searchKey: null,
                          selectedInsuranceIds: appointmentCubit.selectedInsurance,
                          selectedSpecs: AuthCubit.get(context)
                              .selectedSpecialities
                              ?.map((e) => e.id.toString())
                              .toList(),
                          selectedSpecGroups: [
                            AuthCubit.get(context).selectedSubMenaCategory.id.toString()
                          ],
                        ));
                  }
                });
              } else {
                /// searching by search so provider and facility selected so navigate to calendar
                navigateTo(context, AppointmentCalendarLayout());
              }
            },
            child: AppBarSkip(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return state is GettingInsuranceList
                  ? DefaultLoaderGrey()
                  : appointmentCubit.insuranceProvidersModel == null
                      ? EmptyListLayout()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppointmentHeader(
                              title: 'Choose your insurance provider.',
                              image: 'assets/svg/icons/gif.svg',
                            ),
                            heightBox(10.h),
                            // Text(
                            //   '***You are searching by: ${widget.searchingBy}',
                            //   style: mainStyle(context, 10),
                            // ),
                            // Container(),
                            Expanded(
                              child: appointmentCubit.filteredInsurancesProviders.isEmpty
                                  ? EmptyListLayout()
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        heightBox(15.h),
                                        SearchContainer(
                                          text: 'Search Insurance provider',
                                          searchCont: searchController,
                                          onSearchClicked: () {
                                            if (searchController.text.length > 3) {
                                            } else {
                                              /// <3 add characters

                                              appointmentCubit
                                                  .updateFilteredInsurancesProviders(
                                                      searchController.text);
                                              logg('please write at least 3 characters');
                                            }
                                          },
                                          onFieldChanged: (val) {
                                            appointmentCubit
                                                .updateFilteredInsurancesProviders(val);
                                          },
                                        ),
                                        heightBox(22.h),
                                        Text(
                                          'Choose from list bellow',
                                          style: mainStyle(context, 12,
                                              textHeight: 1.6, letterSpacing: 0),
                                        ),
                                        heightBox(10.h),
                                        Expanded(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                InsuranceSelectorItem(
                                                    insuranceProvider: appointmentCubit
                                                        .filteredInsurancesProviders[index],
                                                    isSelected: appointmentCubit
                                                        .selectedInsurance
                                                        .contains(appointmentCubit
                                                            .filteredInsurancesProviders[index]
                                                            .id
                                                            .toString()),
                                                    callBack: () {
                                                      appointmentCubit
                                                          .updateSelectedInsurances(
                                                              appointmentCubit
                                                                  .filteredInsurancesProviders[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                    }),
                                            separatorBuilder: (c, i) => heightBox(7.h),
                                            itemCount: appointmentCubit
                                                .filteredInsurancesProviders.length,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                              child: DefaultButton(
                                  text: 'Next',
                                  onClick: () {
                                    if (widget.searchingBy == SearchingBy.filters) {
                                      appointmentCubit.updateSelectedProfessionalId(null);
                                      appointmentCubit.updateSelectedFacilityId(null);
                                      appointmentCubit
                                          .searchForProfessionalsFacilities(
                                              searchKey:
                                                  widget.searchingBy == SearchingBy.filters
                                                      ? null
                                                      : widget.searchKey,
                                              providerId: null,

                                              /// on start
                                              facilityId: null,

                                              /// on start
                                              specialities:
                                                  widget.searchingBy == SearchingBy.filters
                                                      ? AuthCubit.get(context)
                                                          .selectedSpecialities
                                                          ?.map((e) => e.id.toString())
                                                          .toList()
                                                      : null,
                                              specialityGroups:
                                                  widget.searchingBy == SearchingBy.filters
                                                      ? [
                                                          AuthCubit.get(context)
                                                              .selectedSubMenaCategory
                                                              .id
                                                              .toString()
                                                        ]
                                                      : null,
                                              insuranceProviders:
                                                  appointmentCubit.selectedInsurance)
                                          .then((value) {
                                        if (appointmentCubit.type == ViewType.professional) {
                                          navigateTo(
                                              context,
                                              AppointmentProfessionalsResults(
                                                searchingBy: widget.searchingBy,
                                                searchKey: null,
                                                selectedFacilityId: null,
                                                selectedInsuranceIds:
                                                    appointmentCubit.selectedInsurance,
                                                selectedSpecs: AuthCubit.get(context)
                                                    .selectedSpecialities
                                                    ?.map((e) => e.id.toString())
                                                    .toList(),
                                                selectedSpecGroups: [
                                                  AuthCubit.get(context)
                                                      .selectedSubMenaCategory
                                                      .id
                                                      .toString()
                                                ],
                                              ));
                                        } else {
                                          navigateTo(
                                              context,
                                              AppointmentFacilitiesResults(
                                                searchingBy: widget.searchingBy,
                                                searchKey: null,
                                                selectedProfessionalId: null,
                                                selectedInsuranceIds:
                                                    appointmentCubit.selectedInsurance,
                                                selectedSpecs: AuthCubit.get(context)
                                                    .selectedSpecialities
                                                    ?.map((e) => e.id.toString())
                                                    .toList(),
                                                selectedSpecGroups: [
                                                  AuthCubit.get(context)
                                                      .selectedSubMenaCategory
                                                      .id
                                                      .toString()
                                                ],
                                              ));
                                        }
                                      });
                                    } else {
                                      /// searching by search so provider and facility selected so navigate to calendar
                                      navigateTo(context, AppointmentCalendarLayout());
                                    }
                                  }),
                            )
                          ],
                        );
            },
          ),
        ),
      ),
    );
  }
}

class AppBarSkip extends StatelessWidget {
  const AppBarSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Skip',
          style: mainStyle(context, 12, weight: FontWeight.w700),
        ),
        widthBox(2.w),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12.sp,
        ),
        widthBox(2.w),
      ],
    );
  }
}

Widget InsuranceSelectorItem(
    {required Function()? callBack,
    required InsuranceProvider insuranceProvider,
    required bool isSelected}) {
  return GestureDetector(
    onTap: callBack,
    child: DefaultContainer(
      radius: 5.sp,
      width: double.maxFinite,
      borderColor: !isSelected ? newLightTextGreyColor : mainBlueColor.withOpacity(0.7),
      childWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
        child: Row(
          children: [
            DefaultImageFadeInOrSvg(
              backGroundImageUrl: insuranceProvider.logo,
              height: 0.081.sw,
              width: 0.081.sw,
              boxFit: BoxFit.contain,
            ),
            widthBox(10.w),
            Expanded(child: Text(insuranceProvider.name)),
          ],
        ),
      ),
    ),
  );
}

enum SearchingBy { filters, search }
