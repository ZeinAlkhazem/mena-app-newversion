import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/local_models.dart';
import 'job_details.dart';

class JobsLayout extends StatelessWidget {
  const JobsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Jobs',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultHorizontalPadding),
        child: Column(
          children: [
            NewHorizontalSelectorScrollable(
              buttons: [
                SelectorButtonModel(
                  onClickCallback: () {
                    logg('logVal');
                  },
                  title: 'test filter',
                  isSelected: true,
                ),
                SelectorButtonModel(
                  onClickCallback: () {},
                  title: 'test filter2',
                  isSelected: false,
                ),
              ],
            ),
            heightBox(10.h),
            GestureDetector(
              onTap: () {
                navigateToWithoutNavBar(context, JobDetailsLayout(), 'routeName');
              },
              child: DefaultContainer(
                childWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Senior receptionist'),
                      Text('AB Dental & medical Paddington NSW 2022'),
                      Text('August 05, 2022'),
                      Text('Lorem ipsum dolor sit amet, consecrate disciplining elite.'
                          ' Rhonchus dalesman pharaoh enum,'
                          ' at nec mus posuere sit amet, consecrate disciplining elite.'),
                      RichText(text: TextSpan(text: 'Job type:', children: [TextSpan(text: 'Full Time')])),
                      RichText(
                          text: TextSpan(text: 'Job Classification:', children: [
                        TextSpan(text: 'Management & Administration'),
                      ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                                text: TextSpan(text: 'Job Classification:', children: [
                              WidgetSpan(child: SvgPicture.asset('assets/svg/icons/like.svg')),
                              // TextSpan(text: 'sdl')
                              TextSpan(text: 'Management & Administration', style: mainStyle(context, 13)),
                              TextSpan(text: '30 km', style: mainStyle(context, 13)),
                            ])),
                          ),
                          SvgPicture.asset('assets/svg/icons/like.svg')
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text('data'),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('data'),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('data'),
                                ),
                              ),
                              // VerticalDivider(thickness: 1,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
