import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/modules/messenger/widget/tab_item_widget.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../widget/icon_button_widget.dart';
import '../widget/search_field_widget.dart';
import 'messenger_my_contact_page.dart';
import 'messenger_primary_page.dart';
import 'messenger_requests_page.dart';

class MessengerNewMessagePage extends StatefulWidget {
  const MessengerNewMessagePage({super.key});

  @override
  State<MessengerNewMessagePage> createState() =>
      _MessengerNewMessagePageState();
}

class _MessengerNewMessagePageState extends State<MessengerNewMessagePage>
     {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: 8.h),
          SearchFieldWidget(),
          SizedBox(
            height: 65.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TabItemWidget(
                      title: getTranslatedStrings(context).messengerPrimary,
                      btnClick: () {},
                      isSelected: true),
                  TabItemWidget(
                      title: getTranslatedStrings(context).messengerMyContact,
                      btnClick: () {
                        navigateTo(context, MessengerMyContact(),);
                      },
                      isSelected:  false),
                  TabItemWidget(
                      title: getTranslatedStrings(context).messengerRequested,
                      btnClick: () {
                        navigateTo(context, MessengerRequestPage());
                      },
                      counter: 12,
                      isSelected: false),
                ],
              ),
            ),

            // TabBar(
            //   padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 5.h),
            //   indicatorColor: Colors.transparent,
            //   isScrollable: true,
            //   labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
            //   controller: _tabController,
            //   tabs: [
            //     TabItemWidget(
            //         title: getTranslatedStrings(context).messengerPrimary,
            //         btnClick: () {},
            //         isSelected: _tabController!.index == 0 ? true : false),
            //     TabItemWidget(
            //         title: getTranslatedStrings(context).messengerMyContact,
            //         btnClick: () {},
            //         isSelected: _tabController!.index == 1 ? true : false),
            //     TabItemWidget(
            //         title: getTranslatedStrings(context).messengerRequested,
            //         btnClick: () {
            //           navigateTo(context, MessengerRequestPage());
            //         },
            //         counter: 12,
            //         isSelected: _tabController!.index == 2 ? true : false),
            //   ],
            // ),
          ),
          Expanded(
            child: MessengerPrimaryPage()
          ),
          // Expanded(
          //   child: TabBarView(
          //     controller: _tabController,
          //     children: [
          //       MessengerPrimaryPage(),
          //       MessengerMyContact(),
          //       MessengerRequestPage(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
