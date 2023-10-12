import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/appointments_slots.dart';
import 'package:mena/models/api_model/insurance_providers_model.dart';
import 'package:mena/models/api_model/results_model.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/client_appointments_model.dart';
import '../../../models/api_model/config_model.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/api_model/prof_fac_model.dart';
import '../../../models/api_model/slots_model.dart';
import '../../../models/local_models.dart';
import '../appointments_layouts/calendar_utils.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsStateInitial());

  static AppointmentsCubit get(context) => BlocProvider.of(context);

  InsuranceProvidersModel? insuranceProvidersModel;

  User? selectedSlotFacilityProf;
  bool freeVal = true;
  String feesVal = '';
  AppointmentsModel? clientAppointmentsModel;
  AppointmentsModel? historyAppointmentsModel;
  MySlotsModel? mySlotsModel;
  int selectedAppointmentView = 0;

  bool viewCommentInput = false;

  DateTime? tempFromTime;
  DateTime? tempToTime;

  DateTime selectedMyAppointmentsDay = DateTime.now();

  List<AppointmentTypeLocalModel> localAppTypes = [
    AppointmentTypeLocalModel(
      id: '0',
      name: 'Online appointment',
      svgAssetLink: 'assets/svg/icons/online_apppointment_type.svg',
    ),
    AppointmentTypeLocalModel(
      id: '1',
      name: 'In person appointment',
      svgAssetLink: 'assets/svg/icons/in-person.svg',
    ),
  ];
  List<AppointmentTypeLocalModel> localAppStates = [
    AppointmentTypeLocalModel(
      id: '0',
      name: 'All',
      svgAssetLink: 'assets/svg/icons/online_apppointment_type.svg',
    ),
    AppointmentTypeLocalModel(
      id: '1',
      name: 'Confirmed',
      svgAssetLink: 'assets/svg/icons/online_apppointment_type.svg',
    ),
    AppointmentTypeLocalModel(
      id: '2',
      name: 'Rescheduled',
      svgAssetLink: 'assets/svg/icons/in-person.svg',
    ),
    AppointmentTypeLocalModel(
      id: '3',
      name: 'Canceled',
      svgAssetLink: 'assets/svg/icons/in-person.svg',
    ),
    AppointmentTypeLocalModel(
      id: '4',
      name: 'Deleted',
      svgAssetLink: 'assets/svg/icons/in-person.svg',
    ),
  ];

  AppointmentTypeLocalModel getLocalAppointmentParam(String typeId) {
    // logg('type id: $typeId');
    return localAppTypes.firstWhere((element) => element.id == typeId);
  }

  List<DateTime> selectedWeekDays = List.generate(7, (index) {
    return DateTime.now().add(Duration(days: index));
  });

  List<DateTime> slotPickDays = List.generate(7, (index) {
    return DateTime.now().add(Duration(days: index));
  });

  List<DateTime> selectedSlotPickDays = [];

  List<TimeRange> slotTimeRanges = [];

  List<AppointmentType> appointmentTypeItemsToView = []

      // [
      //   AppointmentTypes(
      //     id: '1',
      //     title: 'Online\nConsultation',
      //     svgPic: 'assets/svg/icons/online_apppointment_type.svg',
      //   ),
      //   AppointmentTypes(
      //     id: '2',
      //     title: 'In Person\nConsultation',
      //     svgPic: 'assets/svg/icons/in-person.svg',
      //   ),
      //   AppointmentTypes(
      //     id: '3',
      //     title: 'Online\nFollow Up',
      //     svgPic: 'assets/svg/icons/online_apppointment_type.svg',
      //   ),
      //   AppointmentTypes(
      //     id: '4',
      //     title: 'In Person\nFollow Up',
      //     svgPic: 'assets/svg/icons/in-person.svg',
      //   ),
      //   AppointmentTypes(
      //     id: '5',
      //     title: 'Online\nMeeting',
      //     sub: 'For Agents Providers',
      //     svgPic: 'assets/svg/icons/online_apppointment_type.svg',
      //   ),
      //   AppointmentTypes(
      //     id: '6',
      //     title: 'In Person\nMeeting',
      //     sub: 'For Agents Providers',
      //     svgPic: 'assets/svg/icons/in-person.svg',
      //   ),
      // ]
      ;

  void updateAppointmentTypesToView(List<AppointmentType> val) {
    appointmentTypeItemsToView = val;
  }

  void addSlotTimeRanges(TimeRange timeRange) {
    slotTimeRanges.add(timeRange);
    emit(UpdateTime());
  }

  void updateSelectedSlotFacilityProf(User val) {
    selectedSlotFacilityProf = val;
    emit(UpdateSelectedSlotFacilityProf());
  }

  void updateSelectedWeekDays(DateTime startDate) {
    selectedWeekDays = selectedWeekDays = List.generate(7, (index) {
      return startDate.add(Duration(days: index));
    });
    emit(SelectedWeekDaysUpdated());
  }

  void removeSlotTimeRanges(TimeRange timeRange) {
    slotTimeRanges.remove(timeRange);
    emit(UpdateTime());
  }

  void resetTempRange() {
    tempFromTime = null;
    tempToTime = null;
    emit(UpdateTime());
  }

  void updateTempFromTime(DateTime val) {
    tempFromTime = val;
    emit(UpdateTime());
  }

  void updateTempToTime(DateTime val) {
    tempToTime = val;
    emit(UpdateTime());
  }

  void changeFreeVal(bool val) {
    freeVal = val;
    emit(FreeValUpdated());
  }

  void updateFeesVal(String val) {
    feesVal = val;
    emit(FreeValUpdated());
  }

  void updateSelectedSlotTiming(DateTime date) {
    if (selectedSlotPickDays.contains(date)) {
      selectedSlotPickDays.remove(date);
    } else {
      selectedSlotPickDays.add(date);
    }
    // logg(selectedSlotPickDays.toString());

    //   selectedSlotPickDays
    //       .forEach((e) {
    //         logg ('${getFormattedDateOnlyDayName(e)}_${getWeekDayOrder(getFormattedDateOnlyDayName(e))}\n');
    //       })
    // ;
    emit(SelectedSlotTimingUpdated());
  }

  void updateSelectedMyAppointmentsDay(DateTime date) {
    selectedMyAppointmentsDay = date;
    emit(ViewChangedState());
  }

  void updateSelectedView(int view) {
    selectedAppointmentView = view;
    emit(ViewChangedState());
  }

  void toggleViewComment(bool? status) {
    if (status != null) {
      viewCommentInput = status;
    } else {
      viewCommentInput = !viewCommentInput;
    }

    emit(CommentViewChanged());
  }

  List<InsuranceProvider> filteredInsurancesProviders = [];
  List<User> filteredProviders = [];
  List<User> allProfessionals = [];
  List<User> allFacilities = [];
  List<User> filteredFacilities = [];

  String? selectedFacilityId;
  String? selectedProfessionalId;

  bool bookingForMySelf = true;

  // String? selectedTypeId;

  ResultsModel? resultsModel;

  SlotsModel? slotsModel;

  List<String> selectedInsurance = [];

  Slot? selectedDateTimeSlot;

  ViewType type = ViewType.professional;

  AppointmentType? selectedAppointmentType;
  AppointmentType? selectedAppTypeModelItem;
  ProfFacilityModel? profFacilityModel;
  String? fNameVal;
  String? dobVal;
  String? idVal;
  String? mobileVal;
  String? commentVal;
  String? emailVal;

  Map<CustFileType, File> userInfoFiles = {};

  void updateSelectedAppTypeModelItem(AppointmentType val) {
    if (selectedAppTypeModelItem != val) {
      selectedAppTypeModelItem = val;
      emit(AppTypeModelItemUpdated());
    }
  }

  void updateFilteredInsurancesProviders(String query) {
    filteredInsurancesProviders = insuranceProvidersModel!.insuranceProvidersList
        .where((element) => element.name.contains(query))
        .toList();
    emit(UpdateFilteredInsurances());
  }

  void updateFilteredProviders(String query) {
    logg('update: $query');
    filteredProviders = allProfessionals
        .where((element) => element.fullName!.toLowerCase().contains(query))
        .toList();
    emit(UpdateFilteredProviders());
  }

  void updateFilteredFacilities(String query) {
    logg('update: $query');
    filteredFacilities = allFacilities
        .where((element) => element.fullName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(UpdateFilteredProviders());
  }

  final kEvents = LinkedHashMap<DateTime, List<Slot>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  Map<DateTime, List<Slot>> kEventSource = {};

  selectFile(CustFileType fileType) async {
    // FilePickerResult? selectedFile;

    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    // selectedFile = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'png'],
    //   //allowed extension to choose
    // );
    if (photo != null) {
      File temp = File(photo.path);

      // ksand
      // MultipartFile file = await MultipartFile.fromFile(
      //   temp.path,
      //   filename: temp.path.split('/').last,
      // );

      if (userInfoFiles.containsKey(fileType)) {
        userInfoFiles.remove(fileType);
      }
      logg('asjkbdjk' + userInfoFiles.toString());
      userInfoFiles.addAll({fileType: temp});
    } else {
      // User canceled the picker
    }
    emit(AppointmentAttachmentPicked());
  }

  Future<void> confirmAndSaveAppointment() async {
    emit(SavingAppointmentState());

    ///
    /// get data then set the type due to response
    ///

    FormData formData;
    Map<String, dynamic> toSendData = {};
    ////
    toSendData = {
      'for_who': bookingForMySelf == true ? '1' : '2',
      'professional_id': '${selectedProfessionalId}',
      'facility_id': '${selectedFacilityId}',
      'appointment_slot_id': '${selectedDateTimeSlot!.id.toString()}',
      'full_name': fNameVal,
      'birthdate': dobVal,
      'id_number': idVal,
      'mobile_number': mobileVal,
      'email': emailVal,
      'id_front': userInfoFiles[CustFileType.fID] == null
          ? null
          : await MultipartFile.fromFile(
              userInfoFiles[CustFileType.fID]!.path,
              filename: userInfoFiles[CustFileType.fID]!.path.split('/').last,
            ),
      'id_back': userInfoFiles[CustFileType.bId] == null
          ? null
          : await MultipartFile.fromFile(
              userInfoFiles[CustFileType.bId]!.path,
              filename: userInfoFiles[CustFileType.bId]!.path.split('/').last,
            ),
      'insurance_front': userInfoFiles[CustFileType.insuranceFront] == null
          ? null
          : await MultipartFile.fromFile(
              userInfoFiles[CustFileType.insuranceFront]!.path,
              filename: userInfoFiles[CustFileType.insuranceFront]!.path.split('/').last,
            ),
      'insurance_back': userInfoFiles[CustFileType.insuranceBack] == null
          ? null
          : await MultipartFile.fromFile(
              userInfoFiles[CustFileType.insuranceBack]!.path,
              filename: userInfoFiles[CustFileType.insuranceBack]!.path.split('/').last,
            ),
      'comments': commentVal ?? '',
    };
    formData = FormData.fromMap(toSendData);

    logg(toSendData.toString());
    logg(formData.toString());
    await MainDioHelper.postDataWithFormData(
      url: saveAppointmentsEnd,
      data: formData,
    ).then((value) {
      logg('save appointment success...');
      logg(value.toString());
      // resultsModel = ResultsModel.fromJson(value.data);
      logg('skjhfsjkdfnsadkjs');

      if (value.statusCode == 200) {
        emit(SuccessSaveAppointmentState());
        // return true;
      }
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());

      emit(ErrorSaveAppointmentState());
      // return false;
    });
    // return false;
  }

  ///
  ///
  ///
  ///
  Future<void> confirmSlot() async {
    emit(ConfirmingSlotState());

    ///
    /// get data then set the type due to response
    ///

    FormData formData;
    Map<String, dynamic> toSendData = {};
    ////
    toSendData = {
      'appointment_type': '${selectedAppTypeModelItem!.id}',
      'facility_id':
          '${profFacilityModel!.data.type == 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',
      'professional_id':
          '${profFacilityModel!.data.type != 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',

      ///

      'fees': freeVal == true ? '0' : feesVal,
      // 'currency': idVal,
      'time_from': slotTimeRanges.map((e) => e.from.toString()).toList(),
      'time_to': slotTimeRanges.map((e) => e.to.toString()).toList(),
      'days': selectedSlotPickDays
          .map((e) => getWeekDayOrder(getFormattedDateOnlyDayName(e)))
          .toList(),
    };
    formData = FormData.fromMap(toSendData);

    logg('tosenddata: ' + toSendData.toString());
    logg('formdata: ' + formData.toString());
    await MainDioHelper.postData(
      url: saveSlotEnd,
      data: toSendData,
    ).then((value) {
      logg('save appointment success...');
      logg(value.toString());
      // resultsModel = ResultsModel.fromJson(value.data);
      logg('skjhfsjkdfnsadkjs');
      logg(value.statusCode.toString());

      if (value.statusCode == 200) {
        // emit(SuccessConfirmingSlotState());
        // return true;
        // return true;
      }
      emit(SuccessConfirmingSlotState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());

      emit(ErrorConfirmingSlotState());
      // return false;
      // return false;
    });
    // return false;
    // return false;
  }


  Future<void> updateSlot(String id,UpdateVal type) async {
    emit(UpdatingSlotState());

    ///
    /// get data then set the type due to response
    ///

    FormData formData;
    Map<String, dynamic> toSendData = {};
    ////
    toSendData = {
      'slot_id':id
      // 'appointment_type': '${selectedAppTypeModelItem!.id}',
      // 'facility_id':
      //     '${profFacilityModel!.data.type == 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',
      // 'professional_id':
      //     '${profFacilityModel!.data.type != 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',
      //
      // ///
      //
      // 'fees': freeVal == true ? '0' : feesVal,
      // // 'currency': idVal,
      // 'time_from': slotTimeRanges.map((e) => e.from.toString()).toList(),
      // 'time_to': slotTimeRanges.map((e) => e.to.toString()).toList(),
      // 'days': selectedSlotPickDays
      //     .map((e) => getWeekDayOrder(getFormattedDateOnlyDayName(e)))
      //     .toList(),
    };

    if(type==UpdateVal.type){
      toSendData['appointment_type']= '${selectedAppTypeModelItem!.id}';
    }
    if(type==UpdateVal.dateTime){
      toSendData['days']= selectedSlotPickDays
          .map((e) => getWeekDayOrder(getFormattedDateOnlyDayName(e)))
          .toList();
      toSendData['time_from']= slotTimeRanges.map((e) => e.from.toString()).toList();
      toSendData['time_to']= slotTimeRanges.map((e) => e.to.toString()).toList();
    }
    if(type==UpdateVal.profFacPrice){

      // 'facility_id':
      //     '${profFacilityModel!.data.type == 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',
      // 'professional_id':
      //     '${profFacilityModel!.data.type != 'facilities' ? selectedSlotFacilityProf!.id.toString() : null}',
      //
      // ///
      //
      // 'fees': freeVal == true ? '0' : feesVal,

      toSendData['facility_id']= profFacilityModel!.data.type == 'facilities' ? selectedSlotFacilityProf!.id.toString() : null;
      toSendData['professional_id']= profFacilityModel!.data.type != 'facilities' ? selectedSlotFacilityProf!.id.toString() : null;
      toSendData['fees']= freeVal == true ? '0' : feesVal;
    }

    formData = FormData.fromMap(toSendData);

    logg('tosenddata: ' + toSendData.toString());
    logg('formdata: ' + formData.toString());
    await MainDioHelper.postData(
      url: updateSlotEnd,
      data: toSendData,
    ).then((value) {
      logg('save appointment success...');
      logg(value.toString());
      // resultsModel = ResultsModel.fromJson(value.data);
      logg('skjhfsjkdfnsadkjs');
      logg(value.statusCode.toString());

      // if (value.statusCode == 200) {
      //   // emit(SuccessConfirmingSlotState());
      //   // return true;
      //   // return true;
      // }
      emit(SuccessUpdatingSlotState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());

      emit(ErrorUpdatingSlotState());
      // return false;
      // return false;
    });
    // return false;
    // return false;
  }

  void saveMainInfo({
    required String fName,
    required String dob,
    required String id,
    required String mobile,
    required String email,
    // required String comment,
  }) {
    fNameVal = fName;
    dobVal = dob;
    idVal = id;
    mobileVal = mobile;
    emailVal = email;
  }

  void updateComment(String comment) {
    commentVal = comment;
  }

  void updateBookingForMySelf(bool val) {
    bookingForMySelf = val;
    emit(BookingForMySelfChanged());
  }

  void updateSelectedDateTimeSlot(Slot slot) {
    selectedDateTimeSlot = slot;
  }

  DateTime focusedDay = DateTime.now();

  void updateFocusedDay(DateTime date) {
    logg('updateFocusing date');
    focusedDay = date;
    emit(AppointmentTypeUpdated());
  }

  List<DateTime> toHighlight = [];

  Future<void> updateSelectedAppointmentType(AppointmentType type) async {
    selectedAppointmentType = type;
    await getSlots().then((value) {
      if (slotsModel!.allDatesAndSlots != null) {
        Map<String, List<Slot>> data = slotsModel!.allDatesAndSlots!;
        kEventSource.clear();
        kEvents.clear();
        data.forEach((key, value) {
          logg('test log dkl');
          logg(kEventSource.toString());
          kEventSource.addAll({DateTime.parse(key): value.map((e) => e).toList()});
        });

        /// add to k events
        kEvents.addAll(kEventSource);

        toHighlight.addAll((kEventSource.keys));

        updateFocusedDay(
            DateTime.parse(slotsModel!.allDatesAndSlots!.keys.first).isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime.parse(slotsModel!.allDatesAndSlots!.keys.first));
      }

      // kEventSource = Map.fromIterable(List.generate(
      // data.length
      // , (index) => index),
      //     key: (item) => DateTime.utc(2023, 3, 6),
      //     value: (item) => List.generate(
      //         8, (index) => CalendarEvent('Event $item | ${index + 1}')))
      //   ..addAll({
      //     kToday: [
      //       CalendarEvent('9:00 AM'),
      //       // CalendarEvent('9:00 AM'),
      //
      //     ],
      //   });
    });
    emit(AppointmentTypeUpdated());
  }

  ///
  ///
  ///
  ///
  Future<void> updateClientAppointmentState(String appointmentId, String state) async {
    emit(UpdatingClientAppointment());
    await MainDioHelper.postData(
        url: '$updateClientAppointmentEnd',
        query: {'id': '$appointmentId', 'state': '$state'}).then((value) async {
      logg('UpdatingClientAppointment data got');
      logg(value.toString());
      getClientAppointments(selectedMyAppointmentsDay);
      emit(UpdatingClientAppointmentSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorUpdatingClientAppointmentState());
    });
  }

  Future<void> getClientAppointments(DateTime timestamp) async {
    emit(LoadingClientAppointment());
    await MainDioHelper.getData(url: '$getClientAppointmentsEnd?date=$timestamp', query: {})
        .then((value) async {
      logg('LoadingClientAppointment data got');
      logg(value.toString());

      clientAppointmentsModel = AppointmentsModel.fromJson(value.data);
      logg('LoadingClientAppointment model filled');

      /// save local db
      // await jsonStore.setItem('homeSections', homeSectionModel!.toJson());
      /// end local db
      emit(LoadingClientAppointmentSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingClientAppointmentState());
    });
  }

  Future<void> getMySlots() async {
    emit(LoadingMySlotsAppointment());
    await MainDioHelper.getData(url: '$getMySLotsEnd', query: {}).then((value) async {
      logg('getMySlots data got');
      logg(value.toString());
      mySlotsModel = MySlotsModel.fromJson(value.data);
      logg('getMySlots model filled');

      /// save local db
      // await jsonStore.setItem('homeSections', homeSectionModel!.toJson());
      /// end local db
      emit(LoadingClientAppointmentSuccessState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg('stack:');

      logg(stack.toString());
      emit(ErrorLoadingClientAppointmentState());
    });
  }

  Future<void> getAppointmentHistory({String? state}) async {
    emit(LoadingAppointmentHistory());

    logg('state is: $state');
    Map<String, dynamic> tosSendData = {};
    if (state != null && state != '0') {
      tosSendData['state'] = state;
    }
    await MainDioHelper.getData(url: '$getAppHistoryEnd', query: tosSendData)
        .then((value) async {
      logg('getAppHistoryEnd data got');
      logg(value.toString());

      historyAppointmentsModel = AppointmentsModel.fromJson(value.data);
      logg('model filled');

      /// save local db
      // await jsonStore.setItem('homeSections', homeSectionModel!.toJson());
      /// end local db
      emit(LoadingClientAppointmentSuccessState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorLoadingClientAppointmentState());
    });
  }

  Future<void> deleteSlot(String slotId) async {
    emit(DeletingSlotState());
    await MainDioHelper.postData(url: '$deleteSlotEnd', query: {
      'id':slotId
    }).then((value) async {
      logg('success DeletingSlotState');
      logg(value.toString());

      /// save local db
      // await jsonStore.setItem('homeSections', homeSectionModel!.toJson());
      /// end local db
      emit(DeletingSlotStateSuccess());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorDeletingSlotStateState());
    });
  }

  void resetSelectedInsurance() {
    selectedInsurance = [];
    emit(SelectedInsuranceUpdated());
  }

  // void updateSelectedType(String id) {
  //   selectedTypeId = id;
  //   emit(SelectedTypeUpdated());
  // }

  void updateSelectedInsurances(String id) {
    if (selectedInsurance.contains(id)) {
      selectedInsurance.remove(id);
    } else {
      selectedInsurance.add(id);
    }
    emit(SelectedInsuranceUpdated());
  }

  void updateSelectedProfessionalId(String? id) {
    selectedProfessionalId = id;
    emit(SelectedProfUpdated());
  }

  void updateSelectedFacilityId(String? id) {
    selectedFacilityId = id;
    emit(SelectedProfUpdated());
  }

  List<ItemWithTitleAndCallback> appointmentTypes = [
    ItemWithTitleAndCallback(
      title: 'test',
      thumbnailLink: '',
      onClickCallback: () {},
    )
  ];

  void updateType(ViewType type) {
    type = type;
    emit(TypeUpdated());
  }

  Future<void> searchForProfessionalsFacilities({
    required String? searchKey,
    required String? providerId,
    required String? facilityId,
    required List<String>? specialities,
    required List<String>? specialityGroups,
    required List<String>? insuranceProviders,
  }) async {
    emit(SearchingProFacState());

    ///
    /// get data then set the type due to response
    ///
    Map<String, String?> toSendData = {
      'name': searchKey ?? '',
      'speciality_groups': '${specialityGroups ?? []}',
      'specialities': '${specialities ?? []}',
      'insurance_provider': '${insuranceProviders ?? []}',
      'provider_id': providerId ?? '',
      'facility_id': facilityId ?? '',
    };
    await MainDioHelper.postData(
      url: searchAppointmentsProfessionalFacilitiesEnd,
      query: toSendData,
    ).then((value) {
      logg('searching prof fac list fetched...');
      logg(value.toString());
      resultsModel = ResultsModel.fromJson(value.data);

      if (resultsModel!.data.type == 'professionals') {
        allProfessionals = resultsModel!.data.users;
        filteredProviders = resultsModel!.data.users;
      } else {
        allFacilities = resultsModel!.data.users;
        filteredFacilities = resultsModel!.data.users;
      }

      logg('skjhfsjkdfnsadkjs');
      if (resultsModel!.data.type == 'professionals') {
        updateType(ViewType.professional);
      } else {
        updateType(ViewType.facilities);
      }

      emit(SuccessSearchingProFacState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorSearchingProFacState());
    });
  }

  Future<void> getInsuranceList(BuildContext context, {User? user}) async {
    emit(GettingInsuranceList());
    String? providerId;
    List<String>? specialities = [];
    List<String>? specialityGroups = [];
    if (user != null) {
      logg('getting getInsuranceList due to provider');
      providerId = user.id.toString();
    } else {
      logg('getting getInsuranceList due to specialities filter');
      providerId = null;
      specialityGroups = [AuthCubit.get(context).selectedSubMenaCategory.id.toString()];
      specialities =
          AuthCubit.get(context).selectedSpecialities?.map((e) => e.id.toString()).toList();
    }

    Map<String, String?> toSendData = {};

    if (providerId != null) {
      toSendData['provider_id'] = '${providerId}';
    }
    if (specialityGroups.isNotEmpty) {
      toSendData['speciality_groups'] = '${specialityGroups}';
    }
    if (specialities != null) {
      if (specialities.isNotEmpty) {
        toSendData['specialities'] = '${specialities}';
      }
    }

    await MainDioHelper.postData(
      url: getInsuranceProvidersListEnd,
      query: toSendData,
    ).then((value) {
      logg('insurance list fetched...');
      logg(value.toString());
      insuranceProvidersModel = InsuranceProvidersModel.fromJson(value.data);

      filteredInsurancesProviders = insuranceProvidersModel!.insuranceProvidersList;
      logg('skjhfsjkdfnkjs');

      emit(SuccessGettingInsuranceList());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorGettingInsuranceList());
    });
  }

  Future<void> getProvidersProfessionalForCreatingSlot() async {
    emit(GettingProfProvidersList());

    await MainDioHelper.postData(
      url: getProfProvidersListEnd,
      query: {},
    ).then((value) {
      logg('GettingProfProvidersList fetched...');
      logg(value.toString());
      profFacilityModel = ProfFacilityModel.fromJson(value.data);
      logg('GettingProfProvidersList model filled');
      emit(SuccessGettingProfProvidersList());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorGettingProfProvidersList());
    });
  }

  Future<void> getSlots() async {
    emit(GettingSlotsList());

    await MainDioHelper.postData(
      url: getAppointmentsSlotsEnd,
      query: {
        'professioanl_id': selectedProfessionalId,
        'facility_id': selectedFacilityId,
        'appointment_type': selectedAppointmentType!.id,
      },
    ).then((value) {
      logg('Slots fetched...');
      logg(value.toString());

      slotsModel = SlotsModel.fromJson(value.data);
      logg('skjhfsjkdfnkjs');

      emit(SuccessGettingSlotsList());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg('an stack error occurred');

      logg(stack.toString());
      emit(ErrorGettingSlotsList());
    });
  }

// MenaPlatform? selectedPlatform;
// void updateSelectedPlatform(
//     MenaPlatform platform, bool updateProviderTypes) {
//   selectedPlatform = platform;
//
//
//   /// when platform changed reset all
//   resetCategoriesFilters();
//   ///
//   if (updateProviderTypes) {
//     getPlatformCategories(selectedPlatform!.id.toString());
//   }
//   emit(SelectedPlatformUpdated());
//
// }

// Future<void> getPlatformCategories(String platformId) async {
//   platformCategory = null;
//   emit(AuthGetPlatformCategoriesLoadingState());
//   await MainDioHelper.getData(
//       url: '${platformCategoriesEnd}/${platformId.toString()}',
//       query: {}
//   ).then((value) async {
//     logg('getProviderTypes response: $value');
//     platformCategory = CategoriesModel.fromJson(value.data);
//
//     if (platformCategory!.data.isNotEmpty) {
//       updateSelectedMenaCategory(platformCategory!.data[0]);
//     } else {
//       updateSelectedMenaCategory(MenaCategory(id: -1));
//     }
//     // if (platformCategory!.childs!.isNotEmpty) {
//     //   changeSelectedProviderType(platformCategory!.data[0]);
//     // }
//     emit(SignUpSuccessState());
//   }).catchError((error) {
//     logg(error.response.toString());
//     emit(AuthErrorState(getErrorMessageFromErrorJsonResponse(error)));
//   });
// }
//
// ///
// /// filters functions
// ///
// void resetCategoriesFilters(){
//   updateSelectedSpecialities([]);
//   updateSelectedMenaCategory(MenaCategory(id: -1));
//   updateSelectedSubMenaCategory(MenaCategory(id: -1));
//
//
// }
}

enum ViewType { professional, facilities }

enum CustFileType { fID, bId, insuranceFront, insuranceBack }
