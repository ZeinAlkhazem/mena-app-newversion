import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/create_live/widget/radius_20_container.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/config_model.dart';
import '../cubit/create_live_cubit.dart';
import 'live_input_field.dart';

class BottomsheetClickPoll extends StatelessWidget {
  const BottomsheetClickPoll({
    super.key,
    this.onClickConfirm,
  });

  final VoidCallback? onClickConfirm;

  @override
  Widget build(BuildContext context) {
    CreateLiveCubit createLiveCubit = CreateLiveCubit.get(context);

    List<MenaPlatform>? platforms;

    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Form(
          key: createLiveCubit.formKeyPoll,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20.0.h),
                height: 60.h,
                decoration: BoxDecoration(
                  color: newLightGreyColor,
                  borderRadius: BorderRadius.circular(5.0.sp),
                  border: Border.all(width: 0.5, color: mainBlueColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/icons/alarm clock time.svg',
                        width: 24.sp,
                        color: mainBlueColor,
                        height: 24.sp,
                      ),
                      Expanded(
                        child: Center(
                          child: DropdownButton<MenaPlatform>(
                            value: createLiveCubit.selectedPlatform,
                            isDense: false,
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.r)),
                            isExpanded: true,
                            icon: SvgPicture.asset(
                              'assets/svg/icons/arrow_down_base.svg',
                              width: 18.sp,
                              color: newDarkGreyColor,
                              height: 18.sp,
                            ),
                            elevation: 1,
                            menuMaxHeight: 0.5.sh,
                            style: mainStyle(context, 12.sp,
                                color: newDarkGreyColor,
                                weight: FontWeight.w700),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (MenaPlatform? newValue) {
                              createLiveCubit.updateSelectedPlatform();
                              log(newValue!.name.toString());
                            },
                            items: <MenaPlatform>[...platforms ?? []]
                                .map<DropdownMenuItem<MenaPlatform>>(
                                    (MenaPlatform value) {
                              return DropdownMenuItem<MenaPlatform>(
                                value: value,
                                child: Text(value.name.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LiveInputField(
                label: 'Add question',
                controller: createLiveCubit.addQuestion,
                validate: normalInputValidate(context,
                    customText: 'It cannot be empty'),
              ),
              heightBox(20.h),
              LiveInputField(
                label: 'Add option 1',
                controller: createLiveCubit.addOption1,
                validate: normalInputValidate(context,
                    customText: 'It cannot be empty'),
              ),
              heightBox(20.h),
              LiveInputField(
                label: 'Add option 2',
                controller: createLiveCubit.addOption2,
                validate: normalInputValidate(context,
                    customText: 'It cannot be empty'),
              ),
              heightBox(20.h),
              DefaultButton(
                text: "Confirm",
                onClick: onClickConfirm!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
