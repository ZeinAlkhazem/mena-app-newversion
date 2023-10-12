import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/meetings_config.dart';
import '../../../models/api_model/my_meetings.dart';
import '../live_cubit/live_cubit.dart';
import 'create_upcoming_meeting_details.dart';


class CreateUpcomingMeetingSelectParticipant extends StatefulWidget {
  const CreateUpcomingMeetingSelectParticipant({Key? key, this.customMeetingToEdit}) : super(key: key);

  final Meeting? customMeetingToEdit;

  @override
  State<CreateUpcomingMeetingSelectParticipant> createState() => _CreateUpcomingMeetingSelectParticipantState();
}

class _CreateUpcomingMeetingSelectParticipantState extends State<CreateUpcomingMeetingSelectParticipant> {



  @override
  void initState() {
    // TODO: implement initState
    var liveCubit=LiveCubit.get(context);
    if(widget.customMeetingToEdit!=null){
      //edit
      liveCubit.updateSelectedParicipantTypeId(widget.customMeetingToEdit!.participantsType!.id.toString());
    }else{
      liveCubit.updateSelectedParicipantTypeId('-1');
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title:          widget.customMeetingToEdit!=null?'Edit upcoming meeting': 'Create upcoming meeting',
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
                      'Select Virtual Meeting Type',
                      style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                    ),
                    Divider(),
                    heightBox(15.h),
                    if (liveCubit.meetingsConfigModel != null)
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            MeetingType meetingType = liveCubit.meetingsConfigModel!.data.participantsTypes[index];
                            return GestureDetector(
                              onTap: () {
                                liveCubit.updateSelectedParicipantTypeId(meetingType.id.toString());
                              },
                              child: DefaultContainer(
                                borderColor: liveCubit.selectedParticipantTypeId == meetingType.id.toString()
                                    ? mainBlueColor
                                    : newDarkGreyColor,
                                borderWidth: liveCubit.selectedParticipantTypeId == meetingType.id.toString() ? 2 : 1,
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
                        navigateTo(context, CreateUpcomingMeetingSelectDetails(
                          customMeetingToEdit: widget.customMeetingToEdit,
                        ));
                      },
                      isEnabled: liveCubit.selectedParticipantTypeId != '-1',
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
