import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxButton extends StatelessWidget {
  const CheckboxButton({
    Key? key,
    required this.text,
    required this.onClick,
    required this.value,
  }) : super(key: key);
  final String text;
  final void Function(bool?)? onClick;

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onClick,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
