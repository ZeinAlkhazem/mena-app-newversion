import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta/meta.dart';

import '../../../core/cache/cache.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/category-details.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/local_models.dart';

part 'childs_state.dart';

class ChildsCubit extends Cubit<ChildsState> {
  ChildsCubit() : super(ChildsInitial());

  static ChildsCubit get(context) => BlocProvider.of(context);

  List<MayyaRow> columnToView = [];
  Map<int, String> selectedSubs = {};

  CategoryDetailsModel? categoryDetailsModel;


  // MenaCategory? currentCategoryToView;

  ///  (father id, child id)
  int i = 0;
  int selectedSub = -1;

  Future<void> getCategoryDetails({required String mainFatherId, required List<String> filters}) async {
    /// get category details
    /// due to filters length,
    /// 1st element category
    /// 2nd element sub category
    /// 3rd element sub sub category
    // {{base_url}}/providers/category-details?lat=35&lng=35&category=1&sub_category=1&sub_sub_category=1
    String categoryId = '-1';
    String subCategoryId = '-1';
    String subSubCategoryId = '-1';

    logg('filters: $filters');
    filters.removeWhere((element) => element.startsWith('-'));
    logg('filters after removing negative id which is all for this row: $filters');
    switch (filters.length) {
      case 0:
        categoryId = mainFatherId.toString();
        subCategoryId = '-1';
        subSubCategoryId = '-1';
        break;
      case 1:
        categoryId = mainFatherId.toString();
        subCategoryId = filters[0].toString().replaceAll('cat_sub_', '');
        subSubCategoryId = '-1';
        break;
      case 2:
        categoryId = mainFatherId.toString();
        subCategoryId = filters[0].toString().replaceAll('cat_sub_', '');
        subSubCategoryId = filters[1].toString().replaceAll('cat_sub_sub_', '');
        break;
    }

    // currentCategoryToView=null;
    emit(LoadingCategoryDetailsData());
    await MainDioHelper.getData(
      url: '${categoryDetailsEnd}',
      query: {
        'category': categoryId,
        'sub_category': subCategoryId,
        'sub_sub_category': subSubCategoryId,
      },
    ).then((value) {
      logg('got categoryDetailsEnd');
      logg(value.toString());
      categoryDetailsModel = CategoryDetailsModel.fromJson(value.data);

      // currentCategoryToView=categoryDetailsModel!.data.category;
      logg('categoryDetailsEnd model filled');
      emit(SuccessCategoryDetailsData());
    }).catchError((error,stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorCategoryDetailsData());
    });
  }

  void resetFiltersColumnView() {
    columnToView = [];
    selectedSubs = {};
    selectedSub = -1;

    ///
    i = 0;
  }

  updateSelectedSub(int id) {
    if (selectedSub != id) {
      selectedSub = id;
      emit(SelectedCatChanged());
    }
  }

  Future<void> updateSelectedSubsMap({
    required int firstChildId,
    required String selectedId,
    required bool clear,
  }) async {
    logg('firstChildId: $firstChildId \n'
        'clear: $clear \n'
        'selectedId: $selectedId \n');

    if (clear) {

      // logg('clear');
      //

      if (selectedSubs.containsValue(selectedId)) {
        selectedSubs.removeWhere((key, value) => selectedId == value);
        selectedSubs.clear();
        logg('already added');
      } else {
        selectedSubs.clear();
        selectedSubs.addAll({
          firstChildId: selectedId,
        });
      }
    } else
    // else
    // if(selectedSubs.containsValue(selectedId)){
    //   logg('selectedsubs contains value $selectedId');
    //   selectedSubs.removeWhere((key, value) => value==selectedId);
    // }
    if (selectedSubs.containsValue(selectedId)) {
      selectedSubs.removeWhere((key, value) => selectedId == value);
      logg('already added');
    } else {
      selectedSubs.addAll({
        firstChildId: selectedId,
      });
    }
    logg('selected subs : ${selectedSubs.toString()}');
    emit(SelectedCatChanged());
  }

  void updateSelectedItem(int rowId, int itemId) {}

  void updateColumnView(List<MenaCategory?>? childs) {
    /// here we should have selection tool
    if (childs != null) {
      columnToView.add(
        MayyaRow(
          id: i,
          widget: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              HorizontalSelectorScrollable(
                buttons: childs
                    .map((e) => SelectorButtonModel(
                        title: e!.name!,
                        onClickCallback: () {
                          logg('current value = ${e.id}');
                          updateColumnView(childs.firstWhere((element) => element!.id == e.id)!.childs);
                          selectedSubs[e.id] = e.filterId!;
                          logg('selectedSubs: ${selectedSubs.toString()}');
                          emit(SelectedCatChanged());
                        },
                        isSelected: selectedSubs.containsValue(e.id)))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class MayyaRow {
  final int id;
  final Widget widget;

  MayyaRow({required this.id, required this.widget});
}
