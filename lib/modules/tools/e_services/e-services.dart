import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../../../core/shared_widgets/shared_widgets.dart';

class EServicesLayout extends StatefulWidget {
  const EServicesLayout({Key? key}) : super(key: key);

  @override
  State<EServicesLayout> createState() => _EServicesLayoutState();
}

class _EServicesLayoutState extends State<EServicesLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'E-Services',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultHorizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DefaultImageFadeInOrSvg(
                backGroundImageUrl: 'backGroundImageUrl',
                height: 0.3.sh,
                width: double.maxFinite,
              ),
              ListView.separated(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(2),
                  child: DefaultShadowedContainer(
                    customOffset: Offset(1, 1),
                    childWidget: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultHorizontalPadding,
                        vertical: defaultHorizontalPadding + 5,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              DefaultImageFadeInOrSvg(
                                backGroundImageUrl: '',
                              ),
                              Text(index.toString()),
                            ],
                          )),
                          SvgPicture.asset('assets/svg/icons/link.svg')
                        ],
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (c, i) => heightBox(10.h),
                itemCount: 10,
                shrinkWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
