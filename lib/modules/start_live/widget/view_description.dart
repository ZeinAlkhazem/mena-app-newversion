import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../create_live/widget/radius_20_container.dart';
class ViewDescription extends StatelessWidget {
  const ViewDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Radius20Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 0.5.sh,
            child: RawScrollbar(
              thumbColor: mainBlueColor,
              radius: Radius.circular(20.r),
              thickness: 5,
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 18.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18.sp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28.sp),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: DefaultImage(
                                    backGroundImageUrl:
                                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                                    backColor: newLightGreyColor,
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widthBox(10.w),
                          Text(
                            "Dr.NaKaren A",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ]),
                        heightBox(30.h)
                      ],
                    );
                  }),
            ),
          ),
          DefaultButton(
            text: "Back",
            onClick: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
