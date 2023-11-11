import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/messenger/dialogs/alert_bottom_sheet_dialog.dart';
import 'package:mena/modules/messenger/dialogs/block_report_bottom_sheet_dialog.dart';
import 'package:mena/modules/messenger/dialogs/block_user_bottom_sheet_dialog.dart';
import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../models/api_model/home_section_model.dart';
import '../dialogs/delete_bottom_sheet_dialog.dart';

class UserProfileRequestPage extends StatelessWidget {
  final User user;

  const UserProfileRequestPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// header of page
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/icons/back.svg',
                        color: mainBlueColor,
                      ),
                    ),
                  ),
                ),
                widthBox(0.06.sw),
                Expanded(
                  child: Row(
                    children: [
                      ProfileBubble(
                        isOnline: true,
                        radius: 18.h,
                        pictureUrl: user!.personalPicture,
                      ),
                      widthBox(5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getFormattedUserName(user!),
                              style: mainStyle(context, 12, isBold: true),
                            ),
                            if (user!.specialities != null) heightBox(4.h),
                            if (user!.specialities != null &&
                                user!.specialities!.length > 0)
                              Text(
                                '${user!.specialities![0].name ?? ''}',
                                style: mainStyle(context, 9,
                                    isBold: true, color: mainBlueColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),

            ///
            /// profile details
            ///
            /// user profile image
            ProfileBubble(
              isOnline: true,
              radius: 50.h,
              pictureUrl: user!.personalPicture,
            ),
            SizedBox(
              height: 10.h,
            ),

            /// full name
            Text(
              user.fullName!,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 18.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w400,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10.h,
            ),

            /// specialty
            Text(
              "Provider Sub Category",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 10.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w400,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10.h,
            ),

            /// user name
            Text(
              "@Username",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 10.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w400,
                  color: Colors.black),
            ),
            SizedBox(
              height: 20.h,
            ),

            /// user name
            Text(
              "11/2022 1M Followers",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 10.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w400,
                  color: Colors.black),
            ),

            SizedBox(
              height: 20.h,
            ),

            /// button for go to view profile
            DefaultButton(
                text: getTranslatedStrings(context).viewProfile,
                backColor: AppColors.lineGray.withOpacity(0.3),
                height: 45.h,
                width: 140.w,
                borderColor: Colors.white,
                titleColor: AppColors.lineBlue,
                onClick: () {}),

            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileBubble(
                    isOnline: true,
                    radius: 25.h,
                    pictureUrl: user!.personalPicture,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "The message as per our chat page ",
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: mainStyle(context, 10.sp,
                        fontFamily: AppFonts.openSansFont,
                        weight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        height: 0.275.sh,
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          children: [
            Divider(),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Accept message request from zain Yousef mohammed ( username ) ?",
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 10.sp,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w700,
                  textHeight: 1.4,
                  color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Text(
                "If you agree, they will also have the capability to call you and access information such as your activity and the timestamp of when you've read messages",
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: mainStyle(context, 8.sp,
                    fontFamily: AppFonts.openSansFont,
                    weight: FontWeight.w400,
                    color: Colors.black,
                    textHeight: 1.4),
              ),
            ),

            /// row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DefaultButton(
                    text: getTranslatedStrings(context).block,
                    backColor: AppColors.lineGray.withOpacity(0.3),
                    fontSize: 10.sp,
                    height: 40.h,
                    width: 100.w,
                    borderColor: Colors.white,
                    titleColor: Colors.red,
                    onClick: () {

                      blockReportBottomSheetDialog(
                          context: context,
                          btnBlock: () {
                            Navigator.pop(context);
                            blockUserBottomSheetDialog(context);
                          },
                          btnReport: () {
                            Navigator.pop(context);
                          });
                    }),
                DefaultButton(
                    text: getTranslatedStrings(context).delete,
                    backColor: AppColors.lineGray.withOpacity(0.3),
                    fontSize: 10.sp,
                    height: 40.h,
                    width: 100.w,
                    borderColor: Colors.white,
                    titleColor: Colors.red,
                    onClick: () {
                      deleteBottomSheetDialog(context: context,btnDelete: (){
                        Navigator.pop(context);
                      });
                    }),
                DefaultButton(
                    text: getTranslatedStrings(context).accept,
                    backColor: AppColors.lineGray.withOpacity(0.3),
                    fontSize: 10.sp,
                    height: 40.h,
                    width: 100.w,
                    borderColor: Colors.white,
                    titleColor: AppColors.lineBlue,
                    onClick: () {
                      alertBottomSheetDialog(
                          context: context,
                          title: getTranslatedStrings(context).accept,
                          btnOk: () {
                            Navigator.of(context).pop();
                          },
                          message: getTranslatedStrings(context)
                              .messengerAcceptMessage);

                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
