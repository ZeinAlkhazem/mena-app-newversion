import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

import '../constants/constants.dart';
import '../functions/main_funcs.dart';

class DefaultAudioPlayer extends StatefulWidget {
  const DefaultAudioPlayer({
    Key? key,
    required this.audioFileLink,
    this.audioFile,
  }) : super(key: key);

  final String audioFileLink;
  final XFile? audioFile;

  @override
  State<DefaultAudioPlayer> createState() => _DefaultAudioPlayerState();
}

class _DefaultAudioPlayerState extends State<DefaultAudioPlayer> {
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  XFile? voiceFile;
  bool _mPlayerIsInited = false;

  void initPlayer() {
    _myPlayer.openPlayer().then((value) {
      _myPlayer.setSubscriptionDuration(const Duration(milliseconds: 100));
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  Future<void> playSound() async {
    logg('playing sound');
    isPlaying = true;
    // setState(() {});
    await _myPlayer.startPlayer(
      fromURI: voiceFile!.path,
      codec: Codec.aacADTS,
    );

    // await _myPlayer.startPlayer(
    //     fromURI: _exampleAudioFilePathMP3,
    //     codec: Codec.mp3,
    //     whenFinished: (){setState((){});}
    // );

    ///add setState in widget
  }

  Future<void> stopSoundPlay() async {
    isPlaying = false;
    setState(() {});
    await _myPlayer.stopPlayer();

    ///add setState in widget
  }

  getFileFromUrl(String url, AudioPlayer audioPlayer) async {
    if (widget.audioFile == null) {
      var file = await DefaultCacheManager().getSingleFile(url);
      voiceFile = await XFile(file.path);
      final duration = await audioPlayer.setUrl(
          // Load a URL
          url,
          preload: true);
      // if (duration != null) {
      //   // twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
      //   // twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
      // }
      // logg('duration::' + duration.toString());
    } else {
      voiceFile = await XFile(widget.audioFile!.path);
      final duration = await audioPlayer.setFilePath(
          // Load a URL
          widget.audioFile!.path,
          preload: true);
    }

    setState(() {});
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String? twoDigitsMinutes;
  String? twoDigitsSeconds;

  @override
  void initState() {
    // TODO: implement initState
    isPlaying = false;
    initPlayer();
    getFileFromUrl(widget.audioFileLink, audioPlayer);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _myPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: DefaultContainer(
          radius: 50.sp,
          // height: 22.h,
          backColor: Colors.transparent,
          borderColor: Colors.transparent,
          childWidget: Row(
            children: [
              Expanded(
                child: StreamBuilder<PlaybackDisposition>(
                  stream: _myPlayer.onProgress,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      logg('hasssss');
                      final duration =
                          snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                      if (snapshot.data!.position.inSeconds == duration.inSeconds) {
                        stopSoundPlay();
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          widthBox(5.w),
                          GestureDetector(
                            onTap: () {
                              isPlaying ? stopSoundPlay() : playSound();
                              setState(() {});
                            },
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: mainBlueColor,
                              size: 33.sp,
                            ),
                          ),
                          widthBox(5.w),
                          Expanded(
                              child: snapshot.data != null
                                  ? ProgressBar(
                                      barHeight: 1,
                                      thumbColor: mainBlueColor,
                                      thumbRadius: defaultRadiusVal,
                                      timeLabelPadding: 5,
                                      timeLabelLocation: TimeLabelLocation.sides,
                                      progress: Duration(
                                          seconds: int.parse(
                                              snapshot.data!.position.inSeconds.toString())),
                                      buffered: Duration(milliseconds: 0),
                                      total: Duration(
                                          seconds: int.parse(
                                              snapshot.data!.duration.inSeconds.toString())),
                                      onSeek: (duration) {
                                        _myPlayer.seekToPlayer(duration);
                                        logg('User selected a new time: $duration');
                                      },
                                    )
                                  : audioPlayer.duration == null
                                      ? LinearProgressIndicator()
                                      : ProgressBar(
                                          barHeight: 1,
                                          thumbColor: mainBlueColor,
                                          thumbRadius: defaultRadiusVal,
                                          timeLabelPadding: 5,
                                          timeLabelLocation: TimeLabelLocation.sides,
                                          progress: Duration(milliseconds: 0),
                                          buffered: Duration(milliseconds: 0),
                                          total: Duration(
                                              seconds: int.parse(
                                                  audioPlayer.duration!.inSeconds.toString())),
                                          // onSeek: (duration) {
                                          //   print(
                                          //       'User selected a new time: $duration');
                                          // },
                                        ))
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
