import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/meetings/create_upcoming_meeting_details.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/local_models.dart';

class JoinMeetingLayout extends StatelessWidget {
  const JoinMeetingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Join meeting',
        ),
      ),
      body: BlocConsumer<LiveCubit, LiveState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding:  EdgeInsets.all(defaultHorizontalPadding),
                child: Column(
                  children: [
                    DropdownButtonFormField2<ItemWithTitleAndCallback>(
                      decoration: InputDecoration(
                        errorMaxLines: 3,
                        isDense: true,
                        filled: true,
                        hintText: '-',
                        // floatingLabelBehavior: floatingLabelBehavior,
                        hintStyle: mainStyle(context, 12,
                            color: newDarkGreyColor, weight: FontWeight.w700),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Responsive.isMobile(context) ? 10 : 15.0,
                            horizontal: 0.0),
                        border: const OutlineInputBorder(),
                        // suffixIcon: Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                        //   child: suffixIcon,
                        // ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
                        labelStyle: mainStyle(context, 13,
                            color: newDarkGreyColor, weight: FontWeight.w700),
                        // labelText: label,
                        // label: Text( 'sakldkl'),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: withoutLabelPadding ? 0.0 : 2.0),
                        //   child: labelWidget,
                        // ),
                        fillColor: newLightGreyColor,
                        focusColor: newLightGreyColor,
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusVal))),

                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.withOpacity(0.6), width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusVal))),

                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainBlueColor, width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusVal))),

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: mainBlueColor.withOpacity(0.7), width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusVal))),

                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: mainBlueColor.withOpacity(0.7), width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusVal))),
                      ),
                      isExpanded: true,
                      hint: Text('Joining method',
                          style: mainStyle(context, 13,
                              color: newDarkGreyColor, weight: FontWeight.w700)),
                      items: liveCubit.joiningMethods
                          .map((item) => DropdownMenuItem<ItemWithTitleAndCallback>(
                                value: item,
                                child: Text(item.title,
                                    style: mainStyle(context, 13,
                                        color: newDarkGreyColor,
                                        weight: FontWeight.w700)),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select Joining method';
                        }
                        return null;
                      },
                      value: liveCubit.selectedJoiningMethod,
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        liveCubit.updateSelectedItemWithTitleAndCallback(value!);
                      },
                      onSaved: (value) {
                        // selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        // height: 60,
                        padding: EdgeInsets.only(left: 0, right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(defaultRadiusVal),
                        ),
                      ),
                    ),
                    heightBox(15.h),
                    DefaultInputField(
                      fillColor: Color(0xffedf2f0),
                      focusedBorderColor: mainBlueColor,
                      unFocusedBorderColor: mainBlueColor,
                      label: liveCubit.selectedJoiningMethod == null
                          ? 'Select joining method'
                          : liveCubit.selectedJoiningMethod!.title,
                    ),
                  ],
                ),
              ),
              Divider(height: 1,thickness: 1,),
              Container(
                color: newLightGreyColor,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: Column(
                    children: [
                      heightBox(15.h),
                      AgreeTerms(
                        byText: 'Pressing join',
                      ),
                      heightBox(15.h),
                      DefaultButton(text: 'Join', onClick: () {}),
                      heightBox(15.h),
                      Text(
                          'If you received an invitation link, tap on the link to join the meeting',
                      
                      style: mainStyle(context, 13,color: newDarkGreyColor,weight: FontWeight.w700,),textAlign: TextAlign.center,),   heightBox(15.h),
                    ],
                  ),
                ),
              ),
              Divider(height: 1,thickness: 1,),
              Padding(
                padding:  EdgeInsets.all(defaultHorizontalPadding),
                child: Column(
                  children: [
                    MeetingRowWithToggle(
                      title: 'Don’t connect to Audio',
                      // subTitle: '558 735 9937',
                      toggleVal: liveCubit.notConnectToAudio,
                      toggleClick: (val) {
                        liveCubit.updateNotConnectToAudio(val);
                      },
                    ),
                    Divider(height: 22.h,),
                    // heightBox(15.h),
                    MeetingRowWithToggle(
                      title: 'Turn off my Video',
                      // subTitle: '558 735 9937',
                      toggleVal: liveCubit.turnOffMyVideo,
                      toggleClick: (val) {
                        liveCubit.updateTurnOffMyVideo(val);
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1,thickness: 1,),

              Expanded(child: Container(color: newLightGreyColor,))
            ],
          );
        },
      ),
    );
  }
}
