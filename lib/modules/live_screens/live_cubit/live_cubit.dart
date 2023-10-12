import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/modules/live_screens/meetings/start_meeting_layout.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/go_live_model.dart';
import '../../../models/api_model/live_categories.dart';
import '../../../models/api_model/lives_model.dart';
import '../../../models/api_model/meetings_config.dart';
import '../../../models/api_model/my_meetings.dart';
import '../../../models/local_models.dart';
import '../meetings/create_upcoming_meeting.dart';
import '../meetings/join_meeting_layout.dart';

part 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  LiveCubit() : super(LiveInitial());
  GoLiveModel? goLiveModel;

  ///
  ///
  DateTime? pickedMeetingDate;
  DateTime? pickedMeetingFromTime;
  DateTime? pickedMeetingToTime;
  String? pickedMeetingTimezone;
  Repeat? pickedMeetingRepeat;
  String passCode = '0';
  Repeat? emptyTimeZoneForViewOnLeft;

  //
  bool allowParticipantToJoin = false;
  bool enableAutoMeetingREcord = false;
  bool requireMeetingPassCode = false;
  bool turnOffMyVideo = false;
  bool notConnectToAudio = false;
  bool usePersonalMeetingId = false;
  bool startMeetingVideoOn = false;
  bool enableWaitingRoom = false;
  bool addToCalendar = false;
  bool publishToFeed = false;
  bool publishTheLiveToMenaLivePage = false;

  bool isMyMeeting = true;

  ///

  String selectedMeetingTypeId = '-1';

  String selectedParticipantTypeId = '-1';

  static LiveCubit get(context) => BlocProvider.of(context);
  bool liveNowLayout = true;
  LiveCategories? nowLiveCategoriesModel;

  LiveCategories? upcomingLiveCategoriesModel;

  LivesModel? nowLivesModel;

  LivesModel? upcomingLivesModel;

  List<LiveCategory>? liveNowList;

  List<LiveCategory>? upcomingList;

  String? selectedNowLiveCat = '-1';

  String? selectedUpcomingLiveCat = '-1';

  String? selectedStartLiveCat;

  DateTime? pickedLiveTime;

  MeetingsConfigModel? meetingsConfigModel;

  ItemWithTitleAndCallback? selectedJoiningMethod;

  MyMeetingsModel? myMeetingsModel;

  int activeSliderItemIndex = 0;

  List<ItemWithTitleAndImage> meetingsSliderItems = [
    ItemWithTitleAndImage(
        title:
            'Unite, cooperate, and achieve greater productivity collectively using Mena\'s dependable video conferencing solution.',
        thumbnailLink: 'assets/svg/meetings/meeting.svg'),
    ItemWithTitleAndImage(
        title:
            'Host meetings up to 500 attendees Unlimited meetings for up to 30 hours per meeting Unlimited cloud recording storage Automated and Translated Captions',
        thumbnailLink: 'assets/svg/meetings/meeting mena.svg'),
    ItemWithTitleAndImage(
        title:
            'Host meetings up to 500 attendees Unlimited meetings for up to 30 hours per meeting Unlimited cloud recording storage Automated and Translated Captions',
        thumbnailLink: 'assets/svg/meetings/meta.svg'),
    ItemWithTitleAndImage(
        title:
            'Host meetings up to 500 attendees Unlimited meetings for up to 30 hours per meeting Unlimited cloud recording storage Automated and Translated Captions',
        thumbnailLink: 'assets/svg/meetings/team chat.svg'),
    ItemWithTitleAndImage(
        title:
            'Host meetings up to 500 attendees Unlimited meetings for up to 30 hours per meeting Unlimited cloud recording storage Automated and Translated Captions',
        thumbnailLink: 'assets/svg/meetings/Webinar.svg'),
    ItemWithTitleAndImage(
        title:
            'Host meetings up to 500 attendees Unlimited meetings for up to 30 hours per meeting Unlimited cloud recording storage Automated and Translated Captions',
        thumbnailLink: 'assets/svg/meetings/whiteboard.svg'),
  ];

  List<ItemWithTitleAndImage> meetingsDashboardItems(BuildContext context) => [
        ItemWithTitleAndImage(
            title: 'Start Meeting',
            thumbnailLink: 'assets/svg/meetings/start.svg',
            onClickCallback: () {
              navigateTo(context, StartMeetingLayout());
            }),
        ItemWithTitleAndImage(
            title: 'Create upcoming',
            thumbnailLink: 'assets/svg/meetings/upcoming.svg',
            onClickCallback: () {
              navigateToWithoutNavBar(context, CreateUpcomingMeeting(), 'routeName');
            }),
        ItemWithTitleAndImage(
            title: 'Join meeting',
            thumbnailLink: 'assets/svg/meetings/join.svg',
            onClickCallback: () {
              navigateToWithNavBar(context, JoinMeetingLayout(), '');
            }),
        ItemWithTitleAndImage(
            title: 'Metaverse Meeting',
            thumbnailLink: 'assets/svg/meetings/metaverse.svg',
            onClickCallback: () {
              viewComingSoonAlertDialog(context);
            }),
      ];

  List<ItemWithTitleAndCallback> joiningMethods = [
    ItemWithTitleAndCallback(
      id: '0',
      title: 'Meeting id',
      onClickCallback: () {},
      thumbnailLink: '',
    ),
    ItemWithTitleAndCallback(
      id: '0',
      title: 'Meeting link',
      onClickCallback: () {},
      thumbnailLink: '',
    ),
  ];

  void updateSelectedItemWithTitleAndCallback(ItemWithTitleAndCallback val) {
    selectedJoiningMethod = val;
    emit(CurrentViewChanged());
  }

  void changeSelectedNowLiveCat(String? val) {
    nowLivesModel!.data.livesByCategory.livesByCategoryItem = [];
    emit(CurrentViewChanged());
    if (selectedNowLiveCat == val) {
      selectedNowLiveCat = null;
      getLivesNowAndUpcoming(filter: 'live', categoryId: '');
    } else {
      selectedNowLiveCat = val;
      getLivesNowAndUpcoming(filter: 'live', categoryId: val!);
    }
    emit(CurrentViewChanged());
  }

  void updateActiveSliderItem(int index) {
    activeSliderItemIndex = index;
    emit(CurrentViewChanged());
  }

  /// meeting
  void updateMeetingPickerDate(DateTime? val) {
    pickedMeetingDate = val;
    emit(CurrentViewChanged());
  }

  void updateMeetingFromTime(DateTime? val) {
    pickedMeetingFromTime = val;
    emit(CurrentViewChanged());
  }

  void updateMeetingToTime(DateTime? val) {
    pickedMeetingToTime = val;
    emit(CurrentViewChanged());
  }

  void updateMeetingTimeZone(String? val) {
    pickedMeetingTimezone = val;
    emit(CurrentViewChanged());
  }

  void updateMeetingRepeat(Repeat? val) {
    pickedMeetingRepeat = val;
    emit(CurrentViewChanged());
  }

  ///
  void updateSelectedMeetingTypeId(String val) {
    selectedMeetingTypeId = val;
    emit(CurrentViewChanged());
  }

  void updateSelectedParicipantTypeId(String val) {
    selectedParticipantTypeId = val;
    emit(CurrentViewChanged());
  }

  void updateUsePersonalMeetingId(bool val) {
    usePersonalMeetingId = val;
    emit(CurrentViewChanged());
  }

  void updateNotConnectToAudio(bool val) {
    notConnectToAudio = val;
    emit(CurrentViewChanged());
  }

  void updateTurnOffMyVideo(bool val) {
    turnOffMyVideo = val;
    emit(CurrentViewChanged());
  }

  void updateRequireMeetingPassCode(bool val) {
    requireMeetingPassCode = val;

    if (val == true) {
      passCode = getRandomString(6);
    }
    emit(CurrentViewChanged());
  }

  void updateEnableWaitingRoom(bool val) {
    enableWaitingRoom = val;
    emit(CurrentViewChanged());
  }

  void updateAllowParticipantToJoin(bool val) {
    allowParticipantToJoin = val;
    emit(CurrentViewChanged());
  }

  void updateAutoREcordMeeting(bool val) {
    enableAutoMeetingREcord = val;
    emit(CurrentViewChanged());
  }

  void updateStartMeetingVideoOn(bool val) {
    startMeetingVideoOn = val;
    emit(CurrentViewChanged());
  }

  void updateAddToCalendar(bool val) {
    addToCalendar = val;
    emit(CurrentViewChanged());
  }

  void updateSharePermission(bool val) {
    publishToFeed = val;
    emit(CurrentViewChanged());
  }

  void updatePublishTheLiveToMenaLivePage(bool val) {
    publishTheLiveToMenaLivePage = val;
    emit(CurrentViewChanged());
  }

  void updatePassCode(String val) {
    passCode = val;
    emit(CurrentViewChanged());
  }

  void changeSelectedUpcomingLiveCat(String? val) {
    upcomingLivesModel!.data.livesByCategory.livesByCategoryItem = [];
    emit(CurrentViewChanged());
    if (selectedUpcomingLiveCat == val) {
      selectedUpcomingLiveCat = null;
      getLivesNowAndUpcoming(filter: 'upcoming', categoryId: '');
    } else {
      selectedUpcomingLiveCat = val;
      getLivesNowAndUpcoming(filter: 'upcoming', categoryId: val!);
    }

    emit(CurrentViewChanged());
  }

  void changeSelectedStartLiveCat(String? val) {
    selectedStartLiveCat = val;
    emit(CurrentViewChanged());
  }

  XFile? thumbnailFile;

  void updateThumbnailFile(XFile? file) {
    thumbnailFile = file;
    emit(ThumbnailFileUpdated());
  }

  Future<void> changeCurrentView(bool val) async {
    liveNowLayout = val;
    emit(CurrentViewChanged());
  }

  void updateTempFromTime(DateTime val) {
    pickedLiveTime = val;
    emit(UpdatePickedLiveTime());
  }

  Future<LiveCategory?> goLiveAndGetLiveFromServer({
    required String title,
    required String goal,
    required String topic,
    required String liveNowCategoryId,
  }) async {
    goLiveModel = null;
    emit(GettingGoLiveAndGetLiveFromServer());

    FormData formData;
    Map<String, dynamic> toSendData = {
      'title': title,
      'goal': goal,
      'topic': topic,
      'live_now_category_id': liveNowCategoryId,
    };
    if (thumbnailFile != null) {
      File temp = File(thumbnailFile!.path);
      toSendData['image'] = await MultipartFile.fromFile(
        temp.path,
        filename: temp.path.split('/').last,
      );
    }

    formData = FormData.fromMap(toSendData);
    await MainDioHelper.postDataWithFormData(url: goLiveEnd, data: formData).then((value) {
      logg('goLiveAndGetLiveFromServer');
      logg(value.toString());
      goLiveModel = GoLiveModel.fromJson(value.data);
      emit(SuccessGoLiveAndGetLiveFromServer());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(stack.toString());

      emit(ErrorGoLiveAndGetLiveFromServer());
      return null;
    });
    return null;
  }

  Future<void> setLiveStatusToServer({required bool isStart}) async {
    emit(UpdatingLiveStatus());
    await MainDioHelper.postData(url: isStart ? setLiveStartEnd : setLiveEndedEnd, data: {}).then((value) {
      logg('UpdatedLiveStatus');

      emit(UpdatedLiveStatus());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());

      emit(ErrorUpdatedLiveStatus());
    });
  }

  Future<void> saveAndEditMeeting({required String title, required bool isEdit}) async {
    emit(UpdatingMeetingStatus());
    await MainDioHelper.postData(url: !isEdit ? saveMeetingEnd : editMeetingEnd, data: {
      'title': '$title',
      'date': '${pickedMeetingDate}',
      'from': '${pickedMeetingFromTime}',
      'to': '${pickedMeetingToTime}',
      'time_zone': '${pickedMeetingTimezone}',
      'repeat': '${pickedMeetingRepeat == null ? null : pickedMeetingRepeat!.id}',
      'require_passcode': '${requireMeetingPassCode ? 1 : 0}',
      'waiting_room': '${enableWaitingRoom ? 1 : 0}',
      'partipant_before_host': '${allowParticipantToJoin ? 1 : 0}',
      'auto_record': '${enableAutoMeetingREcord ? 1 : 0}',
      'to_calendar': '${addToCalendar ? 1 : 0}',
      'publish_to_feed': '${publishToFeed ? 1 : 0}',
      'publish_to_live': '${publishTheLiveToMenaLivePage ? 1 : 0}',
      'participants_type': '${selectedParticipantTypeId}',
      'meeting_type': '${selectedMeetingTypeId}',
      'passcode': '${passCode}',
      'share_permission': '1',
    }).then((value) {
      logg('Meeting saved/edited');
      emit(UpdatedLiveStatus());
    }).catchError((error) {
      logg('an error occurred');
      emit(ErrorUpdatedLiveStatus());
    });
  }

  Future<void> deleteMeeting({required int meetingId}) async {
    emit(UpdatingLiveStatus());
    await MainDioHelper.postData(
      url: deleteMeetingEnd,
      data: {},
      query: {
        'id': meetingId,
      },
    ).then((value) {
      logg('deleted');
      emit(UpdatedLiveStatus());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorUpdatedLiveStatus());
    });
  }

  Future<void> getLivesNowAndUpcomingCategories({required String filter}) async {
    emit(GettingLiveCategories());
    await MainDioHelper.getData(
        url: filter == 'live'
            ? getLivesNowEnd
            : filter == 'upcoming'
                ? getUpcomingLiveCategoriesEnd
                : getLivesNowEnd,
        query: {}).then((value) {
      logg('got getLivesNowAndUpcoming');
      logg(value.toString());
      if (filter == 'live') {
        nowLiveCategoriesModel = LiveCategories.fromJson(value.data);
      } else {
        upcomingLiveCategoriesModel = LiveCategories.fromJson(value.data);
      }
      // getSelectedVariationDetails(sku);
      emit(SuccessGetLivesNowAndUpcoming());
    }).catchError((error,stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorGetLivesNowAndUpcoming());
    });
  }

  Future<void> getLivesNowAndUpcoming({
    required String filter, // live or upcoming
    required String categoryId,
  }) async {
    logg('getting lives ');
    emit(GettingLivesState());
    await MainDioHelper.getData(
        url: '${getLivesEnd}?type=$filter${categoryId.isEmpty ? '' : '&category_id=$categoryId'}',
        query: {}).then((value) {
      logg('got getLivesNowAndUpcoming currently live');
      logg(value.toString());
      if (filter == 'live') {
        nowLivesModel = LivesModel.fromJson(value.data);
      } else {
        upcomingLivesModel = LivesModel.fromJson(value.data);
      }
      emit(SuccessGettingLivesState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(stack.toString());
      emit(ErrorGettingLivesState());
    });
  }

// Future<void> getCategories() async {
//   emit(GettingLiveCategories());
//   await MainDioHelper.getData(url: getCategoriesEnd, query: {})
//       .then((value) {
//     logg('got getCategories');
//     logg(value.toString());
//     liveCategoriesModel = LiveCategories.fromJson(value.data);
//     // getSelectedVariationDetails(sku);
//     emit(SuccessLoadingAdditionalRequiredData());
//   }).catchError((error) {
//     logg('an error occurred');
//     logg(error.toString());
//     emit(ErrorLoadingAdditionalRequiredData());
//   });
// }

  /// meetings
  Future<void> getMeetingsConfig() async {
    emit(GettingLiveCategories());
    await MainDioHelper.getData(url: getMeetingsConfigEnd, query: {}).then((value) {
      logg('got getLivesNowAndUpcoming');
      logg(value.toString());
      meetingsConfigModel = MeetingsConfigModel.fromJson(value.data);
      emit(SuccessGetLivesNowAndUpcoming());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(stack.toString());
      emit(ErrorGetLivesNowAndUpcoming());
    });
  }

  Future<void> getMyMeetings() async {
    emit(LoadingMeetingsState());
    await MainDioHelper.getData(url: getMyMeetingsEnd, query: {}).then((value) {
      logg('got getMyMeetingsEnd');
      logg(value.toString());
      myMeetingsModel = MyMeetingsModel.fromJson(value.data);
      emit(SuccessLoadingMeetingsState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(stack.toString());
      emit(ErrorGetLivesNowAndUpcoming());
    });
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) =>
    String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
