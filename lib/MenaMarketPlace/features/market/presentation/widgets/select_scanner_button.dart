// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectScanner extends StatelessWidget {
  final String textLabel;
  final IconData icon;
  final VoidCallback ontap;

  const SelectScanner({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: Colors.grey.shade200,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 6.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(
              width: 14.w,
            ),
            Text(
              textLabel,
              style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
