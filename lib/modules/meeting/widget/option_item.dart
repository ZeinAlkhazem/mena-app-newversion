import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/constants.dart';
import '../cubit/meeting_cubit.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.onTap,
    required this.index,
    required this.title,
    required this.icon,
  });

  final VoidCallback onTap;
  final String title;
  final String icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    return SizedBox(
      height: 70.h,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocConsumer<MeetingCubit, MeetingState>(
              listener: (context, state) {},
              builder: (context, state) {
                return ElevatedButton(
                  style: ButtonStyle(
                    shape: const MaterialStatePropertyAll(CircleBorder()),
                    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: MaterialStatePropertyAll(
                        meetingCubit.selectItems.contains(index)
                            ? mainBlueColor
                            : const Color(0xffA3A3A3)),
                  ),
                  onPressed: onTap,
                  child: SvgPicture.asset(
                    icon,
                  ),
                );
              },
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xffa2a2a2),
                fontSize: 12.sp,
              ),
            ),
          ]),
    );
  }
}
