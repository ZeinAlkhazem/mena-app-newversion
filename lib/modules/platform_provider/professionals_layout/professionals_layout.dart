import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/platform_provider/cubit/provider_cubit.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/local_models.dart';
import '../../home_screen/sections_widgets/sections_widgets.dart';

class ProviderProfessionalLayout extends StatefulWidget {
  const ProviderProfessionalLayout({Key? key, required this.providerId}) : super(key: key);

  final String providerId;

  @override
  State<ProviderProfessionalLayout> createState() => _ProviderProfessionalLayoutState();
}

class _ProviderProfessionalLayoutState extends State<ProviderProfessionalLayout> {
  @override
  void initState() {
    // TODO: implement initState
    ProviderCubit.get(context).resetProfessionalModel();
    ProviderCubit.get(context).getProfessionals(providerId: widget.providerId);
    ProviderCubit.get(context).updateSelectedSpeciality('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var providerCubit = ProviderCubit.get(context);

    return Scaffold(
        appBar: defaultSearchMessengerAppBar(context),

        /// bloc consumer
        /// check for filter category
        /// and check providers then to providers section
        body: SafeArea(
          child: BlocConsumer<ProviderCubit, ProviderState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return providerCubit.professionalsModel == null
                  ? DefaultLoaderGrey()
                  : Column(
                      children: [
                        // heightBox(5.h),
                        // if(providerCubit.professionalsModel!.data.specialities!=null)
                        providerCubit.professionalsModel!.data.specialities.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: HorizontalSelectorScrollable(
                                  buttons: providerCubit.professionalsModel!.data.specialities
                                      .map((e) => SelectorButtonModel(
                                          title: e.name!,
                                          onClickCallback: () {
                                            providerCubit
                                                .updateSelectedSpeciality(e.id.toString());
                                            providerCubit.getProfessionals(
                                                providerId: widget.providerId,
                                                specialityId: providerCubit.selectedSpeciality);
                                          },
                                          isSelected: providerCubit.selectedSpeciality ==
                                              e.id.toString()))
                                      .toList(),
                                ),
                              ),
                        Expanded(
                          child: state is LoadingProviderProfessionals
                              ? DefaultLoaderGrey()
                              : providerCubit.professionalsModel!.data.professionals.isEmpty
                                  ? EmptyListLayout()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: defaultHorizontalPadding),
                                      child: ProvidersSection(
                                        providers:
                                            providerCubit.professionalsModel!.data.professionals,
                                        title: '',
                                        justView: true,
                                      ),
                                    ),
                        ),
                      ],
                    );
            },
          ),
        ));
  }
}
