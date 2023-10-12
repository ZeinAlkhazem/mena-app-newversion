import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:screen_recorder/screen_recorder.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../chat/chat_page.dart';
import '../more/more_dialog.dart';
import '../security/security_dialog.dart';
import '../shear_screen/shear_screen_dialog.dart';
import '../whiteboard/whiteboard_page.dart';
import '../widget/left_meeting.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());

  static MeetingCubit get(context) => BlocProvider.of(context);

  int viewersCount = 200;

  HashSet selectItems = HashSet();

  late List listSelectItems;

  void emitInitial() {
    emit(InitialState());
  }

  void doMultiSelection(int path) {
    if (selectItems.contains(path)) {
      selectItems.remove(path);
    } else {
      selectItems.add(path);
    }
  }

  void onPressLeave(BuildContext context) {
    showMyAlertDialog(context, "", alertDialogContent: const LeftMeeting());
  }

  void onPressAudio(BuildContext context, int index) {
    doMultiSelection(index);

    emit(OnPressAudioMeetingState());
  }

  void onPressCamera(BuildContext context, int index) {
    doMultiSelection(index);

    emit(OnPressCameraMeetingState());
  }

// todo //////////////////   For Share //////////////////////////////////

  bool hostOnly = true;

  void onPressShareWhoCanShare(bool v) {
    hostOnly = v;

    emit(OnPressShareMeetingState());
  }

  void onPressShare(BuildContext context, int index) {
    doMultiSelection(index);

    showMyAlertDialog(
      context,'',
      alertDialogContent: ShearScreenDialog(),
    );

    emit(OnPressShareMeetingState());
  }

// todo ////////////////////////////////////////////////////////////////

  final bool recording = false;

  final bool exporting = false;

  ScreenRecorderController controller = ScreenRecorderController();

  bool get canExport => controller.exporter.hasFrames;

  void onPressRecord(BuildContext context, int index) {
    doMultiSelection(index);

    emit(OnPressRecordMeetingState());
  }

  void onPressReactions(BuildContext context, int index) {
    doMultiSelection(index);

    emit(OnPressReactionsMeetingState());
  }

  late WebViewController webViewController;

  void onPressWhiteboards(BuildContext context, int index) {
    emit(OnloadingState());

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(255, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            emit(OnPressWhiteboardsMeetingState());

            navigateTo(context, const WhiteboardPage());
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://wbo.ophir.dev/boards/${getRandomString()}'));
  }

  void onPressSecurity(BuildContext context, int index) {
    showMyAlertDialog(
      context,
      '',
      dismissible: false,
      alertDialogContent: SecurityDialog(),
    );

    emit(OnPressSecurityMeetingState());
  }

  void onPressMore(BuildContext context, int index) {
    doMultiSelection(index);

    showMyAlertDialog(
      context,
      '',
      alertDialogContent: MoreDialog(),
    );

    emit(OnPressMoreMeetingState());
  }

// todo //////////////////   For Chat //////////////////////////////////

  TextEditingController chatMessageText = TextEditingController();

  void onPressChat(context) {
    buildShowModalBottomSheet(context,
        body: const ChatPage(), backColor: Colors.transparent);

    emit(OnPressChatMeetingState());
  }

  emojiPicker(context) async {
    final hasEmojiKeyboard =
        await KeyboardEmojiPicker().checkHasEmojiKeyboard();

    if (hasEmojiKeyboard) {
      KeyboardEmojiPicker().pickEmoji();
    } else {
      showMyAlertDialog(context, "",
          alertDialogContent:
              const Text("your device keyboard doesn't have emoji."),
          actions: [
            DefaultButton(
              width: 100.w,
              text: "Ok",
              onClick: () => Navigator.pop(context),
            ),
          ]);
    }
  }

  sendMessage() {}

// todo ////////////////////////////////////////////////////////////////

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString() => String.fromCharCodes(Iterable.generate(
      15, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
