import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/live_categories.dart';
import 'package:mena/modules/create_live/create_live_screen.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/live_screens/live_screen.dart';
import 'package:mena/modules/live_screens/start_live_form.dart';
import '../../core/constants/validators.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/local_models.dart';

class LiveMainLayout extends StatelessWidget {
  const LiveMainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    liveCubit.changeCurrentView(true);
    liveCubit.getLivesNowAndUpcomingCategories(filter: 'live');
    LiveCategories? categories = liveCubit.nowLiveCategoriesModel;
   
    logg('changing layouts : ${categories?.liveCategories}');
    return Padding(
      padding: EdgeInsets.only(bottom: rainBowBarBottomPadding(context)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: MainBackground(
          bodyWidget: BlocConsumer<LiveCubit, LiveState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: rainBowBarHeight),
                ///rainbow padding for scroll
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                       
                        heightBox(7.h),
                        Expanded(
                            child: const LiveNowView())
                      ],
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LiveNowView extends StatefulWidget {
  const LiveNowView({Key? key}) : super(key: key);

  @override
  State<LiveNowView> createState() => _LiveNowViewState();
}

class _LiveNowViewState extends State<LiveNowView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LiveCubit.get(context).getLivesNowAndUpcoming(filter:'live',categoryId:'');
    if (LiveCubit.get(context).selectedNowLiveCat != null) {
      LiveCubit.get(context).getLivesNowAndUpcoming(
          filter: 'live',
          categoryId: LiveCubit.get(context).selectedNowLiveCat!);
    } else {
      LiveCubit.get(context)
          .getLivesNowAndUpcoming(filter: 'live', categoryId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var liveCubit = LiveCubit.get(context)
      ..getLivesNowAndUpcomingCategories(filter: 'live');
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // heightBox(7.h),
                  (liveCubit.nowLiveCategoriesModel == null ||
                          state is GettingLiveCategories ||
                          liveCubit.nowLivesModel == null)
                      ? DefaultLoaderColor()
                      : LivesList(
                          categories:
                              liveCubit.nowLiveCategoriesModel!.liveCategories,
                          livesByCategoryItems: liveCubit.nowLivesModel!.data
                              .livesByCategory.livesByCategoryItem,
                          isNow: true,
                        ),
                ],
              ),
            ),
            if (getCachedToken() != null)
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      // navigateToWithoutNavBar(context, StartLiveFormLayout(), 'routeName');
                      navigateToWithoutNavBar(
                          context, CreateLivePage(), 'routeName');
                      logg('go live');
                    },
                    child: DefaultContainer(
                      radius: 35.sp,
                      backColor: mainBlueColor,
                      childWidget: Container(),
                    ),
                  ))

          ],
        );
      },
    );
  }
}

class UpcomingLiveView extends StatefulWidget {
  const UpcomingLiveView({Key? key}) : super(key: key);

  @override
  State<UpcomingLiveView> createState() => _UpcomingLiveViewState();
}

class _UpcomingLiveViewState extends State<UpcomingLiveView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (LiveCubit.get(context).selectedUpcomingLiveCat != null) {
      LiveCubit.get(context).getLivesNowAndUpcoming(
          filter: 'upcoming',
          categoryId: LiveCubit.get(context).selectedUpcomingLiveCat!);
    } else {
      LiveCubit.get(context)
          .getLivesNowAndUpcoming(filter: 'upcoming', categoryId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context)
      ..getLivesNowAndUpcomingCategories(filter: 'upcoming');
    return BlocConsumer<LiveCubit, LiveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (liveCubit.upcomingLiveCategoriesModel == null ||
                state is GettingLiveCategories ||
                liveCubit.upcomingLivesModel == null)
            ? DefaultLoaderColor()
            : LivesList(
                isNow: false,
                categories:
                    liveCubit.upcomingLiveCategoriesModel!.liveCategories,
                livesByCategoryItems: liveCubit.upcomingLivesModel!.data
                    .livesByCategory.livesByCategoryItem,
              );
      },
    );
  }
}
