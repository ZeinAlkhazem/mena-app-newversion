import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/modules/messenger/widget/tab_item_widget.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
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
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int index = 0;

  Color selectedColor = Color(0xff202226);
  Color unSelectedColor = Color(0xff999B9D);
  Color indicatorColor = Color(0xff2788E8);
  Color iconColor = Color(0xff2788E8);
  Color bgAppBarColor = Color(0xFFFDFDFD);

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          if (_tabController!.index == 0) {
            index = _tabController!.index;
          } else if (_tabController!.index == 1) {
            navigateTo(
              context,
              MessengerMyContact(),
            );
            _tabController!.index = 0;
          } else if (_tabController!.index == 2) {
            navigateTo(context, MessengerRequestPage());
            _tabController!.index = 0;
          }
        });
      });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgAppBarColor,
            leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 20.w,
                  height: 28.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.only(left: 13.w, right: 8.w),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 20.w,
                          height: 28.h,
                          child: Stack(children: [
                            SvgPicture.asset(
                              "$messengerAssets/icon_back.svg",
                              // fit: BoxFit.contain,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                )),
            centerTitle: false,
            titleSpacing: 0,
            elevation: 0,
            title: Text(
              getTranslatedStrings(context).messengerNewMessage,
              style: mainStyle(
                context,
                18.sp,
                fontFamily: AppFonts.interFont,
                weight: FontWeight.w500,
                color: Color(0xFF444444),
                textHeight: 0,
                letterSpacing: 0.33,
              ),
            ),
            actions: [
              IconButtonWidget(
                iconUrl: "$messengerAssets/icon_video_call.svg",
                btnClick: () {},
                iconWidth: 30.w,
                iconHeight: 30.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButtonWidget(
                iconUrl: "$messengerAssets/icon_search.svg",
                btnClick: () {},
                iconWidth: 25.w,
                iconHeight: 25.h,
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
                decoration: BoxDecoration(
                  color: bgAppBarColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SearchFieldWidget(),
                    TabBar(
                      padding: EdgeInsets.zero,
                      unselectedLabelColor: unSelectedColor,
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 2.w, color: indicatorColor),
                          borderRadius: BorderRadius.circular(5.r),
                          insets: EdgeInsets.symmetric(horizontal: 15.w)),
                      isScrollable: false,
                      tabs: [
                        Tab(
                          height: 15.h,
                          child: Text(
                            getTranslatedStrings(context).messengerPrimary,
                            style: mainStyle(
                              context,
                              12.sp,
                              fontFamily: AppFonts.interFont,
                              weight: FontWeight.w600,
                              color: _tabController!.index == 0
                                  ? selectedColor
                                  : unSelectedColor,
                            ),
                          ),
                        ),
                        Tab(

                          child: Text(
                            getTranslatedStrings(context).messengerMyContact,
                            style: mainStyle(
                              context,
                              12.sp,
                              fontFamily: AppFonts.interFont,
                              weight: FontWeight.w600,
                              color: _tabController!.index == 1
                                  ? selectedColor
                                  : unSelectedColor,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            getTranslatedStrings(context).messengerRequested,
                            style: mainStyle(
                              context,
                              12.sp,
                              fontFamily: AppFonts.interFont,
                              weight: FontWeight.w600,
                              color: _tabController!.index == 2
                                  ? selectedColor
                                  : unSelectedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Expanded(child: MessengerPrimaryPage()),
                    ComingSoonWidget(),
                    ComingSoonWidget(),
                  ],
                ),
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
        ),
      ),
    );
  }
}
