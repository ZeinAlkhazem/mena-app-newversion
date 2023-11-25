import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../../models/api_model/home_section_model.dart';
import '../dialogs/alert_bottom_sheet_dialog.dart';
import '../dialogs/block_report_bottom_sheet_dialog.dart';
import '../dialogs/block_user_bottom_sheet_dialog.dart';
import '../dialogs/delete_bottom_sheet_dialog.dart';
import '../widget/back_button_widget.dart';
import '../widget/custom_button_widget.dart';

class UserProfileRequestPage extends StatelessWidget {
  final User user;

  const UserProfileRequestPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: BackButtonWidget(),
        titleSpacing: 0,
        elevation: 1,
        backgroundColor: Color(0xFFFCFCFC),
        title: Text(""),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),

            ///
            /// profile details
            ///
            /// user profile image
            ProfileBubble(
              isOnline: true,
              radius: 60.r,
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
              style: mainStyle(context, 20.sp,
                  fontFamily: AppFonts.interFont,
                  weight: FontWeight.w500,
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
              style: mainStyle(
                context,
                14.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
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
              style: mainStyle(
                context,
                14.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),

            /// user name
            Text(
              "11/2022",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(
                context,
                12.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),

            /// button for go to view profile
            CustomButtonWidget(
              title: getTranslatedStrings(context).viewProfile,
              height: 28.h,
              radius: 5.r,
              width: 125.w,
              bgColor: Color(0xFFF5F5F5),
              btnClick: () {},
              textSize: 12.sp,
              textColor: Color(0xFF348FE9),
            ),

            SizedBox(
              height: 20.h,
            ),
            Expanded(
                child: ListView.builder(
                    primary: true,
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(

                        margin: EdgeInsets.only(
                          top: 2.h,bottom: 2.h,
                            left: 10.w,
                            right: index == 0 ? 150.w:100.w,

                           ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 5.h),
                        constraints: BoxConstraints(maxWidth: 0.7.sw),
                        decoration: BoxDecoration(
                          color: chatGreyColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: chatGreyColor,
                            width: 0.5,
                          ),
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 6.h),
                              child: Text(
                                index == 0
                                    ? "Hello there!"
                                    : "Do you have a website?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.interFont,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Text(
                                  //   message.fromName??'',
                                  //   style: mainStyle(context, 11,
                                  //       weight: FontWeight.w600, color: mainBlueColor),
                                  // ),
                                  SizedBox(width: 10.w),

                                  Text(
                                      getFormattedDateOnlyTime(DateTime.now()),
                                      textAlign: TextAlign.center,
                                      style: mainStyle(context, 8,
                                          color: Colors.black)),
                                  // const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      );
                    })),
            SizedBox(
              height: 0.275.sh,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 0.275.sh,
        width: 1.sw,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w),
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
              style: mainStyle(
                context,
                12.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w400,
                textHeight: 1.4,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              "If you agree, they will also have the capability to call you and access information such as your activity and the timestamp of when you've read messages",
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: mainStyle(context, 9.sp,
                  fontFamily: AppFonts.interFont,
                  weight: FontWeight.w400,
                  color: Color(0xFF979797),
                  textHeight: 1.4),
            ),
            SizedBox(
              height: 12.h,
            ),

            /// row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButtonWidget(
                  height: 29.h,
                  radius: 5.r,
                  width: 90.w,
                  bgColor: Color(0xFFEDEDED),
                  title: getTranslatedStrings(context).block,
                  textSize: 15.sp,
                  textColor: Color(0xFFE46157),
                  btnClick: () {
                    blockReportBottomSheetDialog(
                        context: context,
                        btnBlock: () {
                          Navigator.pop(context);
                          blockUserBottomSheetDialog(context);
                        },
                        btnReport: () {
                          Navigator.pop(context);
                        });
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomButtonWidget(
                  height: 29.h,
                  radius: 5.r,
                  width: 90.w,
                  bgColor: Color(0xFFEDEDED),
                  title: getTranslatedStrings(context).delete,
                  textSize: 15.sp,
                  textColor: Color(0xFFE46157),
                  btnClick: () {
                    deleteBottomSheetDialog(
                        context: context,
                        btnDelete: () {
                          Navigator.pop(context);
                        });
                  },
                ),
                SizedBox(
                  width: 12.w,
                ),
                CustomButtonWidget(
                  height: 29.h,
                  radius: 5.r,
                  width: 90.w,
                  bgColor: Color(0xFFEDEDED),
                  title: getTranslatedStrings(context).accept,
                  textSize: 15.sp,
                  textColor: Color(0xFF58A2EB),
                  btnClick: () {
                    alertBottomSheetDialog(
                        context: context,
                        title: getTranslatedStrings(context).accept,
                        btnOk: () {
                          Navigator.of(context).pop();
                        },
                        message: getTranslatedStrings(context)
                            .messengerAcceptMessage);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
