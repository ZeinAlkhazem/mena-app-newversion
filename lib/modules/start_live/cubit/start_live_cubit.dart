// ignore_for_file: avoid_print

// Dart imports:
import 'dart:developer';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:logger/logger.dart';
import 'package:m_toast/m_toast.dart';
import 'package:share_plus/share_plus.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Project imports:
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/network/dio_helper.dart';
import 'package:mena/core/network/network_constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/provider_model.dart';
import 'package:mena/modules/start_live/ser_sok.dart';
import '../../live_ended/live_ended_page.dart';
import '../widget/bottomsheet_report.dart';
import '../widget/live_description.dart';
import '../widget/view_description.dart';

// ignore: library_prefixes

part 'start_live_state.dart';

class StartLiveCubit extends Cubit<StartLiveState> {
  StartLiveCubit() : super(StartLiveInitial());

  static StartLiveCubit get(context) => BlocProvider.of(context);

  TextEditingController liveMessageText = TextEditingController();
  List<ProviderData>? providers;

  IO.Socket? socket;
  var logger = Logger();

  Future<void> socketInitial(context) async {
    var mainCubit = MainCubit.get(context);

    SignallingService.instance.init(
      websocketUrl: 'https://live.menaaii.com:3000',
      transports: ['websocket'],
      extraHeaders: {'foo': 'bar'},
    );

    socket = SignallingService.instance.socket;

    socket!.onConnect((_) {
      logger.wtf('Socket connection established');

      if (mainCubit.userInfoModel != null) {
        socket?.emit('join', [
          {
            'user_id': '${mainCubit.userInfoModel!.data.user.id}',
            'type': mainCubit.isUserProvider() ? 'provider' : 'client',
          },
        ]);
      }
    });
  }

  onPressStopLive(context) {
    showMyBottomSheet(
        context: context,
        title: "Leaving this screen will end the livestream",
        body: BottomSheetSimple(
          txetConfirm: "Finish",
          onClickCancel: () => Navigator.pop(context),
          onClickConfirm: () {
            SignallingService.instance.socket.disconnected;

            Navigator.pop(context);

            navigateToAndFinish(context, const LiveEndedPage());

            viewMySnackBar(context, "Done", "", () => null,
                customColor: Colors.green);
          },
        ));

    emit(OnPressStopLiveState());
  }

  onPressDoneLive(context) {
    navigateBackToHome(context);
  }

  bool isLivePaused = false;

  onPressPauseLive() {
    isLivePaused = isLivePaused == true ? false : true;

    emit(OnPressPauseLiveState());
  }

  onPressCreatePoll() {
    emit(OnPressCreatePollState());
  }

  onPressShareLive(context, String? text, String? subject) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      text ?? "",
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    emit(OnPressShareLiveState());
  }

  onPressCopyLink(BuildContext context, String text) {
    ShowMToast toast = ShowMToast();

    Clipboard.setData(ClipboardData(text: text)).then((value) =>
        toast.successToast(context,
            message: "Link Copied ,copied to clipboard",
            alignment: Alignment.bottomCenter));

    emit(OnPressCopyLinkState());
  }

  TextEditingController liveReportText = TextEditingController();

  onPressReport(context) {
    showMyBottomSheet(
        context: context,
        title: "Report Description:",
        body: BottomsheetReport(
          onClickCancel: () {
            Navigator.pop(context);
            paths = null;

            is4photo = null;

            filesMultie = [];

            fileNamemultt = "0";
          },
          onClickConfirm: () => onSendReport(),
        ));

    emit(OnPressReportState());
  }

  List<PlatformFile>? paths;
  List<File> filesMultie = [];
  String fileNamemultt = "0";
  String? is4photo;

  void pickReportFiles() async {
    paths = null;

    is4photo = null;

    paths = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      onFileLoading: (FilePickerStatus status) => log(status.name),
      allowedExtensions: [
        'jpg',
        'png',
        'jpeg',
      ],
    ))
        ?.files;
    filesMultie = paths!.map((path) => File(path.path!)).toList();

    fileNamemultt = "${paths?.length}";

    paths!.length <= 4 ? is4photo = null : is4photo = "";

    emit(OnPick4PhotoState());
  }

  onSendReport() {}

  onPressFollow() {
    emit(OnPressFollowState());
  }

  double heightComments = 0.35.sh;

  onHideComments() {
    heightComments == 0 ? heightComments = 0.35.sh : heightComments = 0;

    emit(OnHideCommentsState());
  }

  bool isLiked = false;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    this.isLiked = isLiked;

    emit(OnHideCommentsState());

    return !isLiked;
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

  sendComment() {}
  Future<void> getProviders() async {
    try {
      await MainDioHelper.getData(url: getProviderList, query: {})
          .then((value) {
        providers = ProviderModel.fromJson(value.data).data.data;
        // goLiveModel = GoLiveModel.fromJson(value.data);
        emit(OnloadGetProviders());
      });
    } on DioException catch (e) {
      print("gggggggggggggg ${e.response?.data}");
      print(e.response?.statusCode);
      print(e.response?.data);
    }
  }

  onShowDescription(context) {
    showMyBottomSheet(
      context: context,
      title: "Live Description:",
      body: const LiveDescription(
        goalDescription: "",
        liveTitle: "",
        targetDescription: "",
      ),
    );
  }

  onShowViewer(context) {
    showMyBottomSheet(
        context: context, title: "Live Viewers", body: const ViewDescription());
  }
}
