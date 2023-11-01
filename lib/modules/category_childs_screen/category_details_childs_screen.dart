import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/modules/category_childs_screen/cubit/childs_cubit.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/home_section_model.dart';
import '../../models/local_models.dart';
import '../home_screen/home_screen.dart';
import '../platform_provider/provider_home/platform_provider_home.dart';

class CategoryChildsScreen extends StatefulWidget {
  const CategoryChildsScreen({Key? key, required this.currentCategoryToViewId}) : super(key: key);

  final String currentCategoryToViewId;

  // final String currentCategoryToView;

  @override
  State<CategoryChildsScreen> createState() => _CategoryChildsScreenState();
}

class _CategoryChildsScreenState extends State<CategoryChildsScreen> {
  MenaCategory? currentCategoryToView;

  bool isDataReadyToView = false;

  @override
  void initState() {
    // TODO: implement initState
    ChildsCubit.get(context)
      ..resetFiltersColumnView()
      ..getCategoryDetails(mainFatherId: widget.currentCategoryToViewId, filters: []).then((value) {
        currentCategoryToView = ChildsCubit.get(context).categoryDetailsModel!.data.category;
        setState(() {
          ChildsCubit.get(context).categoryDetailsModel = null;
          isDataReadyToView = true;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var childsCubit = ChildsCubit.get(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: defaultSearchMessengerAppBar(context),
        body: SafeArea(
          child: isDataReadyToView == false
              ? DefaultLoaderColor()
              : BlocConsumer<ChildsCubit, ChildsState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Container(
                      color: newLightGreyColor,
                      child: Column(
                        children: [
                          // state is LoadingCategoryDetailsData?SizedBox():

                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(defaultRadiusVal),
                                    bottomRight: Radius.circular(defaultHorizontalPadding))),
                            child: ChildsFilterHorizontalRows(
                                childs: currentCategoryToView!.childs,
                                fatherId: currentCategoryToView!.id),
                          ),

                          Expanded(
                            child:

                                /// test null or empty in 2 lines
                                state is LoadingCategoryDetailsData?
                                    ? Container(color: newLightGreyColor, child: const DefaultLoaderGrey())
                                    : childsCubit.categoryDetailsModel == null
                                        ? SizedBox()
                                        : childsCubit.categoryDetailsModel!.data.categoryLayoutSections.isEmpty
                                            ? const EmptyListLayout()
                                            : ListView.separated(
                                                physics: const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) => Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          // homeCubit
                                                          //             .homeSectionModel!
                                                          //             .data[index]
                                                          //             .type ==
                                                          //         'video'
                                                          //     ? 0
                                                          //     :
                                                          homeScreeHorizontalPadding),
                                                  child: HomeSectionBlock(
                                                    homeSectionBlockModel: childsCubit
                                                        .categoryDetailsModel!.data.categoryLayoutSections[index],
                                                    currentHomeCategory: currentCategoryToView!.name,
                                                  ),
                                                ),
                                                separatorBuilder: (_, index) => heightBox(10.h),
                                                itemCount: childsCubit
                                                    .categoryDetailsModel!.data.categoryLayoutSections.length,
                                                padding: EdgeInsets.only(bottom: 22.h, top: 10.h),
                                              ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}

class ChildsFilterHorizontalRows extends StatefulWidget {
  const ChildsFilterHorizontalRows({
    Key? key,
    this.childs,
    this.fatherId,
  }) : super(key: key);

  final List<MenaCategory?>? childs;
  final int? fatherId;

  @override
  State<ChildsFilterHorizontalRows> createState() => _ChildsFilterHorizontalRowsState();
}

class _ChildsFilterHorizontalRowsState extends State<ChildsFilterHorizontalRows> {
  @override
  void initState() {
    // TODO: implement initState
    var childsCubit = ChildsCubit.get(context);

    logg('current value = All');
    if (widget.childs != null && widget.childs!.isNotEmpty) {
      childsCubit
          .updateSelectedSubsMap(
              firstChildId: widget.fatherId!, selectedId: (widget.childs![0]!.id * -1).toString(), clear: false)
          .then((value) {
        childsCubit.getCategoryDetails(
            mainFatherId: childsCubit.selectedSubs.isEmpty
                ? widget.fatherId!.toString()
                : childsCubit.selectedSubs.keys.first.toString(),
            filters: childsCubit.selectedSubs.values.toList());
      });
    } else {
      childsCubit
          .updateSelectedSubsMap(firstChildId: widget.fatherId!, selectedId: (-1).toString(), clear: false)
          .then((value) {
        childsCubit.getCategoryDetails(
            mainFatherId: childsCubit.selectedSubs.isEmpty
                ? widget.fatherId!.toString()
                : childsCubit.selectedSubs.keys.first.toString(),
            filters: childsCubit.selectedSubs.values.toList());
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var childsCubit = ChildsCubit.get(context);
    return BlocConsumer<ChildsCubit, ChildsState>(
      listener: (context, state) {
        // TODO: implement listener
        // if (state is SelectedCatChanged) {
        //   // childsCubit.updateSelectedSubsMap(
        //   //     firstChildId: widget.fatherId!, selectedId: (widget.childs![0]!.id * -1).toString(), clear: false);
        // }
      },
      builder: (context, state) {
        return (widget.childs == null)
            ? SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        widthBox(defaultHorizontalPadding),
                        SelectorButton(
                            title: 'ALL',
                            isSelected:
                                (childsCubit.selectedSubs.containsValue((widget.childs![0]!.id * -1).toString()) ||

                                    /// no child selected
                                    /// so selected subs doesn't contain any value with key father id
                                    !childsCubit.selectedSubs.containsKey(widget.fatherId!)),
                            onClick: () {
                              /// unselected current items in the row and remove the below rows
                              logg('current value = All');
                              childsCubit
                                  .updateSelectedSubsMap(
                                      firstChildId: widget.fatherId!,
                                      selectedId: (widget.childs![0]!.id * -1).toString(),
                                      clear: false)
                                  .then((value) {
                                childsCubit.getCategoryDetails(
                                    mainFatherId: childsCubit.selectedSubs.isEmpty
                                        ? widget.fatherId!.toString()
                                        : childsCubit.selectedSubs.keys.first.toString(),
                                    filters: childsCubit.selectedSubs.values.toList());
                              });
                            }),
                        Expanded(
                          child: HorizontalSelectorScrollable(
                            buttons: widget.childs!
                                .map((e) => SelectorButtonModel(
                                    title: e!.name!,
                                    onClickCallback: () {
                                      // logg('current Column index = ${i}');
                                      logg('current value = ${e.filterId}');
                                      childsCubit
                                          .updateSelectedSubsMap(
                                              firstChildId: widget.fatherId!,
                                              selectedId: e.filterId!,
                                              clear: (e.childs != null))
                                          .then((value) {
                                        /// select all in next row
                                        // if (e.childs != null) {
                                        //   childsCubit.updateSelectedSubsMap(
                                        //       firstChildId: widget.fatherId!,
                                        //       selectedId: (e.childs![0]!.id * -1).toString(),
                                        //       clear: false);
                                        // }

                                        ///
                                        childsCubit.getCategoryDetails(
                                            mainFatherId: childsCubit.selectedSubs.isEmpty
                                                ? widget.fatherId!.toString()
                                                : childsCubit.selectedSubs.keys.first.toString(),
                                            filters: childsCubit.selectedSubs.values.toList());
                                      });

                                      // updateColumnView(childs.firstWhere((element) => element!.id==e.id)!.childs);
                                      // selectedSubs[e.id]=e.id;
                                      // logg('selectedSubs: ${selectedSubs.toString()}');
                                      // emit(SelectedCatChanged());
                                    },
                                    isSelected: childsCubit.selectedSubs.containsValue(e.filterId)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.childs!
                          .where((element) {
                            return childsCubit.selectedSubs.containsValue(element!.filterId);
                          })
                          .map((e) => e)
                          .toList()
                          .isEmpty
                      ? SizedBox()
                      : widget.childs!
                                  .firstWhere((element) => childsCubit.selectedSubs.containsValue(element!.filterId))!
                                  .childs ==
                              null
                          ? SizedBox()
                          : ChildsFilterHorizontalRows(
                              childs: widget.childs!
                                  .firstWhere((element) => childsCubit.selectedSubs.containsValue(element!.filterId))!
                                  .childs,
                              fatherId: widget.childs!
                                  .where((element) => childsCubit.selectedSubs.containsValue(element!.filterId))
                                  .map((e) => e)
                                  .toList()[0]!
                                  .id,
                            )
                ],
              );
      },
    );
  }
}
