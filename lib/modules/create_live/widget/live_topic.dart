import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/models/api_model/live_info_model.dart';
import 'package:mena/modules/create_live/widget/TopicCard.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../add_people_to_live/widget/add_people_card.dart';
import '../../create_live/widget/radius_20_container.dart';

// ignore: must_be_immutable
class LiveTopic extends StatefulWidget {
 LiveTopic(
      {super.key,
       required this.topics,
       this.selectedTopic
      });

  final List<Topic> topics;
   String? selectedTopic;
   int? selectedTopicId;

  @override
  State<LiveTopic> createState() => _LiveTopicState();
}

class _LiveTopicState extends State<LiveTopic> {
  
  @override
  Widget build(BuildContext context) {
    LiveCubit liveCubit = LiveCubit.get(context);
    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            SizedBox(
              height: 0.25.sh,
              child: RawScrollbar(
                thumbColor: mainBlueColor,
                radius: Radius.circular(20.r),
                thickness: 5,
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    itemCount: widget.topics.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return  GestureDetector(
                        onTap: (){
                          liveCubit.updateTopic(widget.topics[index].id,widget.topics[index].title); 
                          logg('the selectedTopic.toString() : ${widget.selectedTopic.toString()}');
                        },
                        child: TopicCard(
                            id:widget.topics[index].id,
                            selected: liveCubit.selectedTopic == widget.topics[index].title ? true : false,
                            title: widget.topics[index].title
                            ),
                      );
                    }),
              ),
            ),
            // DefaultButton(
            //   text: "Back",
            //   onClick: () => Navigator.pop(context),
            // )
          ],
        ),
      ),
    );
  }
}
