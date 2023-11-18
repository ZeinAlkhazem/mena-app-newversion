import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/Colors.dart';
import '../../../../../core/constants/app_toasts.dart';
import '../../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../../modules/home_screen/cubit/home_screen_cubit.dart';
import '../cubit/healthcare_cubit.dart';
import '../widgets/health_care_category.dart';
import '../widgets/health_care_controll_appbar.dart';
import '../widgets/health_care_search_controll.dart';
import '../widgets/health_care_sub_category.dart';

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
          HomeScreenCubit.get(context).selectedHomePlatformId.toString()
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 120.h),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,

            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          automaticallyImplyLeading: false, // hides default back button
          flexibleSpace: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.softBlue,
                    AppColors.hardBlue,
                  ]),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HealthCareControllAppbar(),
                  HealthCareSearchControll(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Divider(),
                      ),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.healthcareCategories.length,
                      itemBuilder: (context, index) => HealthCareCategoryWidget(
                        healthCareCategory: state.healthcareCategories[index],
                        onTap: () async {
                          context.read<HealthcareCubit>().filterSubCategory(
                              state.healthcareCategories[index]);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.healthcareCategory.childs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: HealthCareSubCategory(
                            healthcareSubCategory:
                                state.healthcareCategory.childs[index]),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: DefaultLoaderGrey(),
              );
            }
          },
        ),
      ),
    );
  }
}
