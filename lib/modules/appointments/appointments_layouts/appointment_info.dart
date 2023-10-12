import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/constants/validators.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/appointments/cubit/appointments_cubit.dart';
import 'package:mena/modules/appointments/cubit/appointments_state.dart';

import 'appointments_upload_documents.dart';
import 'book_appointment_form.dart';

class AppointmentInformationLayout extends StatefulWidget {
  const AppointmentInformationLayout({Key? key}) : super(key: key);

  @override
  State<AppointmentInformationLayout> createState() => _AppointmentInformationLayoutState();
}

class _AppointmentInformationLayoutState extends State<AppointmentInformationLayout> {
  TextEditingController dobCont = TextEditingController();
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController idNumCont = TextEditingController();
  TextEditingController mobileNumCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  var formKey = GlobalKey<FormState>();

  DateTime? pickedDate;

  Future _selectDate() async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    if (pickedDate != null)
      setState(() => {
            //     data.registrationdate = picked.toString(),
            dobCont.text = getFormattedDateOnlyDate(pickedDate!).toString()
          });
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
      body: BlocConsumer<AppointmentsCubit, AppointmentsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all( 18),
            child: SafeArea(
              child: Column(
                children: [
                  AppointmentHeader(
                    title: 'Let us know who you are booking this for : '
                    ,
                    image: 'assets/svg/icons/gif.svg',
                  ),
                  heightBox(10.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   '',
                              //   style: mainStyle(context, 13),
                              // ),
                              // heightBox(10.h),
                              WideButtonIconWithText(
                                callBack: () {
                                  appointmentCubit.updateBookingForMySelf(true);
                                },
                                isSelected: appointmentCubit.bookingForMySelf ? true : false,
                                svgAssetLink: 'assets/svg/icons/profile face.svg',
                                title: 'I am booking for myself',
                                subTitle: 'I am an adult over 18 years',
                              ),
                              heightBox(10.h),
                              WideButtonIconWithText(
                                callBack: () {
                                  appointmentCubit.updateBookingForMySelf(false);
                                },
                                isSelected: !appointmentCubit.bookingForMySelf ? true : false,
                                svgAssetLink: 'assets/svg/icons/family_member.svg',
                                title: 'I am booking for a family member or multiple member',
                                // subTitle: 'I am an adult over 18 years',
                              ),
                              heightBox(25.h),
                              Text(
                                'Fill legal information details :',
                                style: mainStyle(context, 14),
                              ),
                              heightBox(25.h),
                              DefaultInputField(
                                controller: fullNameCont,
                                validate: normalInputValidate,
                                label:  'Full name',
                                // labelWidget: Text(
                                //   'Full name',
                                //   style: mainStyle(context, 13, color: mainBlueColor),
                                // ),
                              ),
                              heightBox(20.h),
                              DefaultInputField(
                                validate: normalInputValidate,
                                label:  'Date of birth',
                                // labelWidget: Text(
                                //   'Date of birth',
                                //   style: mainStyle(context, 13, color: mainBlueColor),
                                // ),
                                controller: dobCont,
                                readOnly: true,
                                onTap: () {
                                  _selectDate();
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                },
                                suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                              ),
                              heightBox(20.h),
                              DefaultInputField(
                                controller: idNumCont,
                                validate: normalInputValidate,
                                label:  'ID number',
                                // labelWidget: Text(
                                //   'ID number',
                                //   style: mainStyle(context, 13, color: mainBlueColor),
                                // ),
                              ),
                              heightBox(20.h),
                              DefaultInputField(
                                controller: mobileNumCont,
                                validate: normalInputValidate,
                                label:      'Mobile Number',
                                // labelWidget: Text(
                                //   'Mobile Number',
                                //   style: mainStyle(context, 13, color: mainBlueColor),
                                // ),
                              ),
                              heightBox(20.h),
                              DefaultInputField(
                                controller: emailCont,
                                validate: normalInputValidate,
                                label: 'Email',
                                // labelWidget: Text(
                                //   'Email',
                                //   style: mainStyle(context, 13, color: mainBlueColor),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  DefaultButton(
                      text: 'Next',
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          appointmentCubit.saveMainInfo(
                            fName: fullNameCont.text,
                            dob: dobCont.text,
                            id: idNumCont.text,
                            mobile: mobileNumCont.text,
                            email: emailCont.text,
                          );
                          navigateTo(context, AppointmentsUploadDocLayout());
                        }
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WideButtonIconWithText extends StatelessWidget {
  const WideButtonIconWithText({
    super.key,
    required this.isSelected,
    required this.title,
    required this.svgAssetLink,
    this.subTitle,
    this.callBack,
  });

  final bool isSelected;
  final String title;
  final String svgAssetLink;
  final String? subTitle;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: DefaultContainer(
        width: double.maxFinite,
        radius: 8.sp,
        backColor: isSelected ? secBlueColor : Colors.white,
        borderColor: secBlueColor,
        childWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 20.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                svgAssetLink,
                color: isSelected ? Colors.white : mainBlueColor,
                height: 24.sp,
              ),
              widthBox(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: mainStyle(context, 14,
                          weight: FontWeight.w700,
                          color: isSelected ? Colors.white : mainBlueColor,
                          textHeight: 1.5),
                    ),
                    subTitle == null
                        ? SizedBox()
                        : Column(
                            children: [
                              heightBox(8.h),
                              Text(
                                subTitle!,
                                style: mainStyle(context, 14,
                                    weight: FontWeight.w400,
                                    color: isSelected ? Colors.white : mainBlueColor),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
