import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/plans_model.dart';

import '../../core/functions/main_funcs.dart';

class PlansLayout extends StatelessWidget {
  const PlansLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context)..getPlans();

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              children: [
                // heightBox(27.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          widthBox(15.w),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: mainBlueColor,
                                size: 26,
                              )),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/svg/mena8.svg',
                      height: 30.h,
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                heightBox(30.h),
                Text('Our plans',
                    style: mainStyle(context,32,
                        weight: FontWeight.normal,
                        letterSpacing: 0,
                        textHeight: 2)),
                heightBox(12.h),
                Text(
                  'Choice Providers Subscription Plan',
                  textAlign: TextAlign.center,
                  style: mainStyle(context,12),
                ),
                heightBox(20.h),
                Expanded(
                    child: Center(
                        child: mainCubit.plansModel == null
                            ? const DefaultLoaderGrey()
                            : const PlansBody())),
                heightBox(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Column(
                    children: [
                      DefaultButton(text: 'Continue', onClick: () {}),
                      heightBox(20.h),
                      Text(
                        getTranslatedStrings(context).copyRight,
                        style: mainStyle(context,9, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PlansBody extends StatelessWidget {
  const PlansBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return
      mainCubit.plansModel!.data.length>0?

      ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return PlanItem(item: mainCubit.plansModel!.data[index]);
      },
      separatorBuilder: (ctx, index) => widthBox(10.w),
      itemCount: mainCubit.plansModel!.data.length,
    ):Center(child: Text(
        'No plan for ${mainCubit.userInfoModel!.data.user.platform!.name} platform'
      ),);
  }
}

class PlanItem extends StatelessWidget {
  const PlanItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final PlanItemModel item;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){

              mainCubit.changeSelectedPlanItemId(item.id.toString());
            },
            child: DefaultShadowedContainer(
                borderColor:
                    item.id.toString() == mainCubit.selectedPlanId.toString()
                        ? mainBlueColor
                        : null,
                width: 0.58.sw,
                childWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      heightBox(10.h),
                      Text(item.name),
                      heightBox(12.h),
                      Text(
                        '${item.monthlyFee} / monthly',
                        style: mainStyle(context,13,
                            color: mainBlueColor, weight: FontWeight.w700),
                      ),
                      heightBox(7.h),
                      Text(
                        '${item.yearlyFee} / yearly',
                        style: mainStyle(context,13,
                            color: mainBlueColor, weight: FontWeight.w700),
                      ),
                      heightBox(15.h),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) => Row(
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                color: Colors.green,
                              ),
                              widthBox(5.w),
                              Text(
                                item.features[index].name,
                                style: mainStyle(context,14),
                              )
                            ],
                          ),
                          separatorBuilder: (ctx, index) => heightBox(10.h),
                          itemCount: item.features.length,
                        ),
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
