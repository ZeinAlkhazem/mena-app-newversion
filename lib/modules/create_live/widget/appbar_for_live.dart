import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/responsive/responsive.dart';
import '../cubit/create_live_cubit.dart';

PreferredSize defaultAppBarForLive(
  BuildContext context,
) {
  var createLiveCubit = CreateLiveCubit.get(context);
  return PreferredSize(
    preferredSize: Size.fromHeight(56.0.h),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Image.asset(
              'assets/images/live_appbar_logo.png',
              height: Responsive.isMobile(context) ? 18.w : 12.w,
            ),
            const Spacer(),
            PullDownButton(
              itemBuilder: (context) => [
                PullDownMenuItem(
                  textStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
                  title: 'Who can see my live stream',
                  onTap: () {
                    createLiveCubit.onPressSettingWhoCanSeeMyLive(context);
                  },
                ),
                // ignore: deprecated_member_use
                const PullDownMenuDivider(),
                PullDownMenuItem(
                  textStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
                  title: 'Who can comment on my live stream',
                  onTap: () => createLiveCubit.onPressWhoCanComment(context),
                ),
                // ignore: deprecated_member_use
                const PullDownMenuDivider(),
                PullDownMenuItem(
                  title: 'Clear mask cache (000 Mb)',
                  textStyle: TextStyle(color: Colors.red, fontSize: 14.sp),
                  onTap: () => createLiveCubit.onPressClearMaskCache(context),
                ),
              ],
              buttonBuilder: (context, showMenu) => CupertinoButton(
                onPressed: showMenu,
                padding: EdgeInsets.zero,
                child: SvgPicture.asset(
                  'assets/svg/icons/setting.svg',
                  height: Responsive.isMobile(context) ? 28.w : 12.w,
                ),
              ),
            ),
            widthBox(10.w),
          ],
        ),
      ),
    ),
  );
}

class DefaultBackTitleAppBar extends StatelessWidget {
  const DefaultBackTitleAppBar({
    Key? key,
    this.title,
    this.suffix,
  }) : super(key: key);

  final String? title;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widthBox(0.02.sw),
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
            widthBox(0.02.sw),
            Expanded(
              child: Text(
                title ?? '',
                style: mainStyle(context, 11,
                    weight: FontWeight.w400, color: Colors.black, isBold: true),
              ),
            ),
            suffix ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
