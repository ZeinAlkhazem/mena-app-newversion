import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Radius20Container extends StatelessWidget {
  const Radius20Container({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: const Radius.circular(0),
            bottomRight: const Radius.circular(0),
          ),
          color: Colors.white,
        ),
        child: child);
  }
}
