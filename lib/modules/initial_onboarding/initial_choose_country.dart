import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/my_countries.dart';
import 'package:mena/modules/splash_screen/route_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/main_cubit/main_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/shared_widgets/shared_widgets.dart';

// import '../../core/shared_widgets/shared_widgets.dart';

class InitialChooseCountry extends StatefulWidget {
  const InitialChooseCountry({Key? key}) : super(key: key);

  @override
  State<InitialChooseCountry> createState() => _InitialChooseCountryState();
}

class _InitialChooseCountryState extends State<InitialChooseCountry> {
  @override
  void initState() {
    // TODO: implement initState
    MainCubit.get(context).updateCountrySearchQuery('');
    MainCubit.get(context).updateSelectedCountry('');
    super.initState();
  }
  void showToast(String selectedOption) {
    Fluttertoast.showToast(
      msg: '$selectedOption is Selected',
      toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should appear
      gravity: ToastGravity.BOTTOM, // Position of the toast message
      backgroundColor: Color(0xff0A0E10).withOpacity(0.4), // Background color of the toast
      textColor: Colors.white, // Text color of the toast message
      fontSize: 16.0, // Font size of the toast message
    );
  }
  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);
    String? selectedOption;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: Container(
            color: Color(0xff0A0E10).withOpacity(0.4),
            child: DefaultOnlyLogoAppbar(
              withBack: true,
              title: getTranslatedStrings(context).countryTitle,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.bottomCenter,
          color: Color(0xff0A0E10).withOpacity(0.4),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: BlocConsumer<MainCubit, MainState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  logg('rebuild lang');
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
                          hintText: getTranslatedStrings(context).countrySearch,
                          onFieldChanged: (val) {
                            mainCubit.updateCountrySearchQuery(val);
                          },
                        ),
                        heightBox(5.h),
                        Expanded(
                          flex: 4,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              logg('list countries builder');
                              return GestureDetector(
                                onTap: () {
                                  mainCubit.updateSelectedCountry(mainCubit.mayyaCountries[index].alpha3Code.toString());
                                  if (mainCubit.selectedCountryAlpha3Code == '') {
                                    logg('please select a country');
                                    showMyAlertDialog(context, 'Select your country',
                                        alertDialogContent: Text(
                                          'Kindly pick a country from the list',
                                          style:
                                          mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ));
                                  } else {
                                    saveCachedFirstApplicationRun(false);
                                    saveCachedSelectedCountry(mainCubit.selectedCountryAlpha3Code);
                                    navigateToAndFinishUntil(context, const RouteEngine());
                                  }
                                  selectedOption = mainCubit.mayyaCountries[index]
                                      .nameTranslations![mainCubit.appLocale!.languageCode];
                                  showToast(selectedOption!);
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: mainCubit.mayyaCountries[index].name.toString(),
                                                groupValue: selectedOption,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedOption = value as String?;
                                                  });
                                                },
                                              ),
                                              widthBox(5.w),
                                              Expanded(
                                                child: Text(
                                                  // MayyaCountries.countryList[index]['nameTranslations']
                                                  // [mainCubit.appLocale!.languageCode],
                                                  mainCubit.mayyaCountries[index]
                                                      .nameTranslations![mainCubit.appLocale!.languageCode] ==
                                                      null
                                                      ? mainCubit.mayyaCountries[index].nameTranslations!['en']!
                                                      : mainCubit.mayyaCountries[index]
                                                      .nameTranslations![mainCubit.appLocale!.languageCode]!,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Inter',
                                                    color: Color(0xff191919),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              height: 0.01,
                              color: Colors.transparent,
                            ),
                            // itemCount: MayyaCountries.countryList.length,
                            itemCount: mainCubit.mayyaCountries.length,
                          ),
                        ),
                        heightBox(35.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 4),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                mainCubit.selectedCountryAlpha3Code == ''
                                    ? const SizedBox()
                                    : SizedBox(
                                  height: 40.h,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Image.asset(
                                            MayyaCountryProvider.getCountriesData(countries: [])
                                                .firstWhere((element) =>
                                            element.alpha3Code == mainCubit.selectedCountryAlpha3Code)
                                                .flagUri,
                                            width: 25.w,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          child: SizedBox(
                                            width: 0.4.sw,
                                            child: Text(
                                              // MayyaCountries.countryList[index]['nameTranslations']
                                              // [mainCubit.appLocale!.languageCode],
                                              MayyaCountryProvider.getCountriesData(countries: [])
                                                  .firstWhere((element) =>
                                              element.alpha3Code == mainCubit.selectedCountryAlpha3Code)
                                                  .nameTranslations![mainCubit.appLocale!.languageCode]!,
                                              style: mainStyle(context, 12, weight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));

  }
  Future<void> _updateCountrye(String selectedLanguage, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
    // Store language code or perform any other necessary operations
  }
}

// class RadioGroup1 extends StatefulWidget {
//   @override
//   _RadioGroup1State createState() => _RadioGroup1State();
// }
//
// class _RadioGroup1State extends State<RadioGroup1> {
//   String? selectedOption;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: languages.map((LanguageData language) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedOption = language.name;
//
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
//                     Navigator.pop(context, [language]);
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