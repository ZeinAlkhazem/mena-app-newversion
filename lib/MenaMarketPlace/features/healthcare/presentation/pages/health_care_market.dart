import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';

import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/app_toasts.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/home_screen/cubit/home_screen_cubit.dart';
import 'package:mena/MenaMarketPlace/features/market/presentation/widgets/search_box.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/cubit/healthcare_cubit.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/health_care_category.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/health_care_controll_appbar.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/widgets/health_care_sub_category.dart';

class HealthCareMarket extends StatefulWidget {
  const HealthCareMarket({super.key});

  @override
  State<HealthCareMarket> createState() => _HealthCareMarketState();
}

class _HealthCareMarketState extends State<HealthCareMarket> {
  @override
  void initState() {
    context.read<HealthcareCubit>().getHealthcareCategories({
      'platform_id':
          HomeScreenCubit.get(context).selectedHomePlatformId.toString(),
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80.h),
          child: AppBar(
            backgroundColor: Colors.transparent,
            // systemOverlayStyle: const SystemUiOverlayStyle(
            //   // Status bar color
            //   statusBarColor: Colors.transparent,
            //   statusBarIconBrightness: Brightness.dark,
            //   statusBarBrightness: Brightness.dark, // For iOS (dark icons)
            // ),
            automaticallyImplyLeading: false,
            title:
                const HealthCareControllAppbar(), // hides default back button
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15.r)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.softBlue,
                        AppColors.hardBlue,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -25.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: const SearchBox(hint: 'Search Products & Suppliers'),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 40.h, left: 8, right: 8),
          child: BlocConsumer<HealthcareCubit, HealthcareState>(
            listener: (context, state) {
              if (state is HealthcareErrorState) {
                AppToasts.errorToast(state.errorMsg);
              }
            },
            builder: (context, state) {
              if (state is HealthcareLoadedState) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF6F6F6),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xFFEDEDED)),
                          ),
                        ),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.healthcareCategories.length,
                          itemBuilder: (context, index) =>
                              HealthCareCategoryWidget(
                            isSelected: state.healthcareCategories[index] ==
                                    state.healthcareCategory
                                ? true
                                : false,
                            healthCareCategory:
                                state.healthcareCategories[index],
                            onTap: () async {
                              context.read<HealthcareCubit>().filterSubCategory(
                                    state.healthcareCategories[index],
                                  );
                            },
                          ),
                        ),
                      ),
                    ),
                    widthBox(8.w),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 0.2),
                                ),
                              ],
                            ),
                            child: Image.asset('assets/menamarket/image 3.png'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.healthcareCategory.childs.length,
                              itemBuilder: (context, index) =>
                                  HealthCareSubCategory(
                                healthcareSubCategory:
                                    state.healthcareCategory.childs[index],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: DefaultLoaderGrey(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
