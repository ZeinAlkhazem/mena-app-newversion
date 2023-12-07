import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayerScreen extends StatefulWidget {
  const FullScreenVideoPlayerScreen({super.key});

  @override
  State<FullScreenVideoPlayerScreen> createState() =>
      _FullScreenVideoPlayerScreenState();
}

class _FullScreenVideoPlayerScreenState
    extends State<FullScreenVideoPlayerScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    setLandscape();
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
    resetOrientations();
    super.dispose();
  }

  Future setLandscape() async {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
  }

  Future resetOrientations() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  String formatTime(Duration d) {
    return '${d.inHours}:${d.inMinutes.remainder(60)}:${d.inSeconds.remainder(60)}';
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = _controller.value.volume == 0;
    return Scaffold(
      body: GestureDetector(
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
              left: 10,
              top: 20,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
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
                    ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
