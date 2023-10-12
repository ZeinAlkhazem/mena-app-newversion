import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/constants.dart';
import 'card_comments_items.dart';

class CommentsLiveList extends StatelessWidget {
  const CommentsLiveList({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mainBlueColor,
              Colors.transparent,
              Colors.transparent,
              Colors.transparent
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const CardCommentsItems();
            }),
      ),
    );
  }
}
