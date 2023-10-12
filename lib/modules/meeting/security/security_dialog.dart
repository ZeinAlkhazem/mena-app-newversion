import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/functions/main_funcs.dart';

class SecurityDialog extends StatelessWidget {
  SecurityDialog({super.key});

  final TextStyle? styleText = TextStyle(
      color: const Color(0xFF1A1A1A),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.01,
      height: 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'About Meeting',
              textAlign: TextAlign.center,
              style: mainStyle(context, 16.sp,
                  color: Colors.black,
                  isBold: true,
                  weight: FontWeight.w600,
                  textHeight: 2),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
        Text(
          'Lock Meeting',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Enable Waiting Room',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Hide Profile Pictures',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        const Divider(),
        Text(
          'Allow participants to:',
          textAlign: TextAlign.center,
          style: mainStyle(context, 16.sp,
              color: Colors.black,
              isBold: true,
              weight: FontWeight.w600,
              textHeight: 2),
        ),
        heightBox(5.h),
        Text(
          'Share Screen',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Chat',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Rename',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Start Video',
          textAlign: TextAlign.center,
          style: styleText,
        ),
        Text(
          'Start Whiteboards',
          textAlign: TextAlign.center,
          style: styleText,
        ),
      ],
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
