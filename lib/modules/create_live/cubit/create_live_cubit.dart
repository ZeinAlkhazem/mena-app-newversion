import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/config_model.dart';
import '../../start_live/start_live_page.dart';
import '../widget/bottomsheet_add_content_to_share.dart';
import '../widget/bottomsheet_click_link.dart';
import '../widget/bottomsheet_click_poll.dart';
import '../widget/bottomsheet_see_my_live.dart';

part 'create_live_state.dart';

class CreateLiveCubit extends Cubit<CreateLiveState> {
  CreateLiveCubit() : super(CreateLiveInitial());

  static CreateLiveCubit get(context) => BlocProvider.of(context);

  GlobalKey formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();

  TextEditingController target = TextEditingController();

  TextEditingController goal = TextEditingController();

  AutovalidateMode? autoValidateMode = AutovalidateMode.disabled;

  AutovalidateMode? resetPassAutoValidateMode = AutovalidateMode.disabled;

  Future<String?> fetchRoomID() async {
    final url = Uri.parse('https://menaaii.com/api/v1/live/get-lives');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final lives = jsonData['data']['lives'] as List<dynamic>;

        if (lives.isNotEmpty) {
          // Assuming you want to get the room ID from the first live data
          final roomID = lives[0]['room_id'];
          return roomID;
        }
      } else {
        // Handle the API request failure (non-200 status code)
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions that might occur during the API call
      print('Error fetching data: $error');
    }

    return null; // Return null if unable to fetch or extract room ID
  }


  onPressStarStreaming(context) async {
    String? roomID = await fetchRoomID();
    if (roomID != null) {
      navigateTo(context, StartLivePage(roomId: roomID));
    }
  }

  void toggleAutoValidate(bool val) {
    if (val == true) {
      autoValidateMode = AutovalidateMode.always;
    } else {
      autoValidateMode = AutovalidateMode.disabled;
    }
    emit(ChangeAutoValidateModeState());
  }

  bool valueSeeMyLiveAll = false;
  bool valueSeeMyLiveClient = false;
  bool valueSeeMyLiveProviders = false;

  void onPressSettingWhoCanSeeMyLive(BuildContext context) {
    showMyBottomSheet(
        context: context,
        title: "Who can see my live stream",
        body: BlocConsumer<CreateLiveCubit, CreateLiveState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BottomSheetSeeMyLiveAndComment(
                onClickAll: (value) {
                  valueSeeMyLiveAll = value!;

                  emit(WhoCanCommentAndShowState());
                },
                onClickClient: (value) {
                  valueSeeMyLiveClient = value!;

                  emit(WhoCanCommentAndShowState());
                },
                onClickProviders: (value) {
                  valueSeeMyLiveProviders = value!;

                  emit(WhoCanCommentAndShowState());
                },
                valueAll: valueSeeMyLiveAll,
                valueClient: valueSeeMyLiveClient,
                valueProviders: valueSeeMyLiveProviders,
                onClickCancel: () => Navigator.pop(context),
                onClickConfirm: () {},
              );
            }));
  }

  bool valueWhoCanCommentAll = false;
  bool valueWhoCanCommentClient = false;
  bool valueWhoCanCommentProviders = false;

  void onPressWhoCanComment(BuildContext context) {
    showMyBottomSheet(
        context: context,
        title: "Who can comment on my live stream",
        body: BlocConsumer<CreateLiveCubit, CreateLiveState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BottomSheetSeeMyLiveAndComment(
                onClickAll: (value) {
                  valueWhoCanCommentAll = value!;

                  emit(WhoCanCommentAndShowState());
                },
                onClickClient: (value) {
                  valueWhoCanCommentClient = value!;

                  emit(WhoCanCommentAndShowState());
                },
                onClickProviders: (value) {
                  valueWhoCanCommentProviders = value!;

                  emit(WhoCanCommentAndShowState());
                },
                valueAll: valueWhoCanCommentAll,
                valueClient: valueWhoCanCommentClient,
                valueProviders: valueWhoCanCommentProviders,
                onClickCancel: () => Navigator.pop(context),
                onClickConfirm: () {},
              );
            }));
  }

  void onPressClearMaskCache(BuildContext context) {
    showMyBottomSheet(
        context: context,
        title: "Clear mask cache",
        body: BottomSheetSimple(
          backColorConfirm: alertRedColor,
          onClickCancel: () => Navigator.pop(context),
          onClickConfirm: () {
            Navigator.pop(context);
            viewMySnackBar(context, "Done", "", () => null,
                customColor: Colors.green);
          },
        ));
  }

  bool valueRecordlive = false;

  onPressRecordlive(value) {
    valueRecordlive = value;

    emit(RecordliveState());
  }

  bool valueShareMyLive = false;

  onPressShareMyLive(BuildContext context, value) {
    if (valueShareMyLive == true) {
      valueShareMyLive = value;
      emit(RecordliveState());
    } else {
      showMyBottomSheet(
          context: context,
          title: "Share My live on my feed page",
          body: BottomSheetSimple(
            onClickCancel: () => Navigator.pop(context),
            onClickConfirm: () {
              valueShareMyLive = value;

              Navigator.pop(context);

              emit(RecordliveState());
            },
          ));
    }
  }

  onPressLinked(BuildContext context) {
    showMyBottomSheet(
        context: context,
        title: "Add Content to share with viewers during stream :",
        body: BottomSheetContentToShare(
          isClearCache: true,
          onClickLink: () => onClickLink(context),
          onClickPoll: () => onClickPoll(context),
          onClickProduct: () => onClickProduct(context),
          onClickConfirm: () {
            Navigator.pop(context);
            viewMySnackBar(context, "Done", "", () => null,
                customColor: Colors.green);
          },
        ));
  }

  TextEditingController linkUrl = TextEditingController();

  onClickLink(BuildContext context) {
    Navigator.pop(context);

    showMyBottomSheet(
        context: context,
        title: "Add Link:",
        body: BottomsheetClickLink(
          onClickCancel: () => Navigator.pop(context),
          onClickConfirm: () {
            Navigator.pop(context);
            viewMySnackBar(context, "Done", "", () => null,
                customColor: Colors.green);
          },
        ));
  }

  onClickProduct(BuildContext context) {
    Navigator.pop(context);
  }

  GlobalKey formKeyPoll = GlobalKey<FormState>();

  TextEditingController addQuestion = TextEditingController();
  TextEditingController addOption1 = TextEditingController();
  TextEditingController addOption2 = TextEditingController();

  MenaPlatform? selectedPlatform;

  void updateSelectedPlatform() {}

  onClickPoll(BuildContext context) {
    Navigator.pop(context);

    showMyBottomSheet(
        context: context,
        title: "Create a new poll:",
        body: BottomsheetClickPoll(
          onClickConfirm: () {
            Navigator.pop(context);
            viewMySnackBar(context, "Done", "", () => null,
                customColor: Colors.green);
          },
        ));
  }




  Future<void> createLive() async {
    emit(CreatingLiveState());

    Map<String, dynamic> toSendData = {
      'title': title.text,
      'goal': goal.text,
      'topic': target.text,
      'live_now_category_id': "1",
    };
  
    try {
      // await MainDioHelper.postData(url: goLiveEnd, data: toSendData)
      //     .then((value) {
      //   logg('createLive');
      //   logg(value.toString());

      //   // goLiveModel = GoLiveModel.fromJson(value.data);
      //   emit(SuccessCreateLive());
      // });
    } on DioError catch (e) {
      // print("gggggggggggggg ${e.response?.data}");
      // print(e.response?.statusCode);
      // print(e.response?.data);
    }
    // .catchError((error, stack) {
    // logg('an error occurred');
    // logg(stack.toString());
    //
    // emit(ErrorGoLiveAndGetLiveFromServer());
    // return null;
    // });
    return null;
  }
}
