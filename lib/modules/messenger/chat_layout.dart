import 'dart:io';
// import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/home_section_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/main_cubit/main_cubit.dart';
import '../../core/shared_widgets/attachments_grid.dart';
import '../../core/shared_widgets/attacment_gallery.dart';
import '../../core/shared_widgets/default_audio_player.dart';
import '../../core/shared_widgets/default_video_player.dart';
import '../../core/shared_widgets/pdf_view_layout.dart';
import '../../models/api_model/chat_messages_model.dart';
import '../../models/api_model/my_messages_model.dart';

// import '../../models/api_model/register_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat/cubit/messenger_cubit.dart';

class ChatLayout extends StatefulWidget {
  const ChatLayout({
    Key? key,
    this.user,
    this.chatId,
  }) : super(key: key);

  final User? user;

  final String? chatId;

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  IO.Socket? socket;

  @override
  void initState() {
    // TODO: implement initState
    var messengerCubit = MessengerCubit.get(context);

    messengerCubit.resetAttachedFile();
    messengerCubit.resetChatModel();
    if (widget.chatId == null) {
      if (widget.user != null) {
        messengerCubit.fetchChatMessagesByIdType(
            toIdProviderId: widget.user!.id.toString(), toTypeRoleName: widget.user!.roleName.toString());
      }
    } else {
      messengerCubit.fetchChatMessagesByChatId(
        chatId: widget.chatId!,
      );
    }

    socket = MainCubit.get(context).socket;
    socket?.on('message', (data) {
      logg('new message socket: $data');
      if (widget.chatId == null) {
        if (widget.user != null) {
          messengerCubit.fetchChatMessagesByIdType(
              toIdProviderId: widget.user!.id.toString(), toTypeRoleName: widget.user!.roleName.toString());
        }
      } else {
        messengerCubit.fetchChatMessagesByChatId(chatId: widget.chatId!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
//     var messengerCubit = MessengerCubit.get(context);
// messengerCubit.fetchMyMessages();
    socket?.off('message');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double inDy = 0;
    double lastDy = 0;
    var messengerCubit = MessengerCubit.get(context);
    // messengerCubit.resetChatModel();

    return WillPopScope(
      onWillPop: () async {
        debugPrint("Will pop");
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(),
          // resizeToAvoidBottomInset: true,
          // floatingActionButton: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     FloatingActionButton(
          //       child: Text('tmp'),
          //       onPressed: () {
          //         if (widget.chatId == null) {
          //           if (widget.user != null) {
          //             messengerCubit.fetchChatMessagesByIdType(
          //                 toIdProviderId: widget.user!.id.toString(),
          //                 toTypeRoleName: widget.user!.roleName.toString());
          //           }
          //         } else {
          //           messengerCubit.fetchChatMessagesByChatId(chatId: widget.chatId!);
          //         }
          //       },
          //     ),
          //     heightBox(0.5.sh)
          //   ],
          // ),
          body: BlocConsumer<MessengerCubit, MessengerState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(top: topScreenPadding),
                child: messengerCubit.chatMessagesModel == null
                    ? DefaultLoaderGrey()
                    : Column(
                        children: [
                          ChatHeader(
                            user: widget.user,
                            chatId: messengerCubit
                                .chatMessagesModel!.data.chatId
                                .toString(),
                            // userName:userName,
                            // userPic:userPic,
                          ),
                          Expanded(
                              child: Listener(
                            onPointerDown: (e) {
                              inDy = e.localPosition.dy;
                            },
                            onPointerUp: (event) {
                              lastDy = event.localPosition.dy;
                              logg('iny: ${inDy.toString()}');
                              logg('lastDy: ${lastDy.toString()}');
                              if (lastDy != inDy) {
                                logg('pointer moved');
                              } else {
                                logg('pointer not moved');
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.focusedChild?.unfocus();
                                }
                              }
                            },
                            child: ChatBody(
                              messages: messengerCubit.chatMessagesModel!.data.messages,
                              provider: widget.user!,
                            ),
                          )),
                          (state is GettingMessagesData || state is SendingMsgState)
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: LinearProgressIndicator(
                                    minHeight: 2.h,
                                  ),
                                )
                              : SizedBox(
                                  height: 2.h,
                                ),
                          ChatTail(
                            toId: widget.user!.id.toString(),
                            toType: widget.user!.roleName.toString(),
                          ),
                        ],
                      ),
              ));
            },
          )),
    );
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
    required this.messages,
    required this.provider,
  }) : super(key: key);
  final List<ChatMessage> messages;

  final User provider;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [mainBlueColor, Colors.transparent, Colors.transparent, Colors.transparent],
          stops: const [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: messages.isEmpty
          // ? Center(child: Text('Start chat with ${provider.fullName}'))
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/no messages.json'),
                Text(
                  getTranslatedStrings(context).noMessagesHereYet,
                  style: mainStyle(context, 12, color: newDarkGreyColor, isBold: true),
                ),
                heightBox(7.h),
                Text(
                  getTranslatedStrings(context).whyNotStartChat,
                  style: mainStyle(context, 12, color: newDarkGreyColor, isBold: false),
                ),
              ],
            ))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: messages.length,
                      padding: EdgeInsets.only(top: 45.h),
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child:
                              // index.isOdd
                              messages[index].isMyMessage
                                  ? OutMsg(
                                      message: messages[index],
                                    )
                                  : InMsg(
                                      message: messages[index],
                                    ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}

class InMsg extends StatelessWidget {
  const InMsg({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.from != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ProfileBubble(
              isOnline: false,
              pictureUrl: message.from!.personalPicture!,
              radius: 16.sp,
            ),
          ),
        widthBox(6.w),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: chatGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: chatGreyColor,
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  child: MessageBody(message: message),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Text(
                      //   message.fromName??'',
                      //   style: mainStyle(context, 11,
                      //       weight: FontWeight.w600, color: mainBlueColor),
                      // ),
                      SizedBox(width: 10.w),

                      Text(getFormattedDate(message.createdAt),
                          textAlign: TextAlign.center, style: mainStyle(context, 8, color: Colors.black)),
                      // const SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
        widthBox(0.2.sw)
      ],
    );
  }
}

class OutMsg extends StatelessWidget {
  const OutMsg({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widthBox(0.2.sw),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: chatBlueColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: chatBlueColor,
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageBody(message: message),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                // Divider(),
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgPicture.asset('assets/svg/icons/correct.svg'),
                      const SizedBox(width: 10),
                      Text(
                        getFormattedDate(message.createdAt),
                        textAlign: TextAlign.center,
                        style: mainStyle(context, 8, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MessageBody extends StatelessWidget {
  const MessageBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.files != null)
          if (message.files!.isNotEmpty)
            // message.files!.length>1?
            AttachmentsGrid(
                files: message.files!,
                autoplay: false,
                onAttachClicked: (i) {
                  logg('current file index: $i');
                  navigateToWithoutNavBar(
                      context,
                      AttachmentsGallery(
                        files: message.files!,
                        customFileIndex: i,
                      ),
                      '');
                  // go to slider specific view
                },
                onExpandClicked: () {
                  navigateToWithoutNavBar(
                      context,
                      AttachmentsGallery(
                        files: message.files!,
                        customFileIndex: 3,
                      ),
                      '');
                  // logg('expand clicked');
                  // navigateToWithoutNavBar(
                  //     context,
                  //     FeedDetailsLayout(
                  //       menaFeed: menaFeed,
                  //       customFileIndex: 4,
                  //     ),
                  //     '');
                },
                maxLength: 4,
                key: key),
        // AttachmentHandlerWidget(type: message.type, file: message.files!),
        SizedBox(
          height: message.type == "" ? 0 : 3.h,
        ),
        message.message.isEmpty
            ? SizedBox()
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message.message,
                  textAlign: TextAlign.left,
                  style: mainStyle(context, 14, textHeight: 1.3, weight: FontWeight.w800),
                ),
              )
      ],
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    Key? key,
    required this.user,
    required this.chatId,
  }) : super(key: key);

  final User? user;

  final String? chatId;

  // final String? userName;
  // final String? userPic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/icons/back.svg',
                        color: mainBlueColor,
                      ),
                    ),
                  ),
                ),
                widthBox(0.06.sw),
                Expanded(
                  child: Row(
                    children: [
                      ProfileBubble(
                        isOnline: true,
                        radius: 18.h,
                        pictureUrl: user!.personalPicture,
                      ),
                      widthBox(5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getFormattedUserName(user!),
                              style: mainStyle(context, 12, isBold: true),
                            ),
                            if (user!.specialities != null) heightBox(4.h),
                            if (user!.specialities != null && user!.specialities!.length > 0)
                              Text(
                                '${user!.specialities![0].name ?? ''}',
                                style: mainStyle(context, 9, isBold: true, color: mainBlueColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Text('test'),
          OptionsMenu(
            hide: false,
            chatId: chatId,
          )
        ],
      ),
    );
  }
}

/// chat tail
///
///
class ChatTail extends StatefulWidget {
  const ChatTail({
    Key? key,
    required this.toId,
    required this.toType,
  }) : super(key: key);
  final String toId;
  final String toType;

  @override
  State<ChatTail> createState() => _ChatTailState();
}

class _ChatTailState extends State<ChatTail> with TickerProviderStateMixin {
  late AnimationController _recordingAnimController;
  late Animation<double> _recordingAnimation;

  // FocusNode _focus = FocusNode();

  TextEditingController _chatInputTextController = TextEditingController();

  String? test;
  String? test2;
  bool isTyping = false;
  bool isRecorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  String? path;
  bool _mPlayerIsInited = false;
  Duration duration = Duration.zero;

  @override
  initState() {
    super.initState();
    isTyping = false;
    isRecorderReady = false;
    // isRecording = false;
    isPlaying = false;
    // _focus.addListener(_onFocusChange);
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    initRecorder();

    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    initPlayer();

    _recordingAnimController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _recordingAnimation = CurvedAnimation(parent: _recordingAnimController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _recordingAnimController.dispose();
    // _focus.removeListener(_onFocusChange);
    // _focus.dispose();
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer.closePlayer();
    isRecorderReady = false;
    // _myPlayer = null;

    // Be careful : you must `close` the audio session when you have finished with it.
    myRecorder.closeRecorder();
    super.dispose();
  }

  /// sound
  ///   /// sound functions and initialization
  FlutterSoundRecorder myRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();

  Future<void> initRecorder() async {
    // final status=await Permission.microphone.request();
    // if(status!=PermissionStatus.granted){
    //   throw 'Microphone permission not granted';
    // }
    await Permission.microphone.request();
    logg('mic permission granted');
    await myRecorder.openRecorder();
    isRecorderReady = true;
    myRecorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    setState(() {
      logg('recorder initialized');
    });

    /// THIS IS THE KEY OF VOICE MAYYA
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  void initPlayer() {
    _myPlayer.openPlayer().then((value) {
      _myPlayer.setSubscriptionDuration(const Duration(milliseconds: 100));
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  Future<void> record() async {
    if (isRecorderReady) {
      logg('isRecorderReady true');
      logg('start record');
      isRecording = true;
      var tempDir = await getTemporaryDirectory();
      path = '${tempDir.path}/sound.aac';
      logg('path' + path.toString());
      await myRecorder
          .startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      )
          .then((value) {
        logg('recording started x:');
        setState(() {
          logg('isRecording = true; set state');
          isRecording = true;
        });
      });
    }
  }

  File? audioFile;

  Future<File> stopRecorder() async {
    logg('stop record');
    // MessengerCubit.get(context).toggleRecording(false);
    isRecording = false;
    final recordedPath = await myRecorder.stopRecorder();
    audioFile = File(recordedPath!);
    logg('recorder path ${recordedPath.toString()}');
    setState(() {
      logg('isRecording = false; set state');
      isRecording = false;
    });
    return audioFile!;
  }

  Future<void> playSound() async {
    logg('playing sound');
    isPlaying = true;
    // setState(() {});
    await _myPlayer.startPlayer(fromURI: path, codec: Codec.aacADTS);

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

  /// sound functions end

  // void _onFocusChange() {
  //   logg("Focus changed: ${_focus.hasFocus.toString()}");
  //   // isTyping=(_focus.hasFocus||_controller.text.isNotEmpty);
  //   // setState(() {
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);

    ///
    ///
    ///
    ///
    ///
    /// Caution this stateless is already listening to Messenger Cubit from the parent
    ///
    ///
    ///
    ///
    ///
    List<Widget> vibesChildren = [];
    bool voiceDurationPositive = false;
    // bool test=false;
    return BlocConsumer<MessengerCubit, MessengerState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SuccessSendingMsgState) {
          _chatInputTextController.text = '';
          messengerCubit.resetAttachedFile();
          setState(() {
            isTyping = false;
            logg('isTyping=false;');
          });
        }
      },
      builder: (context, state) {
        return Container(
            child: Container(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding, vertical: 1),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        /*   decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0.r),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                          ],
                        ),*/
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                /// recording
                                (isRecording ||
                                        messengerCubit.recorderVoice != null)
                                    ? Expanded(
                                        child: Center(
                                          child: DefaultContainer(
                                            radius: 50.sp,
                                            height: 66.h,
                                            backColor: chatGreyColor,
                                            borderColor: Colors.transparent,
                                            childWidget: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: StreamBuilder<
                                                      RecordingDisposition>(
                                                  stream: myRecorder.onProgress,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      // if((_myPlayer.isPaused||_myPlayer.isStopped)){
                                                      //
                                                      //   setState(() {
                                                      //     isPlaying=false;
                                                      //   });
                                                      // }
                                                      vibesChildren.add(Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        child: Container(
                                                          width: 2,
                                                          height: snapshot.data!
                                                                  .decibels! /
                                                              3,
                                                          color: mainBlueColor,
                                                        ),
                                                      ));

                                                      logg(
                                                          'vibesChildren length' +
                                                              vibesChildren
                                                                  .length
                                                                  .toString());
                                                    }
                                                    logg(
                                                        'hsdg${snapshot.toString()}');
                                                    logg(
                                                        'has Data? ${snapshot.hasData ? 'has data' : 'No data'}');
                                                    logg(
                                                        '${snapshot.hasData ? snapshot.data!.duration : Duration.zero}');
                                                    duration = snapshot.hasData
                                                        ? snapshot
                                                            .data!.duration
                                                        : Duration.zero;

                                                    String twoDigits(int n) => n
                                                        .toString()
                                                        .padLeft(2, '0');

                                                    final twoDigitsMinutes =
                                                        twoDigits(duration
                                                            .inMinutes
                                                            .remainder(60));
                                                    final twoDigitsSeconds =
                                                        twoDigits(duration
                                                            .inSeconds
                                                            .remainder(60));
                                                    return SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                (!isRecording)
                                                                    ? Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                messengerCubit.updateVoiceFile(null);
                                                                              },
                                                                              child: Container(
                                                                                color: Colors.transparent,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                          widthBox(
                                                                              1.w),
                                                                          Expanded(
                                                                              child: DefaultAudioPlayer(audioFile: messengerCubit.recorderVoice, audioFileLink: '')),
                                                                          //         StreamBuilder<
                                                                          //         PlaybackDisposition>(
                                                                          //   stream: _myPlayer
                                                                          //           .onProgress,
                                                                          //   builder: (context,
                                                                          //           snapshot) {
                                                                          //         if (snapshot
                                                                          //             .hasData) {
                                                                          //           if (snapshot
                                                                          //               .data!
                                                                          //               .position
                                                                          //               .inSeconds ==
                                                                          //               duration
                                                                          //                   .inSeconds) {
                                                                          //             stopSoundPlay();
                                                                          //           }
                                                                          //         }
                                                                          //         return GestureDetector(
                                                                          //           onTap: () {
                                                                          //             isPlaying
                                                                          //                 ? stopSoundPlay()
                                                                          //                 : playSound();
                                                                          //
                                                                          //             setState(
                                                                          //                     () {});
                                                                          //           },
                                                                          //           child: Icon(
                                                                          //             isPlaying
                                                                          //                 ? Icons
                                                                          //                 .pause_circle_outline
                                                                          //                 : Icons
                                                                          //                 .play_circle_outline,
                                                                          //             color: Colors
                                                                          //                 .green,
                                                                          //             size: 33,
                                                                          //           ),
                                                                          //         );
                                                                          //   },
                                                                          // ),
                                                                        ],
                                                                      )
                                                                    : Container(
                                                                        // color:Colors.yellow,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          reverse:
                                                                              true,
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              ...vibesChildren
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                          ),
                                                          // widthBox(5.w),
                                                          // Row(
                                                          //   children: [
                                                          //     Text(
                                                          //       '$twoDigitsMinutes : $twoDigitsSeconds',
                                                          //       style: const TextStyle(
                                                          //           fontSize:
                                                          //               14,
                                                          //           color: Colors
                                                          //               .green),
                                                          //     ),
                                                          //     const SizedBox(
                                                          //       width: 5,
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ),
                                      )
                                    :

                                    /// not recording
                                    ///
                                    /// check if there is a voice
                                    /// let him view voice or delete it
                                    ///
                                    // messengerCubit.recorderVoice!=null?
                                    // Expanded(
                                    //   child: DefaultAudioPlayer(
                                    //     audioFile: messengerCubit.recorderVoice!,
                                    //   ),
                                    // )
                                    //
                                    // ///
                                    //     :
                                    Expanded(
                                        child: DefaultContainer(
                                          radius: 30.sp,
                                          backColor: newLightGreyColor,
                                          borderColor: Colors.transparent,
                                          childWidget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              messengerCubit
                                                      .attachedFiles.isEmpty
                                                  ? SizedBox()
                                                  : SizedBox(
                                                      height: 0.15.sh,
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal:
                                                                    defaultHorizontalPadding *
                                                                        1.2),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return AttachedFileHandle(
                                                              customWidthForHorizontalView:
                                                                  0.3.sw,
                                                              xfile: messengerCubit
                                                                      .attachedFiles[
                                                                  index],
                                                              // customHeight: 100.h,
                                                              fn: () => messengerCubit
                                                                  .removeAttachedFile(
                                                                      index));
                                                        },
                                                        separatorBuilder:
                                                            (_, i) =>
                                                                heightBox(5.h),
                                                        itemCount:
                                                            messengerCubit
                                                                .attachedFiles
                                                                .length,
                                                      ),
                                                    ),
                                              messengerCubit
                                                      .attachedFiles.isEmpty
                                                  ? SizedBox()
                                                  : Divider(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    // IconButton(
                                                    //     icon: Icon(
                                                    //       Icons.face,
                                                    //       color: Colors.blueAccent,
                                                    //     ),
                                                    //     onPressed: () {}
                                                    //     ),
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Container(
                                                                            // height: 0.22.sh,
                                                                            color:
                                                                                Colors.white,
                                                                            child:
                                                                                SafeArea(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      getTranslatedStrings(context).takePhotoRecordVideo,
                                                                                      style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                                                                    ),
                                                                                    heightBox(15.h),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: DefaultButton(
                                                                                            // color: Colors.white,
                                                                                            backColor: newLightGreyColor,

                                                                                            borderColor: Colors.transparent,
                                                                                            height: 0.07.sh,
                                                                                            // width: 33.w,
                                                                                            text: getTranslatedStrings(context).image,
                                                                                            customChild: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  getTranslatedStrings(context).image,
                                                                                                  style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                                                                                                ),
                                                                                                widthBox(7.w),
                                                                                                SvgPicture.asset('assets/svg/icons/camera.svg')
                                                                                              ],
                                                                                            ),
                                                                                            onClick: () async {
                                                                                              {
                                                                                                // Either the permission was already granted before or the user just granted it.
                                                                                                final ImagePicker _picker = ImagePicker();
                                                                                                final XFile? photo = await _picker
                                                                                                    .pickImage(
                                                                                                  source: ImageSource.camera,
                                                                                                )
                                                                                                    .then((value) async {
                                                                                                  logg('photo picked');
                                                                                                  messengerCubit.updateAttachedFile(value);
                                                                                                  await Future.delayed(Duration(milliseconds: 100));
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        widthBox(10.w),
                                                                                        Expanded(
                                                                                          child: DefaultButton(
                                                                                            height: 0.07.sh,
                                                                                            backColor: newLightGreyColor,
                                                                                            borderColor: Colors.transparent,
                                                                                            text: getTranslatedStrings(context).video,
                                                                                            customChild: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  getTranslatedStrings(context).video,
                                                                                                  style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                                                                                                ),
                                                                                                widthBox(7.w),
                                                                                                SvgPicture.asset('assets/svg/icons/video camera.svg')
                                                                                              ],
                                                                                            ),
                                                                                            onClick: () async {
                                                                                              {
                                                                                                // Either the permission was already granted before or the user just granted it.
                                                                                                final ImagePicker _picker = ImagePicker();
                                                                                                final XFile? photo = await _picker
                                                                                                    .pickVideo(
                                                                                                  source: ImageSource.camera,
                                                                                                )
                                                                                                    .then((value) async {
                                                                                                  logg('photo picked');
                                                                                                  messengerCubit.updateAttachedFile(value);
                                                                                                  await Future.delayed(Duration(milliseconds: 100));
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });

                                                                    ///
                                                                    /// old implement
                                                                    ///
                                                                    logg(
                                                                        'picking PIC');
                                                                    // var status = await Permission
                                                                    //     .camera.status;
                                                                    // logg(status.name.toString());
                                                                    // {
                                                                    //   // Either the permission was already granted before or the user just granted it.
                                                                    //   final ImagePicker _picker =
                                                                    //       ImagePicker();
                                                                    //   final XFile? photo =
                                                                    //       await _picker
                                                                    //           .pickImage(
                                                                    //     source: ImageSource.camera,
                                                                    //   )
                                                                    //           .then((value) {
                                                                    //     logg('photo picked');
                                                                    //     messengerCubit
                                                                    //         .updateAttachedFile(
                                                                    //             value);
                                                                    //   });
                                                                    // }
                                                                    // if (await Permission.camera
                                                                    //     .request()
                                                                    //     .isRestricted)
                                                                    // {
                                                                    //   showMyAlertDialog(
                                                                    //       context, 'No permission',
                                                                    //       alertDialogContent: Column(
                                                                    //         mainAxisSize:
                                                                    //         MainAxisSize.min,
                                                                    //         children: [
                                                                    //           Text(
                                                                    //             'You don\'t have permission to access',
                                                                    //             style: mainStyle(
                                                                    //                 context, 13),
                                                                    //             textAlign:
                                                                    //             TextAlign.center,
                                                                    //           ),
                                                                    //           heightBox(10.h),
                                                                    //           Text(
                                                                    //             'You can edit permission settings in your device to proceed',
                                                                    //             style: mainStyle(
                                                                    //                 context, 13),
                                                                    //             textAlign:
                                                                    //             TextAlign.center,
                                                                    //           ),
                                                                    //           heightBox(10.h),
                                                                    //           DefaultButton(
                                                                    //               text:
                                                                    //               'Open app setting',
                                                                    //               onClick: () {
                                                                    //                 openAppSettings();
                                                                    //               })
                                                                    //         ],
                                                                    //       ));
                                                                    // }else
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    // height: 44.sp,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .blueAccent,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Center(
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          'assets/svg/icons/camera.svg',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              widthBox(3.w),
                                                              Expanded(
                                                                child:
                                                                    ChatInputField(
                                                                  controller:
                                                                      _chatInputTextController,
                                                                  customTextInputType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  unFocusedBorderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusedBorderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  // label:'Message...',
                                                                  labelWidget: Text(
                                                                      getTranslatedStrings(context)
                                                                              .message +
                                                                          '...'),
                                                                  maxLines: 3,
                                                                  // labelWidget: Text(
                                                                  //   'Message...',
                                                                  //   style: mainStyle(context, 12,
                                                                  //       color: softGreyColor),
                                                                  // ),
                                                                  onFieldChanged:
                                                                      (text) {
                                                                    if (text
                                                                        .isEmpty) {
                                                                      if (isTyping) {
                                                                        setState(
                                                                            () {
                                                                          isTyping =
                                                                              false;
                                                                          logg(
                                                                              'isTyping=false;');
                                                                        });
                                                                      }
                                                                    } else {
                                                                      /// text not empty
                                                                      /// so is typing tru
                                                                      if (!isTyping) {
                                                                        setState(
                                                                            () {
                                                                          logg(
                                                                              ' isTyping=true;');
                                                                          isTyping =
                                                                              true;
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  customHintText:
                                                                      getTranslatedStrings(context)
                                                                              .message +
                                                                          '...',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //
                                                    // (isTyping
                                                    //     ||
                                                    //         voiceDurationPositive
                                                    //     ||
                                                    //         messengerCubit
                                                    //             .attachedFiles.isNotEmpty
                                                    //     // check if there is avoice
                                                    //     )
                                                    //     ?
                                                    //
                                                    //     /// send msg
                                                    //     Row(
                                                    //         children: [
                                                    //           SizedBox(width: 7.w),
                                                    //           InkWell(
                                                    //             child: Padding(
                                                    //               padding:
                                                    //                   const EdgeInsets.all(
                                                    //                       2.0),
                                                    //               child: Container(
                                                    //                 padding:
                                                    //                     const EdgeInsets
                                                    //                         .all(14.0),
                                                    //                 decoration:
                                                    //                     BoxDecoration(
                                                    //                         color: Colors
                                                    //                             .blueAccent,
                                                    //                         shape: BoxShape
                                                    //                             .circle),
                                                    //                 child: Icon(
                                                    //                   Icons.send_outlined,
                                                    //                   color: Colors.white,
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //             onTap: () {
                                                    //               messengerCubit
                                                    //                   .sendMessage(
                                                    //                     toId: widget.toId,
                                                    //                     toType:
                                                    //                         widget.toType,
                                                    //                     msg:
                                                    //                         _chatInputTextController
                                                    //                             .text,
                                                    //                   )
                                                    //                   .then((value) =>
                                                    //                       messengerCubit
                                                    //                           .fetchChatMessagesByIdType(
                                                    //                         toIdProviderId:
                                                    //                             widget.toId,
                                                    //                         toTypeRoleName:
                                                    //                             widget
                                                    //                                 .toType,
                                                    //                       ));
                                                    //             },
                                                    //           ),
                                                    //         ],
                                                    //       )
                                                    //     :
                                                    /// action panel
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  logg(
                                                                      'picking gallery');
                                                                  showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Container(
                                                                          // height: 0.22.sh,
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              SafeArea(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Text(
                                                                                    getTranslatedStrings(context).pickImagesVideos,
                                                                                    style: mainStyle(context, 14, color: newDarkGreyColor, isBold: true),
                                                                                  ),
                                                                                  heightBox(15.h),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: DefaultButton(
                                                                                          // color: Colors.white,
                                                                                          backColor: newLightGreyColor,

                                                                                          borderColor: Colors.transparent,
                                                                                          height: 0.07.sh,
                                                                                          // width: 33.w,
                                                                                          text: getTranslatedStrings(context).image,
                                                                                          customChild: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                getTranslatedStrings(context).images,
                                                                                                style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                                                                                              ),
                                                                                              widthBox(7.w),
                                                                                              SvgPicture.asset('assets/svg/icons/camera.svg')
                                                                                            ],
                                                                                          ),
                                                                                          onClick: () async {
                                                                                            {
                                                                                              final ImagePicker _picker = ImagePicker();
                                                                                              final List<XFile>? photos = await _picker.pickMultiImage().then((value) {
                                                                                                if (value != null) {
                                                                                                  // feedsCubit.updateAttachedFile(null,
                                                                                                  //     xFiles: photos);
                                                                                                  logg('photos != null ====');

                                                                                                  value.forEach((e) {
                                                                                                    XFile xFile = new XFile(e.path);
                                                                                                    messengerCubit.updateAttachedFile(xFile);
                                                                                                  });
                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              });

                                                                                              ///
                                                                                              // Either the permission was already granted before or the user just granted it.
                                                                                              // final ImagePicker _picker = ImagePicker();
                                                                                              // final XFile? photo = await _picker
                                                                                              //     .pickImage(
                                                                                              //   source: ImageSource.camera,
                                                                                              // )
                                                                                              //     .then((value) async {
                                                                                              //   logg('photo picked');
                                                                                              //   messengerCubit.updateAttachedFile(value);
                                                                                              //   await Future.delayed(Duration(milliseconds: 100));
                                                                                              //   Navigator.pop(context);
                                                                                              // });
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      widthBox(10.w),
                                                                                      Expanded(
                                                                                        child: DefaultButton(
                                                                                          height: 0.07.sh,
                                                                                          backColor: newLightGreyColor,
                                                                                          borderColor: Colors.transparent,
                                                                                          text: getTranslatedStrings(context).video,
                                                                                          customChild: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                getTranslatedStrings(context).videos,
                                                                                                style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                                                                                              ),
                                                                                              widthBox(7.w),
                                                                                              SvgPicture.asset('assets/svg/icons/video camera.svg')
                                                                                            ],
                                                                                          ),
                                                                                          onClick: () async {
                                                                                            {
                                                                                              // Either the permission was already granted before or the user just granted it.
                                                                                              final ImagePicker _picker = ImagePicker();
                                                                                              final List<XFile>? photos = await _picker.pickVideo(source: ImageSource.gallery).then((value) {
                                                                                                if (value != null) {
                                                                                                  // feedsCubit.updateAttachedFile(null,
                                                                                                  //     xFiles: photos);
                                                                                                  logg('photos != null');
                                                                                                  // value.forEach((e) {
                                                                                                  XFile xFile = new XFile(value.path);
                                                                                                  messengerCubit.updateAttachedFile(xFile);
                                                                                                  // });
                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              });
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });

                                                                  ///
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            12.0,
                                                                        horizontal:
                                                                            6),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/svg/icons/picture_plus_outline_28.svg'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  logg(
                                                                      'picking file');
                                                                  FilePickerResult?
                                                                      result =
                                                                      await FilePicker
                                                                          .platform
                                                                          .pickFiles(
                                                                    type: FileType
                                                                        .custom,
                                                                    allowMultiple:
                                                                        false,
                                                                    allowedExtensions: [
                                                                      'doc',
                                                                      'pdf',
                                                                    ],
                                                                  );
                                                                  if (result !=
                                                                      null) {
                                                                    File file = File(result
                                                                        .files
                                                                        .single
                                                                        .path!);
                                                                    XFile
                                                                        xFile =
                                                                        new XFile(
                                                                            file.path);
                                                                    messengerCubit
                                                                        .updateAttachedFile(
                                                                            xFile);
                                                                    // Navigator.pop(context);
                                                                  } else {
                                                                    // User canceled the picker
                                                                    logg(
                                                                        'user canceled the pick');
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              12.0,
                                                                          horizontal:
                                                                              6),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              'assets/svg/icons/document_plus_outline_24.svg')),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        /// record voice
                                                        // if (!isTyping)
                                                        //   GestureDetector(
                                                        //     onTapDown: (_) {
                                                        //       record().then((value) {
                                                        //         // setState(() {
                                                        //         //   isRecording=true;
                                                        //         // });
                                                        //       });
                                                        //     },
                                                        //     // start recording when long pressed
                                                        //     onTapUp: (_) => stopRecorder()
                                                        //         .then((value) {
                                                        //       XFile xFile =
                                                        //           new XFile(value.path);
                                                        //       messengerCubit
                                                        //           .updateAttachedFile(
                                                        //               xFile);
                                                        //       // return null;
                                                        //     }),
                                                        //     // stop recording when released
                                                        //     // onHorizontalDragUpdate: _onHorDrag,
                                                        //     // onVerticalDragUpdate: _onVerDrag,
                                                        //     child: Container(
                                                        //       padding: const EdgeInsets.all(
                                                        //           15.0),
                                                        //       decoration: BoxDecoration(
                                                        //           color: isRecording
                                                        //               ? Colors.blueAccent
                                                        //               : Colors.transparent,
                                                        //           shape: BoxShape.circle),
                                                        //       child: SvgPicture.asset(
                                                        //         'assets/svg/mic.svg',
                                                        //         color: isRecording
                                                        //             ? Colors.white
                                                        //             : Colors.black,
                                                        //       ),
                                                        //     ),
                                                        //   ),

                                                        /// send msh
                                                      ],
                                                    ),

                                                    ///
                                                    // IconButton(
                                                    //   icon: Icon(Icons.photo_camera,
                                                    //       color: Colors.blueAccent),
                                                    //   onPressed: () {},
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                (isTyping ||
                                        voiceDurationPositive ||
                                        messengerCubit
                                            .attachedFiles.isNotEmpty ||
                                        messengerCubit.recorderVoice != null

                                    // check if there is avoice
                                    )
                                    ? Row(
                                        children: [
                                          SizedBox(width: 7.w),
                                          InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.send_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              messengerCubit
                                                  .sendMessage(
                                                    toId: widget.toId,
                                                    toType: widget.toType,
                                                    msg:
                                                        _chatInputTextController
                                                            .text,
                                                  )
                                                  .then((value) =>
                                                      messengerCubit
                                                          .fetchChatMessagesByIdType(
                                                        toIdProviderId:
                                                            widget.toId,
                                                        toTypeRoleName:
                                                            widget.toType,
                                                      ));
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(width: 7.w),
                                          GestureDetector(
                                            onTapDown: (_) {
                                              record().then((value) {
                                                // setState(() {
                                                //   isRecording=true;
                                                // });
                                              });
                                            },
                                            // start recording when long pressed
                                            onTapUp: (_) =>
                                                stopRecorder().then((value) {
                                              XFile xFile =
                                                  new XFile(value.path);
                                              messengerCubit
                                                  .updateVoiceFile(xFile);
                                              // return null;
                                            }),
                                            // stop recording when released
                                            // onHorizontalDragUpdate: _onHorDrag,
                                            // onVerticalDragUpdate: _onVerDrag,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  shape: BoxShape.circle),
                                              child: SvgPicture.asset(
                                                  'assets/svg/mic.svg',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            heightBox(8.h)
                          ],
                        ),
                      ),
                    ),
                    //   SizedBox(width: 7.w),
                  ],
                ),
              )),
        ));
      },
    );
  }

  void _onHorDrag(details) {
    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
    int sensitivity = 18;
    if (details.delta.dx > sensitivity) {
      // Right Swipe
      logg('Right Swipe');
    } else if (details.delta.dx < -sensitivity) {
      //Left Swipe
      logg('Left Swipe');
    }
  }

  void _onVerDrag(details) {
    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
    int sensitivity = 12;
    if (details.delta.dy > sensitivity) {
      // Right Swipe
      logg('Down Swipe');
    } else if (details.delta.dy < -sensitivity) {
      //Left Swipe
      logg('Up Swipe');
    }
  }

// void _startRec(TapDownDetails details) {
//   setState(() {
//     isRecording = true;
//   });
//   logg('recording started');
//
//   // HapticFeedback.vibrate();
// }
//
// void _stopRec(TapUpDetails details) {
//   logg('recording stopped');
//   setState(() {
//     isRecording = false;
//   });
// }
}

class AttachedFileHandle extends StatelessWidget {
  const AttachedFileHandle({
    Key? key,
    required this.xfile,
    this.fn,
    this.customWidthForHorizontalView,
    this.customHeight,
  }) : super(key: key);
  final double? customHeight;
  final double? customWidthForHorizontalView;
  final XFile xfile;
  final Function()? fn;

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
      child: Container(
        width: customWidthForHorizontalView,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: (xfile.name.split('.').last.toLowerCase() == 'jpg' ||
                      xfile.name.split('.').last.toLowerCase() == 'png')
                  ? Container(
                      child: Image.file(
                        File(xfile.path),
                        height: customHeight,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (xfile.name.split('.').last.toLowerCase() == 'mp4' ||
                          xfile.name.split('.').last.toLowerCase() == 'mov')
                      ? Container(
                          constraints: BoxConstraints(maxHeight: 0.3.sh),
                          color: Colors.grey,
                          child: DefaultVideoPlayer(
                            videoFile: xfile,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (xfile.name.endsWith('.pdf')) {
                              navigateToWithoutNavBar(context,
                                  PdfViewerLayout(pdfFile: xfile.path), '');
                            }
                          },
                          child: DefaultShadowedContainer(
                              childWidget: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customWidthForHorizontalView == null
                                ? Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/icons/attachedfile.svg',
                                        width: 44.w,
                                        // color: Colors.grey,
                                      ),
                                      widthBox(5.w),
                                      Expanded(
                                          child: Text(
                                        xfile.name,
                                        style: mainStyle(context, 14),
                                      )),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/icons/attachedfile.svg',
                                        width: 44.w,
                                        // color: Colors.grey,
                                      ),
                                      widthBox(5.w),
                                      Expanded(
                                          child: Text(
                                        xfile.name,
                                        textAlign: TextAlign.center,
                                        style: mainStyle(context, 14),
                                      )),
                                    ],
                                  ),
                          )),
                        ),
            ),
            if (fn != null) widthBox(2.w),
            if (fn != null)
              GestureDetector(
                  onTap: fn,
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/svg/icons/x delete.svg',
                        width: 10.w,
                        color: Colors.grey,
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}

/// old chat tail Hachem figma
// class ChatTail extends StatefulWidget {
//   const ChatTail({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ChatTail> createState() => _ChatTailState();
// }
//
// class _ChatTailState extends State<ChatTail> with TickerProviderStateMixin {
//   late AnimationController _recordingAnimController;
//   late Animation<double> _recordingAnimation;
//
//   @override
//   initState() {
//     super.initState();
//
//     _recordingAnimController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat(reverse: true);
//     _recordingAnimation =
//         CurvedAnimation(parent: _recordingAnimController, curve: Curves.easeIn);
//   }
//
//   @override
//   void dispose() {
//     _recordingAnimController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var messengerCubit = MessengerCubit.get(context);
//     // bool test=false;
//     return SizedBox(
//       height: 50.h,
//       // color: Colors.red,
//       child: BlocConsumer<MessengerCubit, MessengerState>(
//         listener: (context, state) {
//           // TODO: implement listener
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: defaultHorizontalPadding, vertical: 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: DefaultContainer(
//                     radius: 35.sp,
//                     height: double.maxFinite,
//                     childWidget: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: defaultHorizontalPadding * 2),
//                       child: messengerCubit.expandChatTools
//                           ? const SizedBox()
//                           : SizedBox(
//                         height: double.maxFinite,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Message ...',
//                             textAlign: TextAlign.start,
//                             style: mainStyle(context,
//                               13,
//                               color: softGreyColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   width: (messengerCubit.expandChatTools == true ||
//                       messengerCubit.recording)
//                       ? 0.93.sw
//                       : 0.18.sw,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   logg('toggle recording');
//
//                                   if (messengerCubit.recording) {
//                                     _recordingAnimController.stop();
//                                     logg('stop animation');
//                                   } else {
//                                     // _controller.animateBack(target)
//                                     logg('! messengerCubit.recording');
//                                     if (!_recordingAnimController.isAnimating) {
//                                       logg('! _controller.isAnimating');
//                                       _recordingAnimController
//                                         ..forward(from: 0.0)
//                                         ..repeat(reverse: true);
//                                     }
//                                   }
//                                   messengerCubit.toggleRecording(null);
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     // if( _recordingAnimController.isCompleted)
//                                     messengerCubit.recording
//                                         ? FadeTransition(
//                                       opacity: _recordingAnimation,
//                                       child: Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 8.0),
//                                         child: Transform(
//                                           alignment:
//                                           Alignment.bottomCenter,
//                                           transform:
//                                           Matrix4.rotationY(pi),
//                                           child: SvgPicture.asset(
//                                             'assets/svg/icons/recording.svg',
//                                             height: 25.h,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                         : const SizedBox(),
//                                     SvgPicture.asset(
//                                       'assets/svg/mic.svg',
//                                       height: 25.h,
//                                     ),
//                                     messengerCubit.recording
//                                         ? FadeTransition(
//                                       opacity: _recordingAnimation,
//                                       child: Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 8.0),
//                                         child: SvgPicture.asset(
//                                           'assets/svg/icons/recording.svg',
//                                           height: 25.h,
//                                         ),
//                                       ),
//                                     )
//                                         : const SizedBox()
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             messengerCubit.expandChatTools == true
//                                 ? Expanded(
//                               flex: 4,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SvgPicture.asset(
//                                     'assets/svg/icons/shareLocation.svg',
//                                     height: 25.h,
//                                   ),
//                                   widthBox(10.w),
//                                   SvgPicture.asset(
//                                     'assets/svg/icons/camera.svg',
//                                     height: 25.h,
//                                   ),
//                                   widthBox(10.w),
//                                   SvgPicture.asset(
//                                     'assets/svg/icons/doc.svg',
//                                     height: 25.h,
//                                   ),
//                                   widthBox(10.w),
//                                   SvgPicture.asset(
//                                     'assets/svg/icons/gallery.svg',
//                                     height: 25.h,
//                                   ),
//                                 ],
//                               ),
//                             )
//                                 : const SizedBox()
//                           ],
//                         ),
//                       ),
//                       widthBox(10.w),
//                       messengerCubit.recording
//                           ? const SizedBox()
//                           : GestureDetector(
//                         onTap: () {
//                           logg('expand tools');
//                           messengerCubit.toggleExpandChatTools(null);
//                           //cubit.viewChatTools
//                         },
//                         child: AnimatedRotation(
//                           duration: const Duration(milliseconds: 300),
//                           turns:
//                           messengerCubit.expandChatTools ? 1 / 8 : 0,
//                           child: Row(
//                             children: [
//                               SvgPicture.asset(
//                                 'assets/svg/icons/addIcon.svg',
//                                 height: 25.h,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//           );
//         },
//       ),
//     );
//   }
// }
/// chat tail
