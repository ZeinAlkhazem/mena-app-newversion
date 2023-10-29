import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';

class NotificationIconBubble extends StatelessWidget {
  const NotificationIconBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // viewComingSoonAlertDialog(context);
        // getCachedToken() == null
        //     ? viewMessengerLoginAlertDialog(context)
        //     : navigateToWithoutNavBar(context, const MessengerLayout(), '');
      },
      child: SizedBox(
        height: Responsive.isMobile(context) ? 30.w : 12.w,
        width: Responsive.isMobile(context) ? 30.w : 12.w,
        child: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icons/notification.svg',
                      height: Responsive.isMobile(context) ? 25.w : 12.w,
                      width: Responsive.isMobile(context) ? 25.w : 12.w,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NotificationCounterBubble(
                      counter: MainCubit.get(context).countersModel == null
                          ? '0'
                          : MainCubit.get(context).countersModel!.data.notifications.toString()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}