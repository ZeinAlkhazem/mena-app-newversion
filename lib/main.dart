import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/cubit/healthcare_cubit.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/cubit/market_cubit.dart';
import 'package:mena/MenaMarketPlace/injection_container.dart' as di;
import 'package:mena/core/bloc_observer.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/l10n/l10n.dart';
import 'package:mena/modules/auth_screens/cubit/auth_cubit.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/splash_screen/splash_screen.dart';
import 'package:mena/modules/tools/cubit/tools_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/cache/cache.dart';
import 'core/cache/sqflite/sqf_helper.dart';
import 'core/constants/Colors.dart';
import 'core/constants/constants.dart';
import 'core/network/dio_helper.dart';
import 'firebase_options.dart';
import 'modules/add_people_to_live/cubit/add_people_to_live_cubit.dart';
import 'modules/appointments/appointments_layouts/pick_appointment_slot_type.dart';
import 'modules/appointments/cubit/appointments_cubit.dart';
import 'modules/category_childs_screen/cubit/childs_cubit.dart';
import 'modules/community_space/cubit/community_cubit.dart';
import 'modules/complete_info_subscribe/cubit/complete_info_cubit.dart';
import 'modules/create_live/cubit/create_live_cubit.dart';
import 'modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'modules/home_screen/cubit/home_screen_cubit.dart';
import 'modules/meeting/cubit/meeting_cubit.dart';
import 'modules/messenger/cubit/messenger_cubit.dart';
import 'modules/my_profile/cubit/profile_cubit.dart';
import 'modules/nearby_screen/cubit/nearby_cubit.dart';
import 'modules/platform_provider/cubit/provider_cubit.dart';
import 'modules/promotions_screen/cubit/promotions_cubit.dart';
import 'modules/start_live/cubit/start_live_cubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//
// late Box userBox;
late SharedPreferences prefs;
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await PatchAllLocales.patchNumberSeperators();
  final regionCode = await LocalePlus().getRegionCode();
  final languageCode = await LocalePlus().getLanguageCode();
  /// set status bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: AppColors.iconsColor,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));

  // await initializeDateFormatting();
  prefs = await SharedPreferences.getInstance();
  var selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';

  // Get the default phone language and set it as the default language
  final myLocale = WidgetsBinding.instance.window.locale;
  if (myLocale.languageCode == 'ar') {
    selectedLanguage = 'Arabic';
    logg('my device language is : $selectedLanguage');
  } else {
    selectedLanguage =
        'English'; // You can set other default languages if needed
    logg('my device language is '
        '$selectedLanguage');
  }
  await prefs.setString('selectedLanguage', selectedLanguage);

  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await MainDioHelper.init();

  /// handle error best way
  /// init hive
  // await Hive.initFlutter();
  // saveCacheLocal('ar');
  /// Register adapters
  ///
  // Hive.registerAdapter(UserInfoModelAdapter());
  // logg('opened box name: '+box.name);
  // logg('opened box name: '+box.keys.toString());
  // // await box.close();
  // var box2 = await Hive.openBox('myBox');
  // await box2.put('hello22', 'world');
  // logg('2opened box name: '+box.keys.toString());
  /// register hive adapter
  // Hive.registerAdapter(UserInfoAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await MainDioHelper.init();

  /// firebase initialize
  /// now web options is not initialized yet so ignore web for now
  if (!kIsWeb) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // bool inDebug = false;
      // assert(() {
      //   inDebug = true;
      //   return true;
      // }());
      // if (inDebug) {
      //   return ErrorWidget(details.exception);
      // }

      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: 0.3.sh,
          child: Center(
            child: Column(
              children: [
                heightBox(10.h),
                Text('Something went wrong'),
                Text('Let us know what happened'),
                DefaultButton(
                    text: 'Send',
                    onClick: () {
                      logg('sending error: ');
                      logg('store it in firebase');
                      logg('all details: ${details}');
                      logg('exception: ${details.exception}');
                    })
              ],
            ),
          ),
        ),
      );
    };
    // await Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  // runApp(const MainAppProvider());
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(const MainAppProvider());
      //
    },
    blocObserver: MyBlocObserver(),
  );

  /// test
  // runApp(const MainAppProvider());
}

class MainAppProvider extends StatelessWidget {
  const MainAppProvider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => MainCubit()),
        BlocProvider(create: (BuildContext context) => ChildsCubit()),
        BlocProvider(create: (BuildContext context) => MessengerCubit()),
        BlocProvider(create: (BuildContext context) => CreateArticleCubit()),
        BlocProvider(create: (BuildContext context) => LiveCubit()),
        BlocProvider(create: (BuildContext context) => PromotionsCubit()),
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => CompleteInfoCubit()),
        BlocProvider(create: (BuildContext context) => CommunityCubit()),
        BlocProvider(create: (BuildContext context) => ProviderCubit()),
        BlocProvider(create: (BuildContext context) => HomeScreenCubit()),
        BlocProvider(create: (BuildContext context) => FeedsCubit()),
        BlocProvider(create: (BuildContext context) => AppointmentsCubit()),
        BlocProvider(create: (BuildContext context) => NearbyCubit()),
        BlocProvider(create: (BuildContext context) => ProfileCubit()),
        BlocProvider(create: (BuildContext context) => ToolsCubit()),
        BlocProvider(create: (BuildContext context) => CreateLiveCubit()),
        BlocProvider(create: (BuildContext context) => StartLiveCubit()),
        BlocProvider(create: (BuildContext context) => AddPeopleToLiveCubit()),
        BlocProvider(create: (BuildContext context) => MeetingCubit()),
        BlocProvider(create: (BuildContext context) => MarketCubit()),
        BlocProvider(create: (BuildContext context) => CreateArticleCubit()),
        BlocProvider(create: (BuildContext context) => MyBlogCubit()),
        // ChangeNotifierProvider(create: (context) => ErrorNotifier()),
        BlocProvider(
          create: (context) => di.sl<HealthcareCubit>(),
        ),
      ],
      child: const MainMaterialApp(),
    );
  }
}

class MainMaterialApp extends StatefulWidget {
  const MainMaterialApp({Key? key}) : super(key: key);

  @override
  State<MainMaterialApp> createState() => _MainMaterialAppState();
}

class _MainMaterialAppState extends State<MainMaterialApp> {
  Locale _deviceLocale = const Locale('en'); // Default language if locale detection fails


  Future<void> _getDeviceLocale() async {
    ui.window.onLocaleChanged = () {
      setState(() {
        _deviceLocale = ui.window.locale;
      });
    };
    setState(() {
      _deviceLocale = ui.window.locale;
    });
  }
  @override
  void initState() {
    super.initState();
    _getDeviceLocale();
    /// to get databases location for stored json
    // preCacheProcesses(context);

    openMyDatabase();
    // if (!kIsWeb) {
    //   preCacheProcesses(context);
    //   openMyDatabase();
    // }
    if (kIsWeb) {}
    // saveCacheLocal('ar');
    // insertIntoMyDatabase(
    //   tableName: databaseStoredJsonTableName,
    //   rawNameVal: 'config',
    //   jsonVal: 'tesbdkjbsct',
    // );
    // readJsonValFromMyDatabase(
    //         tableName: databaseStoredJsonTableName, rawNameVal: 'config')
    //     .then((value) => logg('read result for config is: $value'));
    /// to reset cache uncomment
    //   clearAllCache();
    logg('saved cache local: ${getCachedLocal().toString()}');
  }

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Listener(
      /// listener for un focus text form field on all application
      // onPointerDown: (pointerEvent) {
      //   FocusScopeNode currentFocus = FocusScope.of(context);
      //   if (!currentFocus.hasPrimaryFocus) {
      //     if(true) {
      //       currentFocus.focusedChild?.unfocus();
      //     }
      //   }
      // },
      child: ScreenUtilInit(
          designSize: const Size(360, 770),
          builder: (BuildContext context, Widget? child) {
            return child!;
          },
          child: BlocConsumer<MainCubit, MainState>(listener: (context, state) {
            // TODO: implement listener
          }, builder: (context, state) {
            return MaterialApp(
              title: 'MENA Platform',
              navigatorKey: navigatorKey,

              ///
              /// localization delegates
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              locale:  mainCubit.appLocale,
              supportedLocales: L10n.all,

              ///
              routes: {
                "/create_slot": (context) => PickAppointmentTypeInSlotLayout(),
              },

              ///
              debugShowCheckedModeBanner: false,

              theme: ThemeData.light(useMaterial3: false).copyWith(
                appBarTheme: Theme.of(context)
                    .appBarTheme
                    .copyWith(systemOverlayStyle: SystemUiOverlayStyle.light),
                // drawerTheme: DrawerThemeData(
                //   scrimColor: Colors.green,
                //   shadowColor: Colors.blue,
                //
                // ),
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black,
                  displayColor: Colors.blue,
                  fontSizeFactor: 1,
                  fontSizeDelta: 1,
                  fontFamily:

                  ///
                  /// getCachedLocale is arabic? Tajawal else english Visby
                  /// else another language add custom font family
                  ///
                  getCachedLocal() == 'en' ? 'Visby' : 'Tajawal',
                ),
                // useMaterial3: true,
                // This is the theme of your application.
                //xx
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                // primarySwatch: Colors.blue,
              ),
              // builder: (ctx, widget) {
              //   ScreenUtil.init(
              //     ctx,
              //     designSize: const Size(360, 770),
              //     splitScreenMode: true
              //     // width: 750, height: 1334, allowFontScaling: false
              //   );
              //   return widget!;
              // },
              // home: const MarketNavLayout(),
              home: const SplashScreen(),
              // home: const JobsLayout(),
            );
          })),
    );
    //   Listener(
    //   /// listener for un focus text form field on all application
    //   // onPointerDown: (pointerEvent) {
    //   //   FocusScopeNode currentFocus = FocusScope.of(context);
    //   //   if (!currentFocus.hasPrimaryFocus) {
    //   //     if(true) {
    //   //       currentFocus.focusedChild?.unfocus();
    //   //     }
    //   //   }
    //   // },
    //   child: ScreenUtilInit(
    //     designSize: const Size(360, 770),
    //     builder: (BuildContext context, Widget? child) {
    //       return child!;
    //     },
    //     child: MaterialApp(
    //       title: 'MENA Platform',
    //       navigatorKey: navigatorKey,
    //
    //
    //       ///
    //       /// localization delegates
    //       localizationsDelegates: const [
    //         AppLocalizations.delegate,
    //         GlobalMaterialLocalizations.delegate,
    //         GlobalWidgetsLocalizations.delegate,
    //         GlobalCupertinoLocalizations.delegate,
    //       ],
    //
    //       locale: _deviceLocale,
    //       supportedLocales: L10n.all,
    //       ///
    //       routes: {
    //         "/create_slot": (context) => PickAppointmentTypeInSlotLayout(),
    //       },
    //
    //       ///
    //       debugShowCheckedModeBanner: false,
    //
    //       theme: Theme.of(context).copyWith(
    //         appBarTheme: Theme.of(context)
    //             .appBarTheme
    //             .copyWith(systemOverlayStyle: SystemUiOverlayStyle.light),
    //         // drawerTheme: DrawerThemeData(
    //         //   scrimColor: Colors.green,
    //         //   shadowColor: Colors.blue,
    //         //
    //         // ),
    //         textTheme: Theme.of(context).textTheme.apply(
    //               bodyColor: Colors.black,
    //               displayColor: Colors.blue,
    //               fontSizeFactor: 1,
    //               fontSizeDelta: 1,
    //               fontFamily:
    //
    //                   ///
    //                   /// getCachedLocale is arabic? Tajawal else english Visby
    //                   /// else another language add custom font family
    //                   ///
    //                   getCachedLocal() == 'en' ? 'Visby' : 'Tajawal',
    //             ),
    //         // useMaterial3: true,
    //         // This is the theme of your application.
    //         //xx
    //         // Try running your application with "flutter run". You'll see the
    //         // application has a blue toolbar. Then, without quitting the app, try
    //         // changing the primarySwatch below to Colors.green and then invoke
    //         // "hot reload" (press "r" in the console where you ran "flutter run",
    //         // or simply save your changes to "hot reload" in a Flutter IDE).
    //         // Notice that the counter didn't reset back to zero; the application
    //         // is not restarted.
    //         // primarySwatch: Colors.blue,
    //       ),
    //       // builder: (ctx, widget) {
    //       //   ScreenUtil.init(
    //       //     ctx,
    //       //     designSize: const Size(360, 770),
    //       //     splitScreenMode: true
    //       //     // width: 750, height: 1334, allowFontScaling: false
    //       //   );
    //       //   return widget!;
    //       // },
    //       // home: const MarketNavLayout(),
    //       home: const SplashScreen(),
    //       // home: const JobsLayout(),
    //     ),
    //   ),
    // );


    // ScreenUtilInit(
    //   designSize: const Size(360, 770),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   useInheritedMediaQuery: true,
    //   builder: (context, child) {
    //     return Listener(
    //       /// listener for un focus text form field on all application
    //       // onPointerDown: (pointerEvent) {
    //       //   FocusScopeNode currentFocus = FocusScope.of(context);
    //       //   if (!currentFocus.hasPrimaryFocus) {
    //       //     if(true) {
    //       //       currentFocus.focusedChild?.unfocus();
    //       //     }
    //       //   }
    //       // },
    //
    //       child: MaterialApp(
    //         title: 'MENA Platform',
    //         ///
    //         /// localization delegates
    //         localizationsDelegates: const [
    //           AppLocalizations.delegate,
    //           GlobalMaterialLocalizations.delegate,
    //           GlobalWidgetsLocalizations.delegate,
    //           GlobalCupertinoLocalizations.delegate,
    //         ],
    //         locale: mainCubit.appLocale,
    //         supportedLocales: L10n.all,
    //         debugShowCheckedModeBanner: false,
    //         theme: Theme.of(context).copyWith(
    //           appBarTheme: Theme.of(context)
    //               .appBarTheme
    //               .copyWith(brightness: Brightness.dark),
    //           textTheme: Theme.of(context).textTheme.apply(
    //                 bodyColor: Colors.black,
    //                 displayColor: Colors.blue,
    //                 fontSizeFactor: 1,
    //                 fontSizeDelta: 1,
    //                 fontFamily:
    //                     /// getCachedLocale is arabic? Tajawasal else english Visby
    //                     /// else another language add custom font family
    //                     ///
    //                     getCachedLocal() == 'en' ? 'Visby' : 'Tajawal',
    //               ),
    //           // useMaterial3: true,
    //           // This is the theme of your application.
    //           //
    //           // Try running your application with "flutter run". You'll see the
    //           // application has a blue toolbar. Then, without quitting the app, try
    //           // changing the primarySwatch below to Colors.green and then invoke
    //           // "hot reload" (press "r" in the console where you ran "flutter run",
    //           // or simply save your changes to "hot reload" in a Flutter IDE).
    //           // Notice that the counter didn't reset back to zero; the application
    //           // is not restarted.
    //           // primarySwatch: Colors.blue,
    //         ),
    //         builder: (context, widget) {
    //           ScreenUtil.init(context,
    //               designSize: const Size(360, 770),
    //               // width: 750, height: 1334, allowFontScaling: false
    //           );
    //           return widget!;
    //         },
    //         home: const SplashScreen(),
    //         // home: const MainLayout(),
    //       ),
    //     );
    //   });
  }
}

Future<void> preCacheProcesses(BuildContext context) async {
  precacheImage(const AssetImage("assets/images/main background.png"), context);

  /// svg cache
  Future.wait([
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderOutsideViewBoxBuilder, // See UPDATE below!
        'assets/svg/icons/home.svg',
      ),
      null,
    ),

    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderOutsideViewBoxBuilder, // See UPDATE below!
        'assets/svg/icons/promotion.svg',
      ),
      null,
    ),

    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderOutsideViewBoxBuilder, // See UPDATE below!
        'assets/svg/icons/live.svg',
      ),
      null,
    ),

    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderOutsideViewBoxBuilder, // See UPDATE below!
        'assets/svg/icons/community.svg',
      ),
      null,
    ),

    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderOutsideViewBoxBuilder, // See UPDATE below!
        'assets/svg/icons/feeds.svg',
      ),
      null,
    ),

    // other SVGs or images here
  ]);
}

class TestMaterialApp extends StatelessWidget {
  const TestMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MENA Platform',

      ///
      ///
      ///
      /// localization delegates
      ///
      ///
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.blue,
              fontSizeFactor: 1.1,
              fontSizeDelta: 2.0,
              fontFamily:

                  /// getCachedLocale is arabic? Tajawal else english Visby
                  /// else another language add custom font family
                  ///
                  getCachedLocal() == null
                      ? 'Roboto'
                      : getCachedLocal() == 'en'
                          ? 'Roboto'
                          : 'Tajawal',
            ),
        // useMaterial3: true,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: Text('test')),
      // home: const MainLayout(),
    );
  }
}
