import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class DefaultVideoPlayer extends StatefulWidget {
  const DefaultVideoPlayer({Key? key, this.videoLink, this.videoFile})
      : super(key: key);

  final String? videoLink;
  final XFile? videoFile;

  @override
  _DefaultVideoPlayerState createState() => _DefaultVideoPlayerState();
}

class _DefaultVideoPlayerState extends State<DefaultVideoPlayer> {
  late VideoPlayerController _controller;
  bool isPlaying = false;



  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      logg('controller initial video file: ${widget.videoFile!.path}');
      File file = File(widget.videoFile!.path);
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        }).catchError((e) {
          logg(e.toString());
        });
    } else {
      /// video link so network
      logg('controller initial video link: ${widget.videoLink}');
      _controller = VideoPlayerController.network(widget.videoLink!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          isPlaying = false;
          // _controller.play();
        });
        // isPlaying=false;
        print('video Ended');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void playVideo() {
    setState(() {
      isPlaying = true;
      _controller.play();
    });
  }

  void pauseVideo() {
    setState(() {
      isPlaying = false;
      _controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 33,
      child: Center(
        child: _controller.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  if (isPlaying) {
                    pauseVideo();
                  } else {
                    playVideo();
                  }
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      isPlaying
                          ? SizedBox()
                          : CircleAvatar(child: Icon(Icons.play_arrow))
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }


}
