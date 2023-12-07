
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProviderIconWidget extends StatelessWidget {
  final String title;
  final String icon;
  const ProviderIconWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(icon),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF444444),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ],
    );
  }
}
