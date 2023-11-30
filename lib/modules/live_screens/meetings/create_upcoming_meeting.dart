import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/meetings_config.dart';
import 'package:mena/models/api_model/my_meetings.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import 'create_upcoming_meeting_select_participant_type.dart';

class CreateUpcomingMeeting extends StatefulWidget {
  const CreateUpcomingMeeting({Key? key, this.customMeetingToEdit}) : super(key: key);

  final Meeting? customMeetingToEdit;

  @override
  State<CreateUpcomingMeeting> createState() => _CreateUpcomingMeetingState();
}

class _CreateUpcomingMeetingState extends State<CreateUpcomingMeeting> {

  @override
  void initState() {
    // TODO: implement initState
    var liveCubit = LiveCubit.get(context);

    if(widget.customMeetingToEdit!=null){
      //edit
      liveCubit.updateSelectedMeetingTypeId(widget.customMeetingToEdit!.meetingType!.id.toString());
    }else{
      liveCubit.updateSelectedMeetingTypeId('-1');
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title:
          widget.customMeetingToEdit!=null?'Edit upcoming meeting':
          'Create upcoming meeting',
        ),
      ),
      body: BlocConsumer<LiveCubit, LiveState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child:
            SafeArea(
              child:        Column(
                children: [
                  Text(
                    'Select participant type',

                    style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                  ),
                  Divider(),
                  heightBox(15.h),
                  if (liveCubit.meetingsConfigModel != null)
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          MeetingType meetingType = liveCubit.meetingsConfigModel!.data.meetingTypes[index];
                          return GestureDetector(
                            onTap: () {
                              liveCubit.updateSelectedMeetingTypeId(meetingType.id.toString());
                            },
                            child: DefaultContainer(
                              borderColor: liveCubit.selectedMeetingTypeId == meetingType.id.toString()
                                  ? mainBlueColor
                                  : newDarkGreyColor,
                              borderWidth: liveCubit.selectedMeetingTypeId == meetingType.id.toString() ? 2 : 1,
                              childWidget: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  meetingType.title,
                                  style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (c, i) => heightBox(8.h),
                        itemCount: liveCubit.meetingsConfigModel!.data.meetingTypes.length,
                      ),
                    ),
                  DefaultButton(
                    text: 'Next',
                    onClick: () {
                      navigateTo(context, CreateUpcomingMeetingSelectParticipant(
                        customMeetingToEdit: widget.customMeetingToEdit,
                      ));
                    },
                    isEnabled: liveCubit.selectedMeetingTypeId != '-1',
                  )
                ],
              ),
            )

          );
        },
      ),
    );
  }
}
