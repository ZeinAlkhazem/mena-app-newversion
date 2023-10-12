import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/models/local_models.dart';
import 'package:mena/modules/platform_provider/cubit/provider_cubit.dart';
import 'package:mena/modules/platform_provider/supplier_profile/provider_home_bodies/departments_body.dart';
import 'package:mena/modules/platform_provider/supplier_profile/provider_home_bodies/profile_body.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../provider_home/platform_provider_home.dart';

class ProviderSupplierProfile extends StatefulWidget {
  const ProviderSupplierProfile({Key? key, required this.provider}) : super(key: key);

  final User provider;
  @override
  State<ProviderSupplierProfile> createState() =>
      _ProviderSupplierProfileState();
}

class _ProviderSupplierProfileState extends State<ProviderSupplierProfile> {
  late ScrollController _scrollController;

  @override
  void initState() {
    logg('init QTest');
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients && _scrollController.offset > (100)) {
          ProviderCubit.get(context).changeIsExpanded(false);
        } else {
          ProviderCubit.get(context).changeIsExpanded(true);
        }
        // setState(() {
        //
        // });
        // _isSliverAppBarExpanded()
        // setState(() {
        //   // _textColor = _isSliverAppBarExpanded ? Colors.white : Colors.blue;
        // });
      });
  }

//----------
//   bool get _isSliverAppBarExpanded {
//     return _scrollController.hasClients &&
//         _scrollController.offset > (200);
//   }

  @override
  Widget build(BuildContext context) {
    var providerCubit = ProviderCubit.get(context)..initialBody();

    GlobalKey customKey = GlobalKey();
    return Scaffold(
      backgroundColor: Colors.white,
      key: customKey,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(56.0.h),
      //   child: const DefaultBackTitleAppBar(
      //     title: '%Supplier profile',
      //   ),
      // ),
      body: BlocConsumer<ProviderCubit, ProviderState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 235.0.h,
                title: providerCubit.isExpanded
                    ? null
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileBubble(
                            isOnline: false,
                            radius: 17.h,
                          ),
                          widthBox(7.w),
                          Center(
                              child: Text(
                            'Supplier name',
                            style: mainStyle(context,14,
                                color: mainBlueColor, weight: FontWeight.w600),
                          )),
                          widthBox(5.w),
                          const Icon(
                            Icons.verified,
                            color: Color(0xff01BC62),
                          ),
                        ],
                      ),
                backgroundColor: Colors.white,
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                flexibleSpace: !providerCubit.isExpanded
                    ? null
                    :  FlexibleSpaceBar(
                        // title: Row(
                        //   children: [
                        //     widthBox(30.w),
                        //     Center(child: Text('%supplier name', textScaleFactor: 1,style: mainStyle(context,14,color: mainBlueColor),)),
                        //   ],
                        // ),
                        background: SafeArea(
                        child: ProviderCard(
                          provider: widget.provider,
                          currentLayout: 'supplier profile',
                          justView: true,
                        ),
                      )),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40.0.sp),
                  child: Center(
                    child: HorizontalSelectorScrollable(
                        buttons: providerCubit.profileSelectorButtonsTitles
                            .map((e) => SelectorButtonModel(
                                  title: e.title,
                                  onClickCallback: () async {
                                    providerCubit.changeSelectedBody(e);
                                    ///
                                    ///
                                    /// solve extend when come back from not extended with scroll
                                    ///
                                    await Future.delayed(
                                        const Duration(milliseconds: 50));
                                    if (_scrollController.hasClients &&
                                        _scrollController.offset < (100)) {
                                      Future.delayed(
                                              const Duration(milliseconds: 50))
                                          .then((value) {
                                        logg('lorem ipsum tt');
                                        providerCubit.changeIsExpanded(true);
                                        // _scrollController.jumpTo(0.0);
                                      });
                                    }
                                  },
                                  isSelected: providerCubit.selectedBody == e,
                                ))
                            .toList()),
                  ),
                ),
              ),
              // Expanded(child: providerCubit.selectedBody!.bodyWidget)
              ///
              // SliverFillRemaining(
              //   child: providerCubit.selectedBody!.bodyWidget,
              // )
              // SingleChildScrollView(child: providerCubit.selectedBody!.bodyWidget)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultHorizontalPadding,
                          vertical: defaultHorizontalPadding),
                      child: providerCubit.selectedBody!.bodyWidget,
                    );
                  },
                  childCount: 1,
                ),
              ),
              // ///
            ],
          );
        },
      ),
    );
  }
}
