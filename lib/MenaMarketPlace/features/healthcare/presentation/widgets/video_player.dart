import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import 'package:mena/MenaMarketPlace/features/healthcare/presentation/pages/fullscreen_video_player_screen.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://player.vimeo.com/external/398032411.sd.mp4?s=51ab47485884713a2a47f09374067d718aaea74d&profile_id=164&oauth2_token_id=57447761',
      ),
    )
      ..addListener(() => setState(() {}))
      ..initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    return '${d.inHours}:${d.inMinutes.remainder(60)}:${d.inSeconds.remainder(60)}';
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = _controller.value.volume == 0;
    return GestureDetector(
      onTap: () => _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const CircularProgressIndicator(),
          ),
          Positioned(
            right: 10,
            top: 20,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                    backgroundColor: Color(0x4C252836),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/menamarket/heart_circle_outline_28 2.svg',
                ),
                const SizedBox(
                  height: 10,
                ),
                SvgPicture.asset(
                  'assets/menamarket/share_external_outline_28 3.svg',
                ),
              ],
            ),
          ),
          const Positioned(
            left: 10,
            top: 20,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: CircleAvatar(
                backgroundColor: Color(0x4C252836),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 25,
            bottom: 50,
            child: Container(
              width: 69,
              padding: const EdgeInsets.all(5),
              decoration: ShapeDecoration(
                color: const Color(0x99EBEBEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '4.2',
                    style: TextStyle(
                      color: Color(0xFF393F42),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Text(
                    '400',
                    style: TextStyle(
                      color: Color(0xFF393F42),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_controller.value.isPlaying)
            const SizedBox.shrink()
          else
            Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: const CircleAvatar(
                backgroundColor: Color(0x4C252836),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50.h,
              color: const Color(0x4C252836),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    formatTime(_controller.value.position),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  )
                  // Slider(
                  //   value: 0,
                  //   activeColor: Colors.white,
                  //   inactiveColor: Colors.grey,
                  //   onChanged: (value) {},
                  // ),
                  ,
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    formatTime(_controller.value.duration),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      _controller.setVolume(isMuted ? 1 : 0);
                    },
                    child: Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FullScreenVideoPlayerScreen(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/menamarket/fullscreen_outline_28 2.svg',
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
