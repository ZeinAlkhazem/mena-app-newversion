import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/auth_screens/pick_user_type_layout.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/main_cubit/main_cubit.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/config_model.dart';
import '../../models/api_model/home_section_model.dart';
import 'cubit/auth_state.dart';

class SpecializationInformationLayout extends StatefulWidget {
  const SpecializationInformationLayout(
      {Key? key,
      required this.type,
      required this.fullName,
      required this.email,
      required this.pass,
      required this.userName})
      : super(key: key);

  final String type;
  final String fullName;
  final String email;
  final String pass;
  final String userName;

  @override
  State<SpecializationInformationLayout> createState() => _SpecializationInformationLayoutState();
}

class _SpecializationInformationLayoutState extends State<SpecializationInformationLayout> {
  List<MenaPlatform>? platforms;

  TextEditingController registrationNumCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    platforms = MainCubit.get(context).configModel!.data.platforms;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultOnlyLogoAppbar(
          withBack: true,
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: defaultHorizontalPadding,
                right: defaultHorizontalPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Lottie.asset('assets/json/information.json', height: 0.15.sh),
                    Text('Specialization Information', style: mainStyle(context, 20, isBold: true)),
                    heightBox(22),
                    Text(
                      'To proceed,\nplease select a specific specialization',
                      style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    // heightBox(5.h),
                    // Text('tmp ${widget.type}'),
                    heightBox(22),

                    ///
                    /// select platform shared for both provider and client
                    /// in client it's name will change
                    ///
                    SizedBox(
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0.h),
                            child: Container(
                              width: double.infinity,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: newLightGreyColor,
                                borderRadius: BorderRadius.circular(5.0.sp),
                                border: Border.all(width: 0.5, color: mainBlueColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: Center(
                                  child:
                                      //     DefaultButton(
                                      //   text: 'select interests',
                                      //   customChild: Padding(
                                      //     padding: const EdgeInsets
                                      //             .symmetric(
                                      //         horizontal: 11.0),
                                      //     child: Row(
                                      //       children: [
                                      //         Text(
                                      //           'Select interests',
                                      //           style: mainStyle(
                                      //               context, 12,
                                      //               color:
                                      //                   mainBlueColor),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      //   backColor: Colors.white,
                                      //   titleColor: mainBlueColor,
                                      //   width: double.maxFinite,
                                      //   onClick: () async {
                                      //     await showDialog(
                                      //       context: context,
                                      //       builder: (ctx) {
                                      //         return MultiSelectDialog<
                                      //             MenaPlatform>(
                                      //           items: platforms!
                                      //               .map((e) =>
                                      //                   MultiSelectItem<
                                      //                           MenaPlatform>(
                                      //                       e, e.name!))
                                      //               .toList(),
                                      //           initialValue: authCubit
                                      //                   .selectedPlatform ??
                                      //               [],
                                      //           // onSelectionChanged:,
                                      //
                                      //           searchable: true,
                                      //           height: 0.4.sh,
                                      //           width: double.maxFinite,
                                      //           onConfirm: (List<
                                      //                   MenaPlatform>
                                      //               selectedValues) {
                                      //             authCubit
                                      //                 .updateSelectedPlatform(
                                      //                     selectedValues,
                                      //                     widget.type ==
                                      //                         'provider');
                                      //           },
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      // )
                                      ///
                                      DropdownButton<MenaPlatform>(
                                    value: authCubit.selectedPlatform,
                                    isDense: false,
                                    borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                    isExpanded: true,
                                    icon: SvgPicture.asset(
                                      'assets/svg/icons/arrow_down_base.svg',
                                      width: 18.sp,
                                      color: newDarkGreyColor,
                                      height: 18.sp,
                                    ),
                                    elevation: 1,
                                    menuMaxHeight: 0.5.sh,
                                    style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (MenaPlatform? newValue) {
                                      authCubit.updateSelectedPlatform(newValue!, widget.type == 'provider');
                                      logg(newValue.name.toString());
                                    },
                                    items: <MenaPlatform>[...platforms!]
                                        .map<DropdownMenuItem<MenaPlatform>>((MenaPlatform value) {
                                      return DropdownMenuItem<MenaPlatform>(
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
                              left: getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                  ? defaultHorizontalPadding * 0.7
                                  : null,
                              right: getTranslatedStrings(context).currentLanguageDirection == 'rtl'
                                  ? defaultHorizontalPadding * 0.7
                                  : null,
                              child: Container(
                                height: 16.h,
                                color: newLightGreyColor,
                                child: IconLabelInputWidget(
                                  svgAssetLink: 'assets/svg/icons/yourplatform.svg',
                                  labelText: widget.type == 'provider'
                                      ? 'Select platform'
                                      : getTranslatedStrings(context).interests,
                                ),
                              ))
                        ],
                      ),
                    ),
                    heightBox(2.h),

                    ///
                    ///
                    /// provider type
                    /// Column filter for only provider type
                    ///
                    widget.type.toLowerCase() == 'provider'
                        ? authCubit.platformCategory == null
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
                                                        color: newLightGreyColor,
                                                        border: Border.all(width: 0.5, color: mainBlueColor),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 28),
                                                        child: Center(
                                                          child: DropdownButton<MenaCategory>(
                                                            value: authCubit.selectedMenaCategory,
                                                            isDense: false,
                                                            isExpanded: true,
                                                            icon: SvgPicture.asset(
                                                              'assets/svg/icons/arrow_down_base.svg',
                                                              width: 18.sp,
                                                              color: newDarkGreyColor,
                                                              height: 18.sp,
                                                            ),
                                                            elevation: 2,
                                                            borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                                            menuMaxHeight: 0.5.sh,

                                                            style: mainStyle(context, 12,
                                                                color: newDarkGreyColor, weight: FontWeight.w700),
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
                                                      left: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'ltr'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      right: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'rtl'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      child: Container(
                                                        height: 16.h,
                                                        color: newLightGreyColor,
                                                        child: IconLabelInputWidget(
                                                          svgAssetLink: 'assets/svg/icons/yourplatform.svg',
                                                          labelText: 'Select Category Type',
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
                                                        color: newLightGreyColor,
                                                        border: Border.all(width: 0.5, color: mainBlueColor),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 28),
                                                        child: Center(
                                                          child: DropdownButton<MenaCategory>(
                                                            value: authCubit.selectedSubMenaCategory,
                                                            isDense: false,
                                                            isExpanded: true,
                                                            icon: SvgPicture.asset(
                                                              'assets/svg/icons/arrow_down_base.svg',
                                                              width: 18.sp,
                                                              color: newDarkGreyColor,
                                                              height: 18.sp,
                                                            ),
                                                            elevation: 2,
                                                            menuMaxHeight: 0.5.sh,
                                                            borderRadius: BorderRadius.all(Radius.circular(14.r)),

                                                            style: mainStyle(context, 12,
                                                                color: newDarkGreyColor, weight: FontWeight.w700),
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
                                                      left: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'ltr'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      right: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'rtl'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      child: Container(
                                                        height: 16.h,
                                                        color: newLightGreyColor,
                                                        child: IconLabelInputWidget(
                                                          svgAssetLink: 'assets/svg/icons/yourplatform.svg',
                                                          labelText: 'Select Category',
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
                                                        color: newLightGreyColor,
                                                        border: Border.all(width: 0.5, color: mainBlueColor),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                                        child: Center(
                                                            child: DefaultButton(
                                                          text: 'select interests',
                                                          borderColor: Colors.transparent,
                                                          customChild: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 11.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Select interests',
                                                                  style: mainStyle(context, 12,
                                                                      color: newDarkGreyColor, weight: FontWeight.w700),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          backColor: newLightGreyColor,
                                                          titleColor: mainBlueColor,
                                                          width: double.maxFinite,
                                                          onClick: () async {
                                                            await showModalBottomSheet(
                                                              isScrollControlled: true,
                                                              // required for min/max child size
                                                              context: context,
                                                              // constraints: BoxConstraints(maxHeight: 0.5.sh,minHeight: 0.5.sh),
                                                              builder: (ctx) {
                                                                return SafeArea(
                                                                  child: MultiSelectBottomSheet<MenaCategory>(
                                                                    items: authCubit.selectedSubMenaCategory.childs!
                                                                        .map((e) =>
                                                                            MultiSelectItem<MenaCategory>(e!, e.name!))
                                                                        .toList(),
                                                                    // maxChildSize: 0.5.sh,

                                                                    initialValue: authCubit.selectedSpecialities ?? [],
                                                                    // onSelectionChanged:,
                                                                    searchable: true,

                                                                    // backgroundColor: newLightGreyColor,
                                                                    // height: 0.4.sh,
                                                                    // width: double.maxFinite,
                                                                    onConfirm: (List<MenaCategory> selectedValues) {
                                                                      authCubit.updateSelectedSpecialities(
                                                                        selectedValues,
                                                                      );
                                                                    },
                                                                  ),
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
                                                      left: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'ltr'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      right: getTranslatedStrings(context).currentLanguageDirection ==
                                                              'rtl'
                                                          ? defaultHorizontalPadding * 0.7
                                                          : null,
                                                      child: Container(
                                                        height: 16.h,
                                                        color: newLightGreyColor,
                                                        child: IconLabelInputWidget(
                                                          svgAssetLink: 'assets/svg/icons/yourplatform.svg',
                                                          labelText: widget.type == 'provider'
                                                              ? 'Select Specialties'
                                                              : getTranslatedStrings(context).interests,
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),

                                      /// view selected specialities as a horizontal list
                                      authCubit.selectedSpecialities!.isEmpty
                                          ? SizedBox()
                                          : SizedBox(
                                              height: 45.h,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(bottom: 10.h),
                                                itemBuilder: (context, index) => DefaultContainer(
                                                    backColor: mainBlueColor,
                                                    childWidget: Center(
                                                        child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text(
                                                        authCubit.selectedSpecialities![index].name!,
                                                        style: mainStyle(context, 10,
                                                            color: Colors.white, weight: FontWeight.w700),
                                                      ),
                                                    ))),
                                                separatorBuilder: (context, index) => widthBox(5.w),
                                                itemCount: authCubit.selectedSpecialities!.length,
                                              )),
                                      state is AuthLoadingState
                                          ? const DefaultLoaderGrey()
                                          : DefaultInputField(
                                              label:'Registration number',
                                              controller: registrationNumCont,
                                              // autoValidateMode: authCubit.autoValidateMode,
                                              // onFieldChanged: (val){
                                              //   formKey.currentState.
                                              // },
                                              // validate: normalInputValidate(context),
                                              // labelWidget: IconLabelInputWidget(
                                              //   svgAssetLink: 'assets/svg/icons/full name.svg',
                                              //   labelText: widget.type.toLowerCase() == 'provider'
                                              //       ? getTranslatedStrings(context).legalFullName
                                              //       : getTranslatedStrings(context).fullName,
                                              // ),
                                              suffixIcon: NoteWidget(
                                                customColor: mainBlueColor,
                                                content: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text:
                                                        'If you are a licensed professional, provide your full legal name as identification; if you represent a facility, provide the full trade license name.',
                                                    style: mainStyle(
                                                      context,
                                                      12,
                                                      color: newDarkGreyColor,
                                                      weight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ])),
                                              ),
                                            ),
                                      heightBox(10.h),
                                      DefaultButton(
                                          text: 'Register',
                                          onClick: () {
                                            if (true) {
                                              authCubit.userRegister(
                                                fullName: widget.fullName,
                                                email: widget.email,
                                                pass: widget.pass,
                                                userName: widget.userName,
                                                providerType: widget.type,
                                                registrationNumCont: registrationNumCont.text,

                                                /// -1 is client
                                                context: context,
                                              );
                                            } else {
                                              logg('selected specialities empty');
                                              showMyAlertDialog(context, 'ALert',
                                                  alertDialogContent: Text('Please select your speciality'));
                                            }
                                          }),
                                      heightBox(10.h),
                                      AgreeTerms(byText: 'Pressing register'),
                                      heightBox(25.h),
                                      // Column(
                                      //   children: [
                                      //     const ContinueGuestButton(),
                                      //     heightBox(20.h),
                                      //     Text(
                                      //       getTranslatedStrings(context).copyRight,
                                      //       style: mainStyle(context, 9, weight: FontWeight.w800),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
