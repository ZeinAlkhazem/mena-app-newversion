import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_store/json_store.dart';
import 'package:mena/models/api_model/counters_model.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/models/api_model/plans_model.dart';
import 'package:mena/models/api_model/user_info_model.dart';
import 'package:mena/modules/feeds_screen/post_a_feed.dart';
import 'package:mena/modules/my_profile/cubit/profile_cubit.dart';
import '../../l10n/l10n.dart';
import '../../models/api_model/config_model.dart';
import '../../models/local_models.dart';
import '../../models/my_models/country_model.dart';
import '../../modules/platform_provider/provider_home/provider_profile_Sections.dart';
import '../cache/cache.dart';
import '../constants/my_countries.dart';
import '../functions/main_funcs.dart';
import '../network/dio_helper.dart';
import '../network/network_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

      
  IO.Socket messageSocket = IO.io(
      'https://chat.menaaii.com:3000',
      IO.OptionBuilder().setTransports(['websocket'])
          // for Flutter or Dart VM
          .setExtraHeaders({
        'foo': 'bar',
      }) // optional
          .build()
  );
  
  IO.Socket socket = IO.io(
      'https://live.menaaii.com:3000',
      IO.OptionBuilder().setTransports(['websocket'])
          // for Flutter or Dart VM
          .setExtraHeaders({
        'foo': 'bar',
      }) // optional
          .build());

  String currentLogo = 'assets/svg/mena8.svg';


  List<String?> selectedLocalesIsoInDashboard = [];

  // configModel!.data.languages.map((e) => e.code).toList();
  List<Locale> selectedLocalesInDashboard = [];

  // L10n.all.where((element) => selectedLocalesIsoInDashboard.contains(element)).toList();
  String selectedPlanId = '1';
  String currentTryingToFollowUser = '-1';
  ConfigModel? configModel;
  PlansModel? plansModel;
  bool medicalRecordExpanded = false;
  bool myActivitiesExpanded = false;
  bool aboutMenaExpanded = false;
  String selectedCountryAlpha3Code = '';
  UserInfoModel? userInfoModel;
  List<ItemWithTitleAndCallback> uncompletedSections = [];
  double completionPercentage = 0.0;
  List<MayyaCountry> mayyaCountries = MayyaCountryProvider.getCountriesData(countries: []);
  String countrySearchQuery = '';
  Locale? appLocale =
      L10n.all.firstWhere((element) => element.languageCode == getCachedLocal().toString(), orElse: () => L10n.all[0]);
  String? defaultLang = getCachedLocal().toString();

  ///
  bool isHeaderVisible = true;
  bool? firstRun = getCachedFirstApplicationRun(); //initial values(lang and location) saved?

  bool setUpChecked = false;
  bool isUserLoggedIn = false;
  bool requireDataCompleted = false;
  bool setUpDataChecked = false;
  dynamic connectivityResult;
  bool isConnected = false;

  CountersModel? countersModel;

  /// if provider
  bool isUserProvider() {
    return userInfoModel?.data.user.roleId.toString() == '2';
    // return false;
  }

  List<ItemWithTitleAndCallback> userActionItems(BuildContext context) {
    List<ItemWithTitleAndCallback> list = [];
    if (isUserProvider()) {
      list = [
        ItemWithTitleAndCallback(
          title: 'New Post',
          thumbnailLink: 'assets/svg/icons/profile/New post.svg',
          onClickCallback: () {
            logg('dshjfjkh');
            navigateToWithoutNavBar(context, PostAFeedLayout(), 'routeName');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Go live',
          thumbnailLink: 'assets/svg/icons/profile/go live.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'New slot',
          thumbnailLink: 'assets/svg/icons/profile/new slot.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
      ];
    } else {
      list = [
        ItemWithTitleAndCallback(
          title: 'SOS Video call',
          thumbnailLink: 'assets/svg/icons/profile/sos.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Request Blood',
          thumbnailLink: 'assets/svg/icons/profile/Request blood.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Make appointment',
          thumbnailLink: 'assets/svg/icons/profile/make appointment.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Ask Professionals',
          thumbnailLink: 'assets/svg/icons/profile/ask professionals.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Post Job',
          thumbnailLink: 'assets/svg/icons/profile/Post Job.svg',
          onClickCallback: () {
            logg('dshjfjkh');
          },
        ),
      ];
    }
    return list;
  }

  void removeUserModel() {
    userInfoModel = null;
  }

  void calcCompletionPercentage() {
    uncompletedSections = [];
    int sectionsAllLength = 7;
    int completedSections = 0;
    MoreData? moreData = userInfoModel!.data.user.moreData;

    if (moreData == null) {
      completedSections = 0;
    } else {
      if (moreData.about != null && moreData.about!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'about',
          title: '+ Add About',
          thumbnailLink: 'assets/svg/icons/profile/About.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.educations != null && moreData.educations!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'education',
          title: '+ Add education',
          thumbnailLink: 'assets/svg/icons/profile/education.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.experiences != null && moreData.experiences!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'Experience',
          title: '+ Add Experience',
          thumbnailLink: 'assets/svg/icons/profile/Experiences.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.publications != null && moreData.publications!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'Publications',
          title: '+ Add Publications',
          thumbnailLink: 'assets/svg/icons/profile/Publications.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.certifications != null && moreData.certifications!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'Certifications',
          title: '+ Add Certifications',
          thumbnailLink: 'assets/svg/icons/profile/Certifications.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.memberships != null && moreData.memberships!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'Memberships',
          title: '+ Add Memberships',
          thumbnailLink: 'assets/svg/icons/profile/Memberships.svg',
          onClickCallback: () {},
        ));
      }
      if (moreData.rewards != null && moreData.rewards!.isNotEmpty) {
        completedSections += 1;
      } else {
        uncompletedSections.add(ItemWithTitleAndCallback(
          id: 'Rewards',
          title: '+ Add Rewards',
          thumbnailLink: 'assets/svg/icons/profile/Awards.svg',
          onClickCallback: () {},
        ));
      }
    }

    completionPercentage = completedSections * 100 / sectionsAllLength;
    emit(UpdateState());
  }

  void updateMenaViewedLogo(String val) {
    currentLogo = val;
    emit(UpdateState());
  }

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }

    return true;
  }

  /// user follow or unfollow
  Future<void> followUser({
    required String userId,
    required String userType,
  }) async {
    // feedsModel = null;
    currentTryingToFollowUser = userId;
    emit(FollowingUserState());
    ////

    await MainDioHelper.postData(
      url: followUserEnd,
      query: {
        'user_id': userId,
        'user_type': userType,
      },
    ).then((value) {
      logg('user followed...');

      logg(value.toString());
      emit(SuccessFollowingUserState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorFollowingUserState());
    });
  }

  Future<void> unfollowUser({
    required String userId,
    required String userType,
  }) async {
    // feedsModel = null;
    currentTryingToFollowUser = userId;
    emit(FollowingUserState());
    ////

    await MainDioHelper.postData(
      url: followUserEnd,
      query: {
        'user_id': userId,
        'user_type': userType,
      },
    ).then((value) {
      logg('user unfollowed...');
      logg(value.toString());
      emit(SuccessFollowingUserState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorFollowingUserState());
    });
  }

  Future<void> checkPermAndSaveLatLng(context) async {
    if (await handleLocationPermission(context)) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      saveCacheLat(position.latitude.toString());
      saveCacheLng(position.longitude.toString());
    }
  }

  void changeSelectedPlanItemId(String id) {
    logg('change selected plan item id : $id');
    if (selectedPlanId != id) {
      selectedPlanId = id;
      emit(SelectedItemIdChanged());
    }
  }

  Future<void> updateCountrySearchQuery(String query) async {
    countrySearchQuery = query;
    logg('updateCountrySearchQuery fn: $countrySearchQuery');
    await Future.delayed(const Duration(milliseconds: 200));

    if (countrySearchQuery == '') {
      mayyaCountries = MayyaCountryProvider.getCountriesData(countries: []);
    } else {
      mayyaCountries = MayyaCountryProvider.getCountriesData(countries: [])
          .where((element) =>
              element.nameTranslations![appLocale!.languageCode]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(CountrySearchQueryUpdated());
  }

  void updateSelectedCountry(String value) {
    selectedCountryAlpha3Code = value;
    emit(SelectedCountryUpdated());
  }

  Future<void> medicalRecordExpandedToggle() async {
    medicalRecordExpanded = !medicalRecordExpanded;
    emit(ExpandedChanged());
  }

  Future<void> myActivitiesExpandedToggle() async {
    myActivitiesExpanded = !myActivitiesExpanded;
    emit(ExpandedChanged());
  }

  Future<void> aboutMenaExpandedToggle() async {
    aboutMenaExpanded = !aboutMenaExpanded;
    emit(ExpandedChanged());
  }

  void changeHeaderVisibility(bool status) {
    if (isHeaderVisible == status) {
    } else {
      isHeaderVisible = status;
      emit(HeaderVisibilityChanged());
    }
  }

  Future<void> checkSetUpData() async {
    /// check token saved? then call check token service
    /// if user info got so user logged in true
    /// this service should
    ///
    if (getCachedToken() != null) {
      ///
      ///get user  info
      ///if get user info bla bla bla
      ///
      await getUserInfo();
      if (userInfoModel != null) {
        isUserLoggedIn = true;
      }
    }
    setUpChecked = true;
    emit(SetUpCheckedState());
  }

  Future<void> getUserInfo() async {
    /// get local db
    JsonStore jsonStore = JsonStore();
    // Map<String, dynamic>? json = await jsonStore.getItem('user_info');
    // if (json != null) {
    //   logg('user info data got from sqflite');
    //   userInfoModel = UserInfoModel.fromJson(json);
    //   requireDataCompleted = userInfoModel!.data.dataCompleted.completed;
    //   logg('local stored user info: ${userInfoModel!.message}');
    // }

    ///
    ///
    /// end local db
    ///
    ///
    ///
    ///

    await MainDioHelper.getData(url: userInfoEnd, query: {}).then((value) async {
      logg('got user info ');
      logg("${value.toString()}");
      userInfoModel = UserInfoModel.fromJson(value.data);
      requireDataCompleted = userInfoModel!.data.dataCompleted.completed;

      socketInitial();

      calcCompletionPercentage();
      logg('required data completed: $requireDataCompleted');
      emit(SetUpCheckedState());

      /// save local db
      await jsonStore.setItem('user_info', userInfoModel!.toJson());

      /// end local db
    }).catchError((error, stack) {
      /// read from hive
      ///
      ///
      ///
      logg('an error occurred ---- got user info');
      // logg("${error.toString()}");
      // logg("${stack.toString()}");
    });
  }

  void socketInitial() async {
    /// Socket connect
    print('establishing socket connection');
    socket = await IO.io(

        'https://live.menaaii.com:3000',

        IO.OptionBuilder().setTransports(['websocket'])
            // for Flutter or Dart VM
            .setExtraHeaders({
          'foo': 'bar',
        }) // optional
            .build());
      messageSocket = await IO.io(
        'https://chat.menaaii.com:3000',

        IO.OptionBuilder().setTransports(['websocket'])
            // for Flutter or Dart VM
            .setExtraHeaders({
          'foo': 'bar',
        }) // optional
            .build());

    ///
    // IO.Socket socket =await IO.io('https://menaplatforms.com:3000');

    logg(socket.json.connected.toString());
    socket.onConnect((_) {
      print('socket connection established');

      if (userInfoModel != null) {
        socket.emit('join', [
          {'user_id': '${userInfoModel!.data.user.id}', 'type': '${isUserProvider() ? 'provider' : 'client'}'},
        ]);

        logg('emitted');
      }
      socket.emit('msg', 'socket test');
    });

    socket.on('event', (data) => print('socket ' + data));
    socket.on('counters', (data) {
      print('socket: ${data.toString()}');
      getCountersData();
    });



    messageSocket.onConnect((_) {
      print('socket connection established');


      if (userInfoModel != null) {
        messageSocket.emit('join', [
          {'user_id': '${userInfoModel!.data.user.id}', 'type': '${isUserProvider() ? 'provider' : 'client'}'},
        ]);

        logg('emitted');
      }
      messageSocket.emit('msg', 'socket test');
    });

    messageSocket.on('event', (data) => print('socket ' + data));
    messageSocket.on('counters', (data) {
      print('socket: ${data.toString()}');
      getCountersData();
    });
    // socket.on('new-message', (data) => print('socket: ' + data));
    socket.onAny((event, data) {
      print('socket: event: ' + event);
      print('socket: data:  ${data ?? 'Null data'}');
    });

    socket.onerror((err) => {logg('Socket error : $err')});

    messageSocket.onConnectError((data) => logg(data.toString()));

    messageSocket.onDisconnect((_) => print('socket disconnect'));

    // socket.on
    messageSocket.on('fromServer', (_) => print('socket ' + _));


     socket.onConnectError((data) => logg(data.toString()));

    socket.onDisconnect((_) => print('socket disconnect'));

    // socket.on
    socket.on('fromServer', (_) => print('socket ' + _));
  }

  Future<bool> checkConnectivity() async {
    logg('checkConnectivity');
    connectivityResult = null;
    emit(ConnectionStateChanging());
    if (kIsWeb) {
      isConnected = true;
    } else {
      if (Platform.isWindows) {
        logg('platform : Platform.isWindows');
        isConnected = true;
        //because connectivity package is not working well on windows
        // so we make windows connected
      } else {
        connectivityResult = await (Connectivity().checkConnectivity());
        logg(connectivityResult.toString());
        isConnected = connectivityResult != ConnectivityResult.none;
      }
    }
    logg('connected: $isConnected');
    emit(ConnectionStateChanged());
    return isConnected;
  }

  Future<void> getConfigData() async {
    /// get local db
    logg('getting config');
    JsonStore jsonStore = JsonStore();
    // if(!kIsWeb){
    //   Map<String, dynamic>? json = await jsonStore.getItem('config');
    //   if (json != null) {
    //     logg('config data got from sqfLite');
    //     configModel = ConfigModel.fromJson(json);
    //     logg('local stored config: ${configModel!.message}');
    //     selectedLocalesIsoInDashboard = configModel!.data.languages
    //         .map((e) => e.code!.split('_')[0])
    //         .toList();
    //     selectedLocalesInDashboard = L10n.all
    //         .where((element) =>
    //             selectedLocalesIsoInDashboard.contains(element.languageCode))
    //         .toList();
    //   }
    // }
    ///    /// end local db
    logg('getting config data');
    await MainDioHelper.getData(url: configEnd, query: {}).then((value) async {
      logg('config data got');
      logg(value.toString());
      // logg(value.toString());
      configModel = ConfigModel.fromJson(value.data);
      selectedLocalesIsoInDashboard = configModel!.data.languages.map((e) => e.code!.split('_')[0]).toList();
      selectedLocalesInDashboard =
          L10n.all.where((element) => selectedLocalesIsoInDashboard.contains(element.languageCode)).toList();

      /// save local db
      if (!kIsWeb) {
        await jsonStore.setItem('config', configModel!.toJson());
      }

      /// end local db
      // logg('trest value: '+value.toString());
      // logg('trest value.data: '+value.data.toString());
      // logg('trest jsonEncode: '+jsonEncode(value.data).toString());
      // logg('trest jsonDecode: '+jsonDecode(value.data).toString());
      // logg('trest encode: '+json.encode(value.data).toString());
      // logg('trest decode: '+json.decode(value.data).toString());

      // insertIntoMyDatabase(
      //   tableName: databaseStoredJsonTableName,
      //   rawNameVal: 'config',
      //   jsonVal:
      //   value.toString(),
      // ).then((value) => logg('trest: '));
      //
      // logg('trest: '+value.toString());
      //
      // logg('trest: '+value.data.toString());
      //
      // readJsonValFromMyDatabase(
      //            tableName: databaseStoredJsonTableName, rawNameVal: 'config')
      //        .then((value) {
      //   try{
      //     var jsonobj = jsonDecode(value);
      //     logg(jsonobj.toString());
      //   }catch(e){
      //     print(e);
      //   }
      //          // configModel=ConfigModel.fromJson(json.decode(value.toString().trim()));
      //          // logg('read result for config is: ${value.toString().trim()}');
      //          // logg('configModelFromJson is: ${configModel.toString()}');
      //        });

      logg('selectedLocalesIsoInDashboard: ${selectedLocalesIsoInDashboard}');
      logg('selectedLocalesInDashboard: ${selectedLocalesInDashboard}');
      emit(DataLoadedSuccessState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorLoadingDataState());
    });
  }
  Future<void> getCountersData() async {
    logg('getting counters');
    await MainDioHelper.getData(url: countersEnd, query: {}).then((value) async {
      logg('counters data got');
      logg(value.toString());
      // logg(value.toString());
      countersModel=CountersModel.fromJson(value.data);
      emit(DataLoadedSuccessState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorLoadingDataState());
    });
  }

  Future<void> getPlans() async {
    /// get
    logg('getting plans data');
    await MainDioHelper.getData(url: getPlansEnd, query: {}).then((value) async {
      logg('plans data got');
      logg('value: ${value.toString()}');
      // logg(value.toString());
      plansModel = PlansModel.fromJson(value.data);
      emit(DataLoadedSuccessState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingDataState());
    });
  }

  void setLocale(Locale locale, BuildContext context, bool isFirstScreen) {
    if (!L10n.all.contains(locale)) {
      logg('logVal');
      logg('locale not available');
      return;
    }
    appLocale = locale;
    logg('locale changed to:${appLocale!.languageCode}');
    saveCacheLocal(appLocale!.languageCode.toString());
    logg('saved cache local: ${getCachedLocal().toString()}');
    // updateDefaultLang();
    // MainCubit.get(context);
    emit(LocaleChangedState());
    // ..getHomeSection();
    // isFirstScreen
    //     ? navigateToAndFinishUntil(context, const MainAppMaterialApp())
    // // : Restart.restartApp(webOrigin: '[your main route]');
    //     :Navigator.pop(context);
  }

  void updateDefaultLang() {
    defaultLang = getCachedLocal();
    emit(LocaleChangedState());
  }
}
