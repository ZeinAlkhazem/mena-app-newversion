import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/messenger/dialogs/block_user_bottom_sheet_dialog.dart';
import 'package:mena/modules/messenger/widget/chat_request_item_widget.dart';
import 'package:mena/modules/messenger/widget/empty_new_message_widget.dart';
import '../../../models/api_model/home_section_model.dart';
import '../cubit/messenger_cubit.dart';
import '../dialogs/delete_bottom_sheet_dialog.dart';
import '../widget/icon_button_widget.dart';

class MessengerRequestPage extends StatefulWidget {
  const MessengerRequestPage({super.key});

  @override
  State<MessengerRequestPage> createState() => _MessengerRequestPageState();
}

class _MessengerRequestPageState extends State<MessengerRequestPage> {
  @override
  Widget build(BuildContext context) {
    bool isHaveData = true;

    List<User> userList = [
      User(
          id: 0,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg"),
      User(
          id: 1,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg"),
      User(
          id: 2,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg"),
      User(
          id: 3,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg"),
      User(
          id: 4,
          phone: "0999888777",
          fullName: "Username",
          email: "user@email.com",
          address: "address",
          personalPicture: "https://menaaii.com/storage/users/default.svg"),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: SvgPicture.asset(
              "assets/icons/back.svg",
              // fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          getTranslatedStrings(context).messageRequests,
          style: mainStyle(context, 14.sp,
              weight: FontWeight.w700,
              fontFamily: AppFonts.openSansFont,
              color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButtonWidget(
            iconUrl: "assets/icons/messenger/icon_multi_selection.svg",
            btnClick: () {
              MessengerCubit.get(context).changeShowSelectedState();
            },
            iconWidth: 30.w,
            iconHeight: 25.h,
          ),
        ],
      ),
      body: BlocConsumer<MessengerCubit, MessengerState>(
          listener: (context, state) {},
          builder: (context, state) {
            var messengerCubit = MessengerCubit.get(context);
            return !isHaveData
                ? EmptyNewMessageWidget(
                    content: getTranslatedStrings(context).requestEmptyText)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 1.sw,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: AppColors.lineGray.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(0.r)),
                        child: Text(
                          "Initiate a chat to gain more info about the sender's message.\nThey will not know that you've seen it until you accept their message",
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: mainStyle(context, 7.sp,
                              fontFamily: AppFonts.openSansFont,
                              weight: FontWeight.w400,
                              color: AppColors.grayDarkColor),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            return ChatRequestItemWidget(
                                showSelected: messengerCubit.showSelected,
                                user: userList[index]);
                          },
                          separatorBuilder: (_, i) => heightBox(5.h),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            getTranslatedStrings(context)
                                .messengerRequestedShowMore,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: mainStyle(context, 12.sp,
                                fontFamily: AppFonts.openSansFont,
                                weight: FontWeight.w700,
                                color: AppColors.lineBlue),
                          ),
                        ),
                      ),
                    ],
                  );
          }),
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: DefaultButton(
          onClick: () {
            deleteBottomSheetDialog(
                context: context,
                btnDelete: () {
                  Navigator.pop(context);
                });
            // blockUserBottomSheetWidget(context);
          },
          text: getTranslatedStrings(context).messengerDeleteAll,
          height: 0.06.sh,
          width: 1.sw,
          radius: 10.r,
          backColor: AppColors.lineGray.withOpacity(0.2),
          borderColor: Colors.white,
          customChild: Center(
            child: Text(
              getTranslatedStrings(context).messengerDeleteAll,
              style: mainStyle(context, 12.sp,
                  color: AppColors.textRed,
                  fontFamily: AppFonts.openSansFont,
                  weight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
