import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/main_layout/main_layout.dart';

import '../../../core/functions/main_funcs.dart';

class AppointmentSavedSuccess extends StatelessWidget {
  const AppointmentSavedSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: '',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icons/appointment_success.svg',
                    ),
                    heightBox(15.h),
                    Text(
                      'Great news!',
                      style: mainStyle(context, 16, weight: FontWeight.w700),
                    ),
                    heightBox(10.h),
                    Text(
                      'Your appointment has been confirmed.!',
                      style: mainStyle(context, 13, weight: FontWeight.w700),
                    ),
                    heightBox(10.h),
                    Text(
                      'Please check your email for the appointment confirmation, We will send you a reminder before the appointment time.',
                      style: mainStyle(context, 13),
                      textAlign: TextAlign.center,

                      ///
                    ),
                    // SvgPicture.asset('assets/svg/icons/qrcode.svg'),
                  ],
                ),
              ),
              DefaultButton(
                text: 'Go to Home screen',
                onClick: () {
                  navigateToAndFinishUntil(context, MainLayout());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
