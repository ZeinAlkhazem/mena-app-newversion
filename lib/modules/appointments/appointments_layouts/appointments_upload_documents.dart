import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_insurance.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import 'appointment_confirm_details.dart';
import 'book_appointment_form.dart';

class AppointmentsUploadDocLayout extends StatefulWidget {
  const AppointmentsUploadDocLayout({Key? key}) : super(key: key);

  @override
  State<AppointmentsUploadDocLayout> createState() => _AppointmentsUploadDocLayoutState();
}

class _AppointmentsUploadDocLayoutState extends State<AppointmentsUploadDocLayout> {
  TextEditingController faceIDVal = TextEditingController();
  TextEditingController commentCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppointmentsCubit.get(context).toggleViewComment(false);
    commentCont.text = '';
  }

  @override
  Widget build(BuildContext context) {
    var appointmentsCubit = AppointmentsCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Back',
          suffix: GestureDetector(
              onTap: () {
                navigateTo(context, AppointmentConfirmDetailsLayout());
              },
              child: AppBarSkip()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SafeArea(
          child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Column(
                children: [
                  AppointmentHeader(
                    title: 'Upload Documents to continue',
                    sub: 'Your data is safe and secure with Mena',
                    image: 'assets/svg/icons/gif.svg',
                  ),
                  heightBox(10.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload ID',
                            style: mainStyle(context, 13),
                          ),
                          heightBox(5.h),
                          DefaultInputField(
                            label: 'Front side',
                            // labelWidget: Text(
                            //   'Front side',
                            //   style: mainStyle(
                            //     context,
                            //     13,
                            //   ),
                            // ),
                            controller: faceIDVal,
                            readOnly: true,
                            onTap: () {
                              // _pickPicture().then put its val in faceID;
                              appointmentsCubit.selectFile(CustFileType.fID);
                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            suffixIcon: SvgPicture.asset('assets/svg/icons/file.svg'),
                          ),
                          appointmentsCubit.userInfoFiles.containsKey(CustFileType.fID)
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    appointmentsCubit.userInfoFiles[CustFileType.fID]!,
                                    height: 0.18.sh,
                                  ),
                                ))
                              // Text(appointmentsCubit.userInfoFiles[CustFileType.fID]?.filename??'file')
                              : SizedBox(),
                          heightBox(10.h),
                          DefaultInputField(
                            label: 'Back side',
                            // labelWidget: Text(
                            //   'Back side',
                            //   style: mainStyle(context, 13),
                            // ),
                            controller: faceIDVal,
                            readOnly: true,
                            onTap: () {
                              // _pickPicture().then put its val in faceID;
                              appointmentsCubit.selectFile(CustFileType.bId);

                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            suffixIcon: SvgPicture.asset('assets/svg/icons/file.svg'),
                          ),
                          appointmentsCubit.userInfoFiles.containsKey(CustFileType.bId)
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    appointmentsCubit.userInfoFiles[CustFileType.bId]!,
                                    height: 0.18.sh,
                                  ),
                                ))
                              // Text(appointmentsCubit.userInfoFiles[CustFileType.fID]?.filename??'file')
                              : SizedBox(),
                          heightBox(25.h),
                          Text(
                            'Upload Insurance card',
                            style: mainStyle(context, 13),
                          ),
                          heightBox(5.h),
                          DefaultInputField(
                            label: 'Insurance card front',
                            // labelWidget: Text(
                            //   'Insurance card front',
                            //   style: mainStyle(
                            //     context,
                            //     13,
                            //   ),
                            // ),
                            controller: faceIDVal,
                            readOnly: true,
                            onTap: () {
                              // _pickPicture().then put its val in faceID;
                              appointmentsCubit.selectFile(CustFileType.insuranceFront);

                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            suffixIcon: SvgPicture.asset('assets/svg/icons/file.svg'),
                          ),
                          appointmentsCubit.userInfoFiles.containsKey(CustFileType.insuranceFront)
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    appointmentsCubit.userInfoFiles[CustFileType.insuranceFront]!,
                                    height: 0.18.sh,
                                  ),
                                ))
                              // Text(appointmentsCubit.userInfoFiles[CustFileType.fID]?.filename??'file')
                              : SizedBox(),
                          heightBox(10.h),
                          DefaultInputField(
                            label: 'Insurance card back',
                            // labelWidget: Text(
                            //   'Insurance card back',
                            //   style: mainStyle(
                            //     context,
                            //     13,
                            //   ),
                            // ),
                            controller: faceIDVal,
                            readOnly: true,
                            onTap: () {
                              // _pickPicture().then put its val in faceID;
                              appointmentsCubit.selectFile(CustFileType.insuranceBack);

                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            suffixIcon: SvgPicture.asset('assets/svg/icons/file.svg'),
                          ),
                          appointmentsCubit.userInfoFiles.containsKey(CustFileType.insuranceBack)
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    appointmentsCubit.userInfoFiles[CustFileType.insuranceBack]!,
                                    height: 0.18.sh,
                                  ),
                                ))
                              // Text(appointmentsCubit.userInfoFiles[CustFileType.fID]?.filename??'file')
                              : SizedBox(),
                          heightBox(25.h),
                          DefaultContainer(
                            radius: 6.sp,
                            childWidget: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/svg/icons/message.svg'),
                                      widthBox(8.w),
                                      Expanded(
                                          child: Text(
                                        'Do You have any additional comment Or instructions ? (optional)',
                                        style: mainStyle(context, 12,
                                            color: mainBlueColor, weight: FontWeight.w700, textHeight: 1.5),
                                      )),
                                      widthBox(8.w),
                                      GestureDetector(
                                        onTap: () {
                                          appointmentsCubit.toggleViewComment(null);
                                        },
                                        child: Icon(
                                          appointmentsCubit.viewCommentInput
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.arrow_forward_ios_rounded,
                                          color: mainBlueColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  appointmentsCubit.viewCommentInput
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 28.0),
                                          child: DefaultInputField(
                                            controller: commentCont,
                                            label: 'Type your comment here ..',
                                            // labelWidget: Text('Type your comment here ..'),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                          // heightBox(25.h)
                        ],
                      ),
                    ),
                  ),
                  // DefaultButton(text: 'temp', onClick: (){
                  //   navigateTo(context, AppointmentConfirmDetailsLayout());
                  //
                  // }),
                  heightBox(25.h),
                  DefaultButton(
                      text: 'Next',
                      onClick: () {
                        // if(appointmentsCubit.userInfoFiles.containsKey(CustFileType.fID)&&
                        //     appointmentsCubit.userInfoFiles.containsKey(CustFileType.bId)
                        // ){
                        //   navigateTo(context, AppointmentConfirmDetailsLayout());
                        // }else{
                        //   showMyAlertDialog(context, 'Id required');
                        // }
                        if (commentCont.text.isNotEmpty) {
                          appointmentsCubit.updateComment(commentCont.text);
                        }
                        navigateTo(context, AppointmentConfirmDetailsLayout());
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
