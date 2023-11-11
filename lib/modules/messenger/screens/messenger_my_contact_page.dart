import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/messenger/widget/contact_item_widget.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../cubit/messenger_cubit.dart';
import '../widget/icon_button_widget.dart';

class MessengerMyContact extends StatefulWidget {
  const MessengerMyContact({super.key});

  @override
  State<MessengerMyContact> createState() => _MessengerMyContactState();
}

class _MessengerMyContactState extends State<MessengerMyContact> {
  @override
  void initState() {
    var messengerCubit = MessengerCubit.get(context);
    messengerCubit..getContact();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessengerCubit, MessengerState>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      var messengerCubit = MessengerCubit.get(context);
      
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
            getTranslatedStrings(context).messengerNewMessage,
            style: mainStyle(context, 14.sp,
                weight: FontWeight.w700,
                fontFamily: AppFonts.openSansFont,
                color: Colors.black),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButtonWidget(
              iconUrl: "assets/icons/messenger/icon_new_call.svg",
              btnClick: () {},
              iconWidth: 35.w,
              iconHeight: 30.h,
            ),
            SizedBox(
              width: 5.w,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: AppColors.iconsColor,
                size: 30.h,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 25.h,width: 25.w,
                      child: SvgPicture.asset("$messengerAssets/icon_phone_contact.svg")),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    getTranslatedStrings(context).messengerMyPhoneContact,
                    style: mainStyle(context, 10.sp,
                        weight: FontWeight.w700,
                        color: Color(0xFF5B5C5E),
                        fontFamily: AppFonts.openSansFont,
                        textHeight: 1.1),
                  ),
                ],
              ),
            ),
            state is LoadingContactState
                ? Center(child: CircularProgressIndicator())
                : state is ContactDeviceState
                    ? Expanded(
                      child: ListView.builder(
                          itemCount: messengerCubit.contacts!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Uint8List? image =
                                messengerCubit.contacts![index].photo;
                            String num = (messengerCubit
                                    .contacts![index].phones.isNotEmpty)
                                ? (messengerCubit
                                    .contacts![index].phones.first.number)
                                : "--";
                            return ContactItemWidget(
                              name: "${messengerCubit.contacts![index].name.first} ${messengerCubit.contacts![index].name.last}",
                              phone: num,
                              btnInvite: (){

                              },
                            );
                          },
                        ),
                    )
                    : SizedBox()
          ],
        ),
      );
    });
  }
}
