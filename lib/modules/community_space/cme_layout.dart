import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/responsive/responsive.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';

import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import '../../models/local_models.dart';

class CMELayout extends StatelessWidget {
  const CMELayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultBackTitleAppBar(
            title: 'CME',
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context)
                  ? defaultHorizontalPadding
                  : defaultHorizontalPadding * 2),
          child: Column(
            children: [
              HorizontalSelectorScrollable(
                buttons: [
                  SelectorButtonModel(
                      title: 'test', onClickCallback: () {}, isSelected: true),
                  SelectorButtonModel(
                      title: 'test', onClickCallback: () {}, isSelected: true),
                  SelectorButtonModel(
                      title: 'test', onClickCallback: () {}, isSelected: true),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) => const CMECard(),
                  separatorBuilder: (ctx, index) => heightBox(15.h),
                  itemCount: 8,
                ),
              )
            ],
          ),
        ));
  }
}

class CMECard extends StatelessWidget {
  const CMECard({Key? key, this.cmeItem}) : super(key: key);

  final Cme? cmeItem;

  @override
  Widget build(BuildContext context) {
    List<Widget> itemActions = [
      ActionItem(
        title: 'Reviews',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/star.svg',
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '4.5',
              style:
                  mainStyle(context, 11, color: mainBlueColor, textHeight: 0.8),
            ),
          ],
        ),
      ),
      Container(
        width: 0.7,
        color: mainBlueColor,
        height: 30.h,
      ),
      ActionItem(
        title: 'Enquire',
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/enquire.svg',
          height: 18.sp,
        ),
      ),
      Container(
        width: 0.7,
        color: mainBlueColor,
        height: 30.h,
      ),
      ActionItem(
        title: 'share',
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/colored_share.svg',
          height: 18.sp,
        ),
      ),
      Container(
        width: 0.7,
        color: mainBlueColor,
        height: 30.h,
      ),
      ActionItem(
        title: 'save',
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/save.svg',
          height: 18.sp,
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DefaultShadowedContainer(
        childWidget: cmeItem == null
            ? const Text('No Cme Item')
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding,
                    vertical: defaultHorizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      cmeItem!.title,
                      style: mainStyle(context, 14, weight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text(
                          cmeItem!.date,
                          style: mainStyle(context, 11,
                              weight: FontWeight.w200, color: Colors.grey),
                        ),
                        widthBox(5.w),
                        Text(
                          cmeItem!.distance,
                          style: mainStyle(context, 12,
                              weight: FontWeight.w600, color: mainBlueColor),
                        ),
                      ],
                    ),
                    Text(
                      cmeItem!.description,
                      style: mainStyle(context, 12, weight: FontWeight.w200),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/icons/sand_clock.svg',
                                width: 15.sp,
                              ),
                              widthBox(5.w),
                              Text(
                                cmeItem!.date,
                                style: mainStyle(context, 11,
                                    weight: FontWeight.w600,
                                    color: mainBlueColor,
                                    textHeight: 1),
                              ),
                            ],
                          ),
                        ),
                        widthBox(8.w),
                        SizedBox(
                          height: 25.h,
                          // width: 50.w,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) => ProfileBubble(
                              isOnline: false,
                              pictureUrl: cmeItem!.logos[index] ?? '',
                              radius: 15,
                            ),
                            separatorBuilder: (cyx, index) => widthBox(2.w),
                            itemCount: cmeItem!.logos.length,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [...itemActions],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
