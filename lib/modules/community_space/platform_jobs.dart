import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';

class PlatformJobsLayout extends StatelessWidget {
  const PlatformJobsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Jobs',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: Column(
          children: [
            const JobTypesSelectorScrollable(),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => const JobCard(),
                separatorBuilder: (ctx, index) => heightBox(10.h),
                itemCount: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(4.0.sp),
      child: DefaultShadowedContainer(
        childWidget: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Senior receptionist',
                style: mainStyle(context,14, color: mainBlueColor),
              ),
              heightBox(10.h),
              Text(
                'AB Dental & Medical',
                style: mainStyle(context,15, weight: FontWeight.w600),
              ),
              heightBox(10.h),
              Text(
                'August 9 2022',
                style: mainStyle(context,13, color: softGreyColor),
              ),
              heightBox(10.h),
              const Text(
                'Senior receptionist Senior receptionist Senior receptionist Senior receptionist Senior receptionist'
                ' Senior receptionist Senior receptionist Senior receptionist',
                textAlign: TextAlign.justify,
              ),
              heightBox(10.h),
              const Text('Job type: '),
              heightBox(10.h),
              const Text('Job Classification: '),
              heightBox(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/icons/mylocation.svg',
                        height: 22.h,
                      ),
                      widthBox(5.w),
                      Text(
                        'Dubai-UAE',
                        style: mainStyle(context,
                          14,
                          color: softGreyColor,
                        ),
                      ),
                      widthBox(5.w),
                      Text(
                        '30 km',
                        style: mainStyle(context,13, color: mainBlueColor),
                      ),
                    ],
                  ),
                  const Text('company T N')
                ],
              ),
              heightBox(16.h),
              const JobActionBar()
            ],
          ),
        ),
      ),
    );
  }
}

class JobActionBar extends StatelessWidget {
  const JobActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemActions = [
      ActionItem(
        title: 'Likes',
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/love heart.svg',
              height: 18.sp,
            ),
            widthBox(2.sp),
            Text(
              '150',
              style: mainStyle(context,11.sp, color: mainBlueColor, textHeight: 0.8),
            )
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [...itemActions],
    );
  }
}
