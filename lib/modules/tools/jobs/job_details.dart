import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';

import '../../../core/shared_widgets/shared_widgets.dart';

class JobDetailsLayout extends StatelessWidget {
  const JobDetailsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'Job details',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultHorizontalPadding),
        child: Column(
          children: [
            Text('details'),
            Text('Test'),
            Text('Data')
          ],
        ),
      ),
    );
  }
}
