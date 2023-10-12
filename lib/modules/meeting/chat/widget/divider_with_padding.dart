import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerWithPadding extends StatelessWidget {
  const DividerWithPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: const Divider(thickness: 3),
    );
  }
}
