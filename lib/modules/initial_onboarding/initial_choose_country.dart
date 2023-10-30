import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/my_countries.dart';
import 'package:mena/modules/splash_screen/route_engine.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/main_cubit/main_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/shared_widgets/shared_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var localizationStrings = AppLocalizations.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child: const DefaultOnlyLogoAppbar(
            withBack: true,
            // title: 'Back',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child: BlocConsumer<MainCubit, MainState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                logg('rebuild lang');
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Lottie.asset('assets/json/world.json',
                                  height: 75.sp),
                              heightBox(12.h),
                              Text(
                                'Select your country',
                                style: mainStyle(context, 14,
                                    weight: FontWeight.w700),
                              ),
                              heightBox(12.h),
                              Text(
                                'Select your current country,\nand you can update it later from within the app.',
                                textAlign: TextAlign.center,
                                style: mainStyle(context, 13,
                                    color: newDarkGreyColor,
                                    weight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        SearchBarWidget(
                          onFieldChanged: (val) {
                            mainCubit.updateCountrySearchQuery(val);
                          },
                        )
                      ],
                    ),
                    heightBox(35.h),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            logg('list countries builder');
                            return GestureDetector(
                              onTap: () {
                                mainCubit.updateSelectedCountry(mainCubit
                                    .mayyaCountries[index].alpha3Code
                                    .toString());
                              },
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: defaultHorizontalPadding / 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              mainCubit.mayyaCountries[index]
                                                  .flagUri,
                                              width: 25.w,
                                              fit: BoxFit.contain,
                                            ),
                                            widthBox(15.w),
                                            Expanded(
                                              child: Text(
                                                // MayyaCountries.countryList[index]['nameTranslations']
                                                // [mainCubit.appLocale!.languageCode],
                                                mainCubit.mayyaCountries[index]
                                                                .nameTranslations![
                                                            mainCubit.appLocale!
                                                                .languageCode] ==
                                                        null
                                                    ? mainCubit
                                                            .mayyaCountries[index]
                                                            .nameTranslations![
                                                        'en']!
                                                    : mainCubit
                                                            .mayyaCountries[index]
                                                            .nameTranslations![
                                                        mainCubit.appLocale!
                                                            .languageCode]!,
                                                style: mainStyle(context, 12,
                                                    weight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: CircleAvatar(
                                          radius: 8.sp,
                                          backgroundColor: mainCubit
                                                      .mayyaCountries[index]
                                                      .alpha3Code
                                                      .toString() ==
                                                  mainCubit
                                                      .selectedCountryAlpha3Code
                                              ? mainBlueColor
                                              : softGreyColor,
                                          child: CircleAvatar(
                                            radius: defaultRadiusVal,
                                            backgroundColor: mainCubit
                                                        .mayyaCountries[index]
                                                        .alpha3Code
                                                        .toString() ==
                                                    mainCubit
                                                        .selectedCountryAlpha3Code
                                                ? mainBlueColor
                                                : Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 20.h,
                            color: mainBlueColor,
                          ),
                          // itemCount: MayyaCountries.countryList.length,
                          itemCount: mainCubit.mayyaCountries.length,
                        ),
                      ),
                    ),
                    heightBox(35.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultHorizontalPadding * 4),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Image.asset(
                                              MayyaCountryProvider
                                                      .getCountriesData(
                                                          countries: [])
                                                  .firstWhere((element) =>
                                                      element.alpha3Code ==
                                                      mainCubit
                                                          .selectedCountryAlpha3Code)
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
                                                MayyaCountryProvider
                                                            .getCountriesData(
                                                                countries: [])
                                                        .firstWhere((element) =>
                                                            element
                                                                .alpha3Code ==
                                                            mainCubit
                                                                .selectedCountryAlpha3Code)
                                                        .nameTranslations![
                                                    mainCubit.appLocale!
                                                        .languageCode]!,
                                                style: mainStyle(context, 12,
                                                    weight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            heightBox(10.h),
                            DefaultButton(
                                // height: 50.h,
                                text: localizationStrings!.save,
                                onClick: () {
                                  log("==== click ");
                                  if (mainCubit.selectedCountryAlpha3Code ==
                                      '') {
                                    logg('please select a country');
                                    showMyAlertDialog(
                                        context, 'Select your country',
                                        alertDialogContent: Text(
                                          'Kindly pick a country from the list',
                                          style: mainStyle(context, 14,
                                              color: newDarkGreyColor,
                                              weight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ));
                                  } else {
                                    saveCachedFirstApplicationRun(false);
                                    saveCachedSelectedCountry(
                                        mainCubit.selectedCountryAlpha3Code);
                                    navigateToAndFinishUntil(
                                        context, const RouteEngine());
                                  }
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
