import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/functions/main_funcs.dart';
import '../../../../models/local_models.dart';

class PullDown extends StatelessWidget {
  const PullDown(
      {super.key,
      required this.svgLink,
      required this.svgHeight,
      this.customOffset,
      this.customButtonWidget,
      this.customWidth,
      this.customPosition,
      required this.items});
  final String svgLink;
  final double svgHeight;
  final Offset? customOffset;
  final Widget? customButtonWidget;
  final double? customWidth;
  final PullDownMenuPosition? customPosition;
  final List<ItemWithTitleAndCallback> items;

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) => items
          .map((e) => CustomPullDownItem2(
                onTap:
                    // jumpToCategory(widget.buttons.indexOf(e));
                    e.onClickCallback,
                title: e.title,
                svgLink: e.thumbnailLink,
              ))
          .toList(),
      position: customPosition ?? PullDownMenuPosition.over,
      backgroundColor: Colors.white,
      offset: customOffset ?? const Offset(-2, 1),
      applyOpacity: true,
      widthConfiguration:
          PullDownMenuWidthConfiguration(customWidth ?? 0.77.sw),
      buttonBuilder: (context, showMenu) => GestureDetector(
        onTap: showMenu,
        child: customButtonWidget ??
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  svgLink,
                  height: svgHeight,
                ),
              ),
            ),
      ),
    );
  }
}

class CustomPullDownItem2 extends PullDownMenuEntry {
  CustomPullDownItem2({
    required this.title,
    required this.svgLink,
    this.onTap,
    // String? title,
  });

  final String? title;
  final String? svgLink;
  final Function()? onTap;

  // String get title => title;
  // final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              svgLink != null
                  ? SvgPicture.asset(
                      svgLink!,
                      height: 22.h,
                    )
                  : SizedBox(
                      height: 28.h,
                    ),
              widthBox(16.w),
              Expanded(
                child: Text(
                  title ?? '---',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
// height: 0.14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement height
  double get height => throw UnimplementedError();

  @override
  // TODO: implement isDestructive
  bool get isDestructive => throw UnimplementedError();

  @override
  // TODO: implement represents
  bool get represents => throw UnimplementedError();
}
