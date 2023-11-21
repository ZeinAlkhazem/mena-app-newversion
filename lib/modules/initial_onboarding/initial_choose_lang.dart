// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mena/core/functions/main_funcs.dart';
// import 'package:mena/core/main_cubit/main_cubit.dart';
// import 'package:mena/core/shared_widgets/shared_widgets.dart';
// import 'package:mena/l10n/l10n.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../core/constants/constants.dart';
// import 'initial_choose_country.dart';
//
// ///
// /// ghadeer mayya
// ///
// /// get languages and countries from config
// /// Select language and country and set location permission and send to db
// /// change first run cached value
//
// class InitialChooseLang extends StatelessWidget {
//   const InitialChooseLang({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mainCubit = MainCubit.get(context);
//     var localizationStrings = AppLocalizations.of(context);
//
//     // Get the device's locale
//     Locale deviceLocale = WidgetsBinding.instance!.window.locale;
//
//     // Set the app's locale to the device's locale
//     if (mainCubit.appLocale == null) {
//       mainCubit.setLocale(deviceLocale, context, false);
//     }
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(56.0.h),
//         child: Container(
//           color: Color(0xff0A0E10).withOpacity(0.4),
//           child: const DefaultOnlyLogoAppbar(
//             withBack: true,
//             title: 'Select Languages',
//           ),
//         ),
//       ),
//       body: Container(
//           alignment: Alignment.bottomCenter,
//         color: Color(0xff0A0E10).withOpacity(0.4),
//           child: Container(
//               height: 350.h,
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       left: 20, right: 20, top: 5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r),
//                     topRight: Radius.circular(25.r)),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         width: 41,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: Color(0xff979797),
//                         ),
//                       ),
//                       heightBox(15.h),
//                       SearchBar1(
//                         hintText: 'Search for Languages',
//                         onFieldChanged: (val) {
//                           // mainCubit.updateLanguageSearchQuery(val);
//                         },
//                       ),
//                       heightBox(5.h),
//                        RadioGroup1(),
//                         // Row(
//                         //   // mainAxisAlignment: MainAxisAlignment.start,
//                         //   crossAxisAlignment: CrossAxisAlignment.start,
//                         //   children: [
//                         //     Text("English (US)",
//                         //       style: TextStyle(
//                         //           fontSize: 16.0,
//                         //           fontWeight: FontWeight.w600,
//                         //           fontFamily: 'PNfont',
//                         //           color: Color(0xff303840)),),
//                         //     widthBox(0.45.sw),
//                         //     Icon(Icons.circle_outlined, size: 18,)
//                         //   ],
//                         // ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ),
//     );
//   }
//   String _getLanguageName(String languageCode) {
//     switch (languageCode) {
//       case 'ar':
//         return 'العربية';
//       case 'en':
//         return 'English';
//       case 'hi':
//         return 'हिन्दी';
//       case 'fil':
//         return 'Filipino';
//       case 'ru':
//         return 'русский';
//       case 'zh':
//         return '中國人';
//       case 'tr':
//         return 'Türkçe';
//       case 'es':
//         return 'española';
//       case 'fr':
//         return 'Français';
//       default:
//         return languageCode;
//     }
//   }
// }
// // class RadioGroup1 extends StatefulWidget {
// //   @override
// //   _RadioGroup1State createState() => _RadioGroup1State();
// //
// // }
// //
// // class _RadioGroup1State extends State<RadioGroup1> {
// //   String? selectedOption;
// //   List<LanguageData> languages = [
// //     LanguageData('English', 'en'),
// //     LanguageData('العربية', 'ar'),
// //     LanguageData('हिन्दी', 'hi'),
// //     LanguageData('Filipino', 'fil'),
// //     LanguageData('русский', 'ru'),
// //     LanguageData('中國人', 'zh'),
// //     LanguageData('Türkçe', 'tr'),
// //     LanguageData('española', 'es'),
// //     LanguageData('Français', 'fr'),
// //   ];
// //   List<LanguageData> filteredLanguages = [];
// //
// //   @override
// //   void initState() {
// //     filteredLanguages = List.from(languages);
// //     super.initState();
// //   }
// //
// //   void searchFilter(String val) {
// //     setState(() {
// //       if (val.isEmpty) {
// //         filteredLanguages = List.from(languages);
// //       } else {
// //         filteredLanguages = languages
// //             .where((language) => language.name.toLowerCase().contains(val.toLowerCase()))
// //             .toList();
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: TextField(
// //             onChanged: (value) {
// //               searchFilter(value);
// //             },
// //             decoration: InputDecoration(
// //               hintText: 'Search...',
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           child: ListView.builder(
// //             itemCount: filteredLanguages.length,
// //             itemBuilder: (BuildContext context, int index) {
// //               return GestureDetector(
// //                 onTap: () {
// //                   setState(() {
// //                     selectedOption = filteredLanguages[index].name;
// //                     _updateLanguage(selectedOption!, filteredLanguages[index].code);
// //                     // Add your navigation code here if needed
// //                   });
// //                 },
// //                 child: Row(
// //                   children: [
// //                     Radio(
// //                       value: filteredLanguages[index].name,
// //                       groupValue: selectedOption,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedOption = value as String?;
// //                           _updateLanguage(selectedOption!, filteredLanguages[index].code);
// //                           // Add your navigation code here if needed
// //                         });
// //                       },
// //                     ),
// //                     SizedBox(width: 10), // Adjust the spacing as needed
// //                     Text(
// //                       filteredLanguages[index].name,
// //                       style: TextStyle(
// //                         fontSize: 16.0,
// //                         fontWeight: FontWeight.w600,
// //                         fontFamily: 'Inter',
// //                         color: Color(0xff303840),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Future<void> _updateLanguage(String selectedLanguage, String langCode) async {
// //     // Your implementation for updating language preference
// //   }
// // }
// //
// // class LanguageData {
// //   final String name;
// //   final String code;
// //
// //   LanguageData(this.name, this.code);
// // }
//
//
// class RadioGroup1 extends StatefulWidget {
//   @override
//   _RadioGroup1State createState() => _RadioGroup1State();
// }
//
// class _RadioGroup1State extends State<RadioGroup1> {
//   String? selectedOption;
//   List<LanguageData> languages = [
//     LanguageData('English', 'en'),
//     LanguageData('العربية', 'ar'),
//     LanguageData('हिन्दी', 'hi'),
//     LanguageData('русский', 'ru'),
//     LanguageData('中國人', 'zh'),
//     LanguageData('Türkçe', 'tr'),
//     LanguageData('española', 'es'),
//     LanguageData('Français', 'fr'),
//   ];
//   // List<LanguageData> results = [];
//   // @override
//   // initState(){
//   //   results = languages.cast<LanguageData>();
//   //   super.initState();
//   // }
//   // void searchfilter(String val){
//   //   List<LanguageData>? results1 = [];
//   //   if(val.isEmpty){
//   //     results1 = languages.cast<LanguageData>();
//   //   }else{
//   //     results1 = languages.cast<LanguageData>().where((user) => user["name"].toLowerCase().contains(val.toLowerCase().toList())).cast<Map<String, dynamic>>();
//   //   }
//   // }
//   // setState((){
//   //   results = results1;
//   // });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: languages.map((LanguageData language) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedOption = language.name;
//               _updateLanguage(selectedOption!, language.code);
//               navigateTo(context, const InitialChooseCountry());
//             });
//           },
//           child: Row(
//             children: [
//               Radio(
//                 value: language.name,
//                 groupValue: selectedOption,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedOption = value as String?;
//                     _updateLanguage(selectedOption!, language.code);
//                   });
//                 },
//               ),
//               widthBox(5.w),
//               Text(
//                 language.name,
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Inter',
//                   color: Color(0xff191919),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Future<void> _updateLanguage(String selectedLanguage, String langCode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguage', selectedLanguage);
//     // Store language code or perform any other necessary operations
//   }
// }
//
// class LanguageData {
//   final String name;
//   final String code;
//
//   LanguageData(this.name, this.code);
// }
//
// class RadioData {
//   final String name;
//   final String code;
//
//   RadioData(this.name, this.code);
// }
//


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import 'initial_choose_country.dart';

///
/// ghadeer mayya
///
/// get languages and countries from config
/// Select language and country and set location permission and send to db
/// change first run cached value

class InitialChooseLang extends StatelessWidget {
  const InitialChooseLang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    String? selectedOption;
    TextEditingController languageSearchController = TextEditingController();
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: Container(
          color: Color(0xff0A0E10).withOpacity(0.4),
          child: DefaultOnlyLogoAppbar(
            // withBack: true,
            title: getTranslatedStrings(context).languageTitle,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        color: Color(0xff0A0E10).withOpacity(0.4),
        padding: EdgeInsets.symmetric(horizontal: 1.w ),
        child: SafeArea(
          child: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                height: 350.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.r),
                    topLeft: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 41,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xff979797),
                      ),
                    ),
                    heightBox(15.h),
                    SearchBar1(
                      hintText: getTranslatedStrings(context).languageSearch,
                      onFieldChanged: (val) {
                        languageSearchController.text = val;
                        mainCubit.updateLanguageSearchQuery(val);
                      },
                    ),
                    heightBox(5.h),
                    Expanded(
                      flex: 4,
                      child:
                      mainCubit.configModel == null
                          ? DefaultLoaderGrey()
                          : BlocBuilder<MainCubit, MainState>(
                              builder: (context, state) {
                                // Filter languages based on the entered text
                                List<Locale> filteredLanguages = mainCubit
                                    .selectedLocalesInDashboard
                                    .where((language) =>
                                    getLanguageName(language)
                                        .toLowerCase()
                                        .contains(
                                        languageSearchController.text.toLowerCase()))
                                    .toList();

                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.w),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    logg(
                                        'selectedLocalesInDashboard : ${mainCubit
                                            .selectedLocalesInDashboard}');
                                    return GestureDetector(
                                      onTap: () {
                                        logg('setting locale');
                                        mainCubit.setLocale(filteredLanguages[index],
                                            context, false);
                                        navigateTo(context,
                                            const InitialChooseCountry());
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: mainCubit
                                                        .selectedLocalesInDashboard[index]
                                                        .languageCode,
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      selectedOption = value as String?;
                                                      _updateLanguage(selectedOption!, mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode);
                                                    },
                                                  ),
                                                  widthBox(5.w),
                                                  Expanded(
                                                    child: Text(
                                                      mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode == 'ar'
                                                          ? 'العربية'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode == 'en'
                                                          ? 'English'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode == 'hi'
                                                          ? 'हिन्दी'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode ==
                                                          'ru'
                                                          ? 'русский'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode ==
                                                          'zh'
                                                          ? '中國人'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode ==
                                                          'tr'
                                                          ? 'Türkçe'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode ==
                                                          'es'
                                                          ? 'española'
                                                          : mainCubit
                                                          .selectedLocalesInDashboard[index]
                                                          .languageCode ==
                                                          'fr'
                                                          ? 'Français'
                                                          : 'ْunknown lang',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        fontFamily: 'Inter',
                                                        color: Color(
                                                            0xff191919),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                  itemCount: mainCubit
                                      .selectedLocalesInDashboard.length,
                                );
                              },
                    ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'ru':
        return 'русский';
      case 'zh':
        return '中國人';
      case 'tr':
        return 'Türkçe';
      case 'es':
        return 'española';
      case 'fr':
        return 'Français';
      default:
        return 'Unknown';
    }
  }
  Future<void> _updateLanguage(String selectedLanguage, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
    // Store language code or perform any other necessary operations
  }
}


// navigateTo(context, const InitialChooseCountry());