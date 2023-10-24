import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../models/api_model/home_section_model.dart';
import '../chat_layout.dart';
import 'user_image_widget.dart';

class UserChatIconWidget extends StatelessWidget {
  const UserChatIconWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logg('on click on chat user');
        navigateTo(
            context,
            ChatLayout(
              user: user,
            ));
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            UserImageWidget(
              isOnline: false,
              pictureUrl: user.personalPicture,
            ),
            widthBox(7.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        constraints: BoxConstraints(maxWidth: 200.w),
                        child: Text(
                          getFormattedUserName(user),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: mainStyle(context, 12, isBold: true),
                        ),
                      ),
                      (user.verified == '1')
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.verified,
                          color: Color(0xff01BC62),
                          size: 16.sp,
                        ),
                      )
                          : SizedBox()
                    ],
                  ),
                  /// if provider
                  if (MainCubit.get(context).isUserProvider())
                    Column(
                      children: [
                        heightBox(5.h),
                        Text(
                          user.speciality ?? (user.specialities == null || user.specialities!.isEmpty)
                              ? '-'
                              : user.specialities![0].name ?? '',
                          style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            widthBox(2.w),
            InkWell(
                onTap: (){},
                // child: SvgPicture.asset("assets/icons/messenger/icon_video_call.svg",width: 30.w,),),
                child:Icon(Icons.video_call_outlined,color: Color(0xFF0077FF),size: 35.w,),),

            widthBox(15.w),
            InkWell(
                onTap: (){},
                child: SvgPicture.asset("assets/icons/messenger/icon_voice_call.svg",width: 25.w,),),
            widthBox(2.w),
          ],
        ),
      ),
    );
  }
}
