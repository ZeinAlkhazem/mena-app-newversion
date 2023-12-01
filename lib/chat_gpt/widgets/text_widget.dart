import 'package:flutter/material.dart';

import '../../../core/functions/main_funcs.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
      required this.label,
      this.fontSize = 14,
      this.color,
      this.fontWeight})
      : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        // textAlign: TextAlign.justify,
        style: mainStyle(context, fontSize));
  }
}
