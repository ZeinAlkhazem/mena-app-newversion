import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/cache/cache.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../messenger/messenger_home_page.dart';
import '../../messenger/messenger_layout.dart';

class MessengerIconBubble extends StatelessWidget {
  const MessengerIconBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return GestureDetector(
      onTap: () {
        getCachedToken() == null
            ? viewMessengerLoginAlertDialog(context)
            // : navigateToWithoutNavBar(context, const MessengerLayout(), '');
            : navigateToWithoutNavBar(context, const MessengerHomePage(), '');

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
                      'assets/svg/icons/msngrFilled.svg',
                      height: Responsive.isMobile(context) ? 29.w : 12.w,
                      width: Responsive.isMobile(context) ? 29.w : 12.w,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: NotificationCounterBubble(
                      counter: mainCubit.countersModel == null
                          ? '0'
                          : mainCubit.countersModel!.data.messages.toString()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
