import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_insurance.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_location.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/auth_screens/cubit/auth_state.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/config_model.dart';
import '../../../models/api_model/home_section_model.dart';
import 'appointments_facilities_result.dart';
import 'appointments_providers_result.dart';

class BookAppointmentFormLayout extends StatefulWidget {
  const BookAppointmentFormLayout({Key? key, required this.currentPlatformId}) : super(key: key);

  final String currentPlatformId;

  @override
  State<BookAppointmentFormLayout> createState() => _BookAppointmentFormLayoutState();
}

class _BookAppointmentFormLayoutState extends State<BookAppointmentFormLayout> {
  List<MenaPlatform>? platforms;

  TextEditingController searchController = TextEditingController();

  bool viewMoreThan3HintText = false;

  @override
  void initState() {
    // TODO: implement initState

    platforms = MainCubit.get(context).configModel!.data.platforms;
    viewMoreThan3HintText = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context)
      ..updateSelectedPlatform(platforms!.firstWhere((element) => element.id == widget.currentPlatformId), true)
      ..toggleAutoValidate(false)
      ..togglePassVisibilityFalse()
      ..resetCategoriesFilters();

    var appointmentCubit = AppointmentsCubit.get(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Book an appointment',
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppointmentHeader(
                          title: 'Appointment Made Easy:\nStreamlining Scheduling Through Mena',
                          image: 'assets/svg/icons/gif.svg',
                        ),
                        heightBox(10.h),
                        Container(
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              border: Border.all(
                                color: Color.fromRGBO(1, 112, 204, 1),
                                width: 0.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 26.0.w),
                              child: Row(
                                children: [
                                  // Figma Flutter Generator MakeanappointmentwithyourproviderviatherevideocallcenterWidget - TEXT

                                  SvgPicture.asset('assets/svg/icons/video camera.svg'),
                                  widthBox(30.w),
                                  Expanded(
                                    child: Text(
                                      'Make an appointment with your provider via there video call center',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Visby',
                                          fontSize: 12.sp,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3666666666666667),
                                    ),
                                  )
                                ],
                              ),
                            )),
                        heightBox(36.h),
                        SearchContainer(
                          text: 'By Professionals or facility name',
                          searchCont: searchController,
                          onSearchClicked: () {
                            if (searchController.text.length >= 3) {
                              viewMoreThan3HintText = false;
                              appointmentCubit.updateSelectedProfessionalId(null);
                              appointmentCubit.updateSelectedFacilityId(null);
                              appointmentCubit
                                  .searchForProfessionalsFacilities(
                                      searchKey: searchController.text,
                                      providerId: null,

                                      /// on start
                                      facilityId: null,

                                      /// on start
                                      specialities: null,
                                      specialityGroups: null,
                                      insuranceProviders: appointmentCubit.selectedInsurance)
                                  .then((value) {
                                logg('then ...');
                                if (appointmentCubit.type == ViewType.professional) {
                                  navigateTo(
                                      context,
                                      AppointmentProfessionalsResults(
                                        searchingBy: SearchingBy.search,
                                        selectedFacilityId: null,
                                        searchKey: searchController.text,
                                        selectedInsuranceIds: appointmentCubit.selectedInsurance,
                                        selectedSpecs: null,
                                        selectedSpecGroups: null,
                                      ));
                                } else {
                                  navigateTo(
                                      context,
                                      AppointmentFacilitiesResults(
                                        searchingBy: SearchingBy.search,
                                        selectedProfessionalId: null,
                                        searchKey: searchController.text,
                                        selectedInsuranceIds: appointmentCubit.selectedInsurance,
                                        selectedSpecs: null,
                                        selectedSpecGroups: null,
                                      ));
                                }
                              });
                            } else {
                              /// <3 add characters
                              logg('please write at least 3 characters');
                              setState(() {
                                viewMoreThan3HintText = true;
                              });
                            }
                          },
                        ),
                        viewMoreThan3HintText
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text(
                                  'Please enter 3 letters at least',
                                  style: mainStyle(context, 12, color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        heightBox(44.h),
                        OrSection(),
                        heightBox(44.h),
                        Column(
                          children: [
                            ///
                            ///
                            /// context.select((SubjectBloc bloc) => bloc.state)
                            /// select platform shared for both provider and client
                            /// in client it's name will change
                            ///
                            ///
                            ///
                            // SizedBox(
                            //   child: Stack(
                            //     children: [
                            //       Padding(
                            //         padding:
                            //             EdgeInsets.symmetric(vertical: 10.0.h),
                            //         child: Container(
                            //           width: double.infinity,
                            //           height: 40.h,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //                 BorderRadius.circular(5.0.sp),
                            //             border: Border.all(
                            //                 width: 0.5, color: mainBlueColor),
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 12.0),
                            //             child: Center(
                            //               child:
                            //                   //     DefaultButton(
                            //                   //   text: 'select interests',
                            //                   //   customChild: Padding(
                            //                   //     padding: const EdgeInsets
                            //                   //             .symmetric(
                            //                   //         horizontal: 11.0),
                            //                   //     child: Row(
                            //                   //       children: [
                            //                   //         Text(
                            //                   //           'Select interests',
                            //                   //           style: mainStyle(
                            //                   //               context, 12,
                            //                   //               color:
                            //                   //                   mainBlueColor),
                            //                   //         )
                            //                   //       ],
                            //                   //     ),
                            //                   //   ),
                            //                   //   backColor: Colors.white,
                            //                   //   titleColor: mainBlueColor,
                            //                   //   width: double.maxFinite,
                            //                   //   onClick: () async {
                            //                   //     await showDialog(
                            //                   //       context: context,
                            //                   //       builder: (ctx) {
                            //                   //         return MultiSelectDialog<
                            //                   //             MenaPlatform>(
                            //                   //           items: platforms!
                            //                   //               .map((e) =>
                            //                   //                   MultiSelectItem<
                            //                   //                           MenaPlatform>(
                            //                   //                       e, e.name!))
                            //                   //               .toList(),
                            //                   //           initialValue: authCubit
                            //                   //                   .selectedPlatform ??
                            //                   //               [],
                            //                   //           // onSelectionChanged:,
                            //                   //
                            //                   //           searchable: true,
                            //                   //           height: 0.4.sh,
                            //                   //           width: double.maxFinite,
                            //                   //           onConfirm: (List<
                            //                   //                   MenaPlatform>
                            //                   //               selectedValues) {
                            //                   //             authCubit
                            //                   //                 .updateSelectedPlatform(
                            //                   //                     selectedValues,
                            //                   //                     widget.type ==
                            //                   //                         'provider');
                            //                   //           },
                            //                   //         );
                            //                   //       },
                            //                   //     );
                            //                   //   },
                            //                   // )
                            //                   ///
                            //                   DropdownButton<MenaPlatform>(
                            //                 value: authCubit.selectedPlatform,
                            //                 isDense: false,
                            //                 isExpanded: true,
                            //                 icon: SvgPicture.asset(
                            //                   'assets/svg/icons/arrow.svg',
                            //                   width: 16.sp,
                            //                   height: 16.sp,
                            //                   color: Colors.grey,
                            //                 ),
                            //                 elevation: 2,
                            //                 style: mainStyle(context, 14,
                            //                     color: mainBlueColor),
                            //                 underline: Container(
                            //                   height: 2,
                            //                   color: Colors.transparent,
                            //                 ),
                            //                 onChanged:
                            //                     (MenaPlatform? newValue) {
                            //                   authCubit.updateSelectedPlatform(
                            //                       newValue!, true);
                            //                   logg(newValue.name.toString());
                            //                 },
                            //                 items: <MenaPlatform>[...platforms!]
                            //                     .map<
                            //                             DropdownMenuItem<
                            //                                 MenaPlatform>>(
                            //                         (MenaPlatform value) {
                            //                   return DropdownMenuItem<
                            //                       MenaPlatform>(
                            //                     value: value,
                            //                     child:
                            //                         Text(value.name.toString()),
                            //                   );
                            //                 }).toList(),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Positioned(
                            //           top: 0,
                            //           left: getTranslatedStrings(context)
                            //                       .currentLanguageDirection ==
                            //                   'ltr'
                            //               ? defaultHorizontalPadding * 0.7
                            //               : null,
                            //           right: getTranslatedStrings(context)
                            //                       .currentLanguageDirection ==
                            //                   'rtl'
                            //               ? defaultHorizontalPadding * 0.7
                            //               : null,
                            //           child: Container(
                            //             height: 16.h,
                            //             color: Colors.white,
                            //             child: IconLabelInputWidget(
                            //               // svgAssetLink:
                            //               //     'assets/svg/icons/yourplatform.svg',
                            //               labelText:
                            //                   // widget.type ==
                            //                   //     'provider'
                            //                   //     ? getTranslatedStrings(
                            //                   //     context)
                            //                   //     .platform
                            //                   //     :
                            //                   getTranslatedStrings(context)
                            //                       .platform,
                            //             ),
                            //           ))
                            //     ],
                            //   ),
                            // ),
                            // heightBox(2.h),
                            ///
                            ///
                            /// provider type
                            /// Column filter for only provider type
                            ///
                            ///
                            /// heere
                            authCubit.platformCategory == null
                                ? DefaultLoaderGrey()
                                : authCubit.platformCategory == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'No provider types for this platform, We will register this account as client',
                                          style: mainStyle(context, 11, color: mainBlueColor),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          /// categories selector
                                          authCubit.platformCategory!.data.isEmpty
                                              ? SizedBox()
                                              : SizedBox(
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0.sp),
                                                            border: Border.all(width: 0.5, color: mainBlueColor),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                                            child: Center(
                                                              child: DropdownButton<MenaCategory>(
                                                                value: authCubit.selectedMenaCategory,
                                                                isDense: false,
                                                                isExpanded: true,
                                                                icon: SvgPicture.asset(
                                                                  'assets/svg/icons/arrow_down_base.svg',
                                                                  width: 16.sp,
                                                                  height: 16.sp,
                                                                  color: Colors.grey,
                                                                ),
                                                                elevation: 2,
                                                                menuMaxHeight: 0.5.sh,
                                                                style: mainStyle(context, 14, color: mainBlueColor),
                                                                underline: Container(
                                                                  height: 2,
                                                                  color: Colors.transparent,
                                                                ),
                                                                onChanged: (MenaCategory? newValue) {
                                                                  authCubit.updateSelectedMenaCategory(newValue!);
                                                                  logg(newValue.name.toString());
                                                                },
                                                                // items:
                                                                // <
                                                                //     MenaCategory>
                                                                items: authCubit.platformCategory!.data
                                                                    .map<DropdownMenuItem<MenaCategory>>(
                                                                        (MenaCategory value) {
                                                                  return DropdownMenuItem<MenaCategory>(
                                                                    value: value,
                                                                    child: Text(value.name.toString()),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 0,
                                                          left:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'ltr'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          right:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'rtl'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          child: Container(
                                                            height: 16.h,
                                                            color: Colors.white,
                                                            child: IconLabelInputWidget(
                                                              // svgAssetLink:
                                                              //     'assets/svg/icons/yourplatform.svg',
                                                              labelText: getTranslatedStrings(context).categories,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),

                                          /// sub categories selector
                                          authCubit.selectedMenaCategory.childs == null
                                              ? SizedBox()
                                              : SizedBox(
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0.sp),
                                                            border: Border.all(width: 0.5, color: mainBlueColor),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                                            child: Center(
                                                              child: DropdownButton<MenaCategory>(
                                                                value: authCubit.selectedSubMenaCategory,
                                                                isDense: false,
                                                                isExpanded: true,
                                                                menuMaxHeight: 0.5.sh,
                                                                icon: SvgPicture.asset(
                                                                  'assets/svg/icons/arrow_down_base.svg',
                                                                  width: 16.sp,
                                                                  height: 16.sp,
                                                                  color: Colors.grey,
                                                                ),
                                                                elevation: 7,
                                                                style: mainStyle(context, 14, color: mainBlueColor),
                                                                underline: Container(
                                                                  height: 2,
                                                                  color: Colors.transparent,
                                                                ),
                                                                onChanged: (MenaCategory? newValue) {
                                                                  authCubit.updateSelectedSubMenaCategory(newValue!);
                                                                  logg(newValue.name.toString());
                                                                },
                                                                // items:
                                                                // <
                                                                //     MenaCategory>
                                                                items: authCubit.selectedMenaCategory.childs!
                                                                    .map<DropdownMenuItem<MenaCategory>>(
                                                                        (MenaCategory? value) {
                                                                  return DropdownMenuItem<MenaCategory>(
                                                                    value: value,
                                                                    child: Text(value!.name.toString()),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 0,
                                                          left:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'ltr'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          right:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'rtl'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          child: Container(
                                                            height: 16.h,
                                                            color: Colors.white,
                                                            child: IconLabelInputWidget(
                                                              // svgAssetLink:
                                                              //     'assets/svg/icons/yourplatform.svg',
                                                              labelText: getTranslatedStrings(context).specialityGroup,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),

                                          /// sub sub categories .. specialities
                                          authCubit.selectedSubMenaCategory.childs == null
                                              ? SizedBox()
                                              : SizedBox(
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0.sp),
                                                            border: Border.all(width: 0.5, color: mainBlueColor),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                            child: Center(
                                                                child: DefaultButton(
                                                              text: 'Select interests',
                                                              borderColor: Colors.transparent,
                                                              customChild: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Select interests',
                                                                      style:
                                                                          mainStyle(context, 12, color: mainBlueColor),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              backColor: Colors.white,
                                                              titleColor: mainBlueColor,
                                                              width: double.maxFinite,
                                                              onClick: () async {
                                                                await showDialog(
                                                                  context: context,
                                                                  builder: (ctx) {
                                                                    return MultiSelectDialog<MenaCategory>(
                                                                      items: authCubit.selectedSubMenaCategory.childs!
                                                                          .map((e) => MultiSelectItem<MenaCategory>(
                                                                              e!, e.name!))
                                                                          .toList(),
                                                                      initialValue:
                                                                          authCubit.selectedSpecialities ?? [],
                                                                      // onSelectionChanged:,

                                                                      searchable: true,
                                                                      height: 0.4.sh,
                                                                      width: double.maxFinite,
                                                                      onConfirm: (List<MenaCategory> selectedValues) {
                                                                        authCubit.updateSelectedSpecialities(
                                                                          selectedValues,
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            )

                                                                ///
                                                                // DropdownButton<
                                                                //     MenaPlatform>(
                                                                //   value: authCubit
                                                                //       .selectedPlatform,
                                                                //   isDense: false,
                                                                //   isExpanded: true,
                                                                //   icon: SvgPicture.asset(
                                                                //     'assets/svg/icons/arrow.svg',
                                                                //     width: 18.sp,
                                                                //     height: 18.sp,
                                                                //   ),
                                                                //   elevation: 2,
                                                                //   style: mainStyle(
                                                                //       context, 14,
                                                                //       color: mainBlueColor),
                                                                //   underline: Container(
                                                                //     height: 2,
                                                                //     color: Colors.transparent,
                                                                //   ),
                                                                //   onChanged: (MenaPlatform?
                                                                //   newValue) {
                                                                //     authCubit
                                                                //         .updateSelectedPlatform(
                                                                //         newValue!,
                                                                //         widget.type ==
                                                                //             'provider');
                                                                //     logg(newValue.name
                                                                //         .toString());
                                                                //   },
                                                                //   items: <MenaPlatform>[
                                                                //     ...platforms!
                                                                //   ].map<
                                                                //       DropdownMenuItem<
                                                                //           MenaPlatform>>(
                                                                //           (MenaPlatform value) {
                                                                //         return DropdownMenuItem<
                                                                //             MenaPlatform>(
                                                                //           value: value,
                                                                //           child: Text(value.name
                                                                //               .toString()),
                                                                //         );
                                                                //       }).toList(),
                                                                // ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 0,
                                                          left:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'ltr'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          right:
                                                              getTranslatedStrings(context).currentLanguageDirection ==
                                                                      'rtl'
                                                                  ? defaultHorizontalPadding * 0.7
                                                                  : null,
                                                          child: Container(
                                                            height: 16.h,
                                                            color: Colors.white,
                                                            child: IconLabelInputWidget(
                                                              // svgAssetLink:
                                                              //     'assets/svg/icons/yourplatform.svg',
                                                              labelText: getTranslatedStrings(context).specialities,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),

                                          /// view selected specialities as a horizontal list
                                          authCubit.selectedSpecialities!.isEmpty
                                              ? SizedBox()
                                              : SizedBox(
                                                  height: 35.h,
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) => DefaultContainer(
                                                        backColor: mainBlueColor,
                                                        childWidget: Center(
                                                            child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Text(
                                                            authCubit.selectedSpecialities![index].name!,
                                                            style: mainStyle(context, 10, color: Colors.white),
                                                          ),
                                                        ))),
                                                    separatorBuilder: (context, index) => widthBox(5.w),
                                                    itemCount: authCubit.selectedSpecialities!.length,
                                                  )),
                                        ],
                                      ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: DefaultButton(
                    text: 'Next',
                    onClick: () {
                      navigateTo(
                        context,
                        PickAppointmentInsuranceLayout(
                          searchingBy: SearchingBy.filters,
                          customProvider: null, // no custom provider selected before navigating
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppointmentHeader extends StatelessWidget {
  const AppointmentHeader({
    super.key,
    required this.title,
    this.sub,
    required this.image,
  });

  final String title;
  final String? sub;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          // Image.asset(image),
          SvgPicture.asset(image),
          widthBox(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  // textAlign: TextAlign.center,
                  style: mainStyle(context, 13, textHeight: 1.4, isBold: true, color: mainBlueColor),
                ),
                if (sub != null)
                  Column(
                    children: [
                      heightBox(5.h),
                      Text(
                        sub!,
                        // textAlign: TextAlign.center,
                        style: mainStyle(context, 10, textHeight: 1.4, isBold: true, color: Colors.red),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.onSearchClicked,
    this.onFieldChanged,
    required this.searchCont,
  });

  final String text;
  final TextEditingController searchCont;
  final Function()? onSearchClicked;
  final Function(String)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      borderRadius: 44.sp,
      controller: searchCont,
      onFieldChanged: onFieldChanged,
      edgeInsetsGeometry: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 1.5, vertical: 11.h),
      label: text,
      // labelWidget: Text(
      //   text,
      //   style: mainStyle(context, 9),
      // ),
      suffixIcon: GestureDetector(
        onTap: onSearchClicked,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SvgPicture.asset('assets/svg/icons/searchFilled.svg',height: 28.h,),
        ),
      ),
    );
  }
}

class OrSection extends StatelessWidget {
  const OrSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 0.5,
          color: softGreyColor,
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR',
            style: mainStyle(context, 14, color: mainBlueColor, weight: FontWeight.w800),
          ),
        ),
        Expanded(
            child: Container(
          height: 0.5,
          color: softGreyColor,
        )),
      ],
    );
  }
}
