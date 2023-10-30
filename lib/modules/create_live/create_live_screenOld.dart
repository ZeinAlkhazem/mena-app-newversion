import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/create_live/widget/appbar_for_live.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';
import 'package:mena/modules/create_live/widget/live_input_field.dart';
import 'package:mena/modules/create_live/widget/more_live_option.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../add_people_to_live/add_people_to_live_screen.dart';
import 'cubit/create_live_cubit.dart';

class CreateLivePage extends StatefulWidget {
  const CreateLivePage({super.key});

  @override
  State<CreateLivePage> createState() => _CreateLivePageState();
}

class _CreateLivePageState extends State<CreateLivePage> {
  @override
  Widget build(BuildContext context) {
    var createLiveCubit = CreateLiveCubit.get(context)
      ..toggleAutoValidate(false);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: defaultAppBarForLive(
        context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
        child: Form(
            key: createLiveCubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    heightBox(20.h),
                    AvatarForLive(
                        radius: 40.sp,
                        isOnline: true,
                        customRingColor: mainBlueColor,
                        pictureUrl:
                            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
                    heightBox(20.h),
                    LiveInputField(
                      label: 'Title',
                      controller: createLiveCubit.title,
                      validate: normalInputValidate(context,
                          customText: 'It cannot be empty'),
                    ),
                    heightBox(20.h),
                    LiveInputField(
                      label: 'Target',
                      controller: createLiveCubit.target,
                      validate: normalInputValidate(context,
                          customText: 'It cannot be empty'),
                    ),
                    heightBox(20.h),
                    LiveInputField(
                      label: 'Goal',
                      controller: createLiveCubit.goal,
                      validate: normalInputValidate(context,
                          customText: 'It cannot be empty'),
                    ),
                    heightBox(40.h),
                    BlocConsumer<CreateLiveCubit, CreateLiveState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return MoreOptionRow(
                            title: "Record live streams",
                            onChanged: (value) =>
                                createLiveCubit.onPressRecordlive(value),
                            value: createLiveCubit.valueRecordlive,
                          );
                        }),
                    heightBox(20.h),
                    BlocConsumer<CreateLiveCubit, CreateLiveState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return MoreOptionRow(
                            title: "Share My live on my feed page",
                            onChanged: (value) => createLiveCubit
                                .onPressShareMyLive(context, value),
                            value: createLiveCubit.valueShareMyLive,
                          );
                        }),
                  ]),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: Colors.white),
                      onPressed: () => navigateTo(
                          context, const AddPeopleToLiveScreenPage()),
                      child: SvgPicture.asset(
                        'assets/svg/user_add.svg',
                        height: Responsive.isMobile(context) ? 28.w : 12.w,
                      ),
                    ),
                    DefaultButton(
                      width: 150.w,
                      text: "Star Streaming",
                      onClick: () {
                        // createLiveCubit.onPressStarStreaming(context);
                        createLiveCubit.createLive();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: Colors.white),
                      onPressed: () {
                        createLiveCubit.onPressLinked(context);
                      },
                      child: SvgPicture.asset(
                        'assets/svg/linked_outline.svg',
                        height: Responsive.isMobile(context) ? 28.w : 12.w,
                      ),
                    ),
                  ],
                ),
                heightBox(20.h),
              ],
            )),
      ),
    );
  }
}
