// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/start_live/cubit/start_live_cubit.dart';
import 'package:mena/modules/start_live/widget/comments_live_list.dart';
import 'package:mena/modules/start_live/widget/header_live_screen.dart';
import 'package:mena/modules/start_live/widget/live_message_inputfield.dart';
import 'package:mena/modules/start_live/widget/paused_live.dart';

class StackLive extends StatefulWidget {
  const StackLive({super.key, required this.switchCamera});

  final VoidCallback switchCamera;

  @override
  State<StackLive> createState() => _StackLiveState();
}

class _StackLiveState extends State<StackLive> with TickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 1500)
      ..forward();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StartLiveCubit startLiveCubit = StartLiveCubit.get(context);

    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Column(children: [
        heightBox(10.h),
        Visibility(visible: !keyboardVisible, child: const HeaderLiveScreen()),
        const Spacer(),
        BlocConsumer<StartLiveCubit, StartLiveState>(
          listener: (context, state) {},
          builder: (context, state) {
            return startLiveCubit.isLivePaused
                ? const PausedLive()
                : const SizedBox();
          },
        ),
        const Spacer(),
        BlocConsumer<StartLiveCubit, StartLiveState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocConsumer<StartLiveCubit, StartLiveState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Visibility(
                      visible:
                          !keyboardVisible && !animationController.isCompleted,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        width: double.infinity,
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                mainBlueColor,
                                mainBlueColor,
                                Colors.transparent,
                                Colors.transparent
                              ],
                              stops: const [0.0, 0.1, 0.9, 1.0],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: Lottie.asset(
                            'assets/lottie/hearts-feedback.json',
                            height: 200.h,
                            fit: BoxFit.contain,
                            repeat: false,
                            controller: animationController,
                          ),
                        ),
                      ),
                    ),
                    CommentsLiveList(
                      height: keyboardVisible
                          ? 0.15.sh
                          : startLiveCubit.heightComments,
                    ),
                    Visibility(
                      visible: !keyboardVisible,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        height: 40.h,
                        child: IconButton(
                          onPressed: () =>
                              startLiveCubit.onShowDescription(context),
                          icon: const Icon(
                            Icons.keyboard_arrow_up_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: BlocConsumer<StartLiveCubit, StartLiveState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return LiveMessageInputField(
                      suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: () => keyboardVisible
                              ? startLiveCubit.sendComment()
                              : startLiveCubit.emojiPicker(context),
                          icon: SvgPicture.asset(
                            color: newLightGreyColor,
                            keyboardVisible
                                ? 'assets/svg/icons/shareLocation.svg'
                                : 'assets/svg/vmoji_outline.svg',
                          )),
                      controller: startLiveCubit.liveMessageText,
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: !keyboardVisible,
              child: IconButton(
                onPressed: () {
                  return widget.switchCamera.call();
                },
                icon: SvgPicture.asset(
                  'assets/svg/camera_outline_gray.svg',
                ),
              ),
            ),
            Visibility(
              visible: !keyboardVisible,
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/svg/user_add_gray.svg',
                ),
              ),
            ),
            Visibility(
              visible: !keyboardVisible,
              child: LikeButton(
                size: 25.sp,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                onTap: (isLiked) async {
                  isLiked ? null : animationController.reset();

                  animationController.duration =
                      const Duration(milliseconds: 1500);

                  isLiked ? null : animationController.forward();

                  startLiveCubit.onLikeButtonTapped(isLiked);

                  return !isLiked;
                },
                likeBuilder: (bool isLiked) {
                  return SvgPicture.asset(
                    isLiked
                        ? 'assets/svg/icons/love heart.svg'
                        : 'assets/svg/icons/loveHeart.svg',
                    color: isLiked ? alertRedColor : newLightGreyColor,
                  );
                },
              ),
            ),
          ],
        ),
        heightBox(10.h)
      ]),
    );
  }
}
