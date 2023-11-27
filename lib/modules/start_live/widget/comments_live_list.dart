// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
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
