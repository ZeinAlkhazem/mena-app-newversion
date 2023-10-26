import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultOnlyLogoAppbar(
            // title: 'Back',
            ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: SafeArea(
          child: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset('assets/json/pick-language.json',
                            height: 75.sp),
                        heightBox(12.h),
                        Text(
                          'Select Application Language',
                          style:
                              mainStyle(context, 14, weight: FontWeight.w700),
                        ),
                        heightBox(12.h),
                        Text(
                          'Select app language now,\nchange later if needed from within."',
                          textAlign: TextAlign.center,
                          style: mainStyle(context, 13,
                              color: newDarkGreyColor, weight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  heightBox(35.h),
                  Expanded(
                    flex: 4,
                    child: mainCubit.configModel == null
                        ? DefaultLoaderGrey()
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultHorizontalPadding * 3),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              logg(
                                  'selectedLocalesInDashboard : ${mainCubit.selectedLocalesInDashboard}');
                              return GestureDetector(
                                onTap: () {
                                  logg('setting locale');
                                  mainCubit.setLocale(
                                      mainCubit
                                          .selectedLocalesInDashboard[index],
                                      context,
                                      false);
                                },
                                child: DefaultContainer(
                                  height: 35.h,
                                  radius: 5.sp,
                                  borderColor: L10n.all[index].languageCode ==
                                          mainCubit.appLocale!.languageCode
                                      ? mainBlueColor
                                      : softGreyColor.withOpacity(0.5),
                                  childWidget: Center(
                                    child: Text(
                                      mainCubit
                                                  .selectedLocalesInDashboard[
                                                      index]
                                                  .languageCode ==
                                              'ar'
                                          ? 'العربية'
                                          : mainCubit
                                                      .selectedLocalesInDashboard[
                                                          index]
                                                      .languageCode ==
                                                  'en'
                                              ? 'English'
                                              : mainCubit
                                                          .selectedLocalesInDashboard[
                                                              index]
                                                          .languageCode ==
                                                      'hi'
                                                  ? 'हिन्दी'
                                                  : mainCubit
                                                              .selectedLocalesInDashboard[
                                                                  index]
                                                              .languageCode ==
                                                          'fil'
                                                      ? 'Filipino'
                                                      : mainCubit
                                                                  .selectedLocalesInDashboard[
                                                                      index]
                                                                  .languageCode ==
                                                              'ru'
                                                          ? 'русский'
                                                          : mainCubit
                                                                      .selectedLocalesInDashboard[
                                                                          index]
                                                                      .languageCode ==
                                                                  'zh'
                                                              ? '中國人'
                                                              : mainCubit
                                                                          .selectedLocalesInDashboard[
                                                                              index]
                                                                          .languageCode ==
                                                                      'tr'
                                                                  ? 'Türkçe'
                                                                  : mainCubit.selectedLocalesInDashboard[index].languageCode ==
                                                                          'es'
                                                                      ? 'española'
                                                                      : mainCubit.selectedLocalesInDashboard[index].languageCode ==
                                                                              'fr'
                                                                          ? 'Français'
                                                                          : 'ْunknown lang',
                                      style: mainStyle(context, 13,
                                          weight: FontWeight.w400,
                                          fontFamily: mainCubit
                                                      .selectedLocalesInDashboard[
                                                          index]
                                                      .languageCode ==
                                                  'ar'
                                              ? 'Tajawal'
                                              : null),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 20.h,
                            ),
                            itemCount:
                                mainCubit.selectedLocalesInDashboard.length,
                          ),
                  ),
                  heightBox(35.h),
                  SizedBox(
                    child: Center(
                      child: DefaultButton(
                          text: localizationStrings!.next,
                          onClick: () {
                            log("# click next #");
                            navigateTo(context, const InitialChooseCountry());
                          }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
