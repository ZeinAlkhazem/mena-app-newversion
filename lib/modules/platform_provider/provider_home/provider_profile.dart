import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/platform_provider/cubit/provider_cubit.dart';
import 'package:mena/modules/platform_provider/provider_home/platform_provider_home.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/provider_details_model.dart';
import 'provider_profile_Sections.dart';

class ProviderProfileLayout extends StatefulWidget {
  const ProviderProfileLayout({Key? key, required this.providerId, required this.lastPageAppbarTitle})
      : super(key: key);
  final String providerId;

  final String lastPageAppbarTitle;

  @override
  State<ProviderProfileLayout> createState() => _ProviderProfileLayoutState();
}

class _ProviderProfileLayoutState extends State<ProviderProfileLayout> {
  ProviderDetailsModel? providerDetailed;

  @override
  void initState() {
    // TODO: implement initState
    ProviderCubit.get(context).getProviderDetails(widget.providerId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productDetailsCubit = ProviderCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultSearchMessengerAppBar(
        context,
        title: '${widget.lastPageAppbarTitle}',
      ),
      body: SafeArea(
        child: Container(
          color: newLightGreyColor,
          child: BlocConsumer<ProviderCubit, ProviderState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is SuccessProviderDetailsData) {
                providerDetailed = productDetailsCubit.providerDetailsModel!;
              }
            },
            builder: (context, state) {
              return state is LoadingProviderDetails
                  ? DefaultLoaderGrey()
                  : providerDetailed == null
                      ? Text('temp check')
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NewProviderCard(
                              provider: providerDetailed!.user,
                              currentLayout: 'provider',
                              justView: true,
                            ),
                            heightBox(10.h),
                            ProviderProfileMainActions(
                              provider: providerDetailed!.user,
                            ),
                            heightBox(10.h),
                            // Divider(color: mainBlueColor, thickness: 0.8),
                            ButtonsSection(
                                buttons: providerDetailed!.user.moreData!.buttons,
                                providerInfo :providerDetailed!.user,
                                providerId: providerDetailed!.user.id.toString()),
                            // heightBox(10.h),
                            // OurProfileSection(
                            //   expertise: providerDetailed!.user.expertise,
                            //   summary: providerDetailed!.user.summary,
                            // ),
                            // heightBox(10.h),
                            // ReviewsSection(
                            //   reviews: providerDetailed!.user.moreData!.reviews,
                            // ),
                            heightBox(10.h),

                            OurLocationSection(
                              provider: providerDetailed!.user,
                              providersLocations: providerDetailed!.user.moreData!.locations,
                              viewTitleInProfileLayout: true,
                              // providersLocations: productDetailsCubit
                              //     .providerDetailsModel!.user.locations,
                            ),           heightBox(10.h),
                            ContactUsSection(
                              provider: productDetailsCubit.providerDetailsModel!.user,
                            ),
                            heightBox(10.h),
                            FollowUsSection(
                              provider: productDetailsCubit.providerDetailsModel!.user,
                            ),
                            heightBox(10.h),
                            // AwardsSection(
                            //   rewards: productDetailsCubit
                            //       .providerDetailsModel!
                            //       .user
                            //       .moreData!
                            //       .awards,
                            // ),
                            // heightBox(22.h)
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

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
