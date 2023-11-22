import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_store/json_store.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());
  static HomeScreenCubit get(context) => BlocProvider.of(context);
  HomeSectionModel? homeSectionModel;
  String? selectedHomePlatformId;
  Future<void> changeSelectedHomePlatform(String id) async{
    log("# change select home platform :$id ");
    homeSectionModel=null;
    selectedHomePlatformId = id;
    await getHomeSections(id);
    emit(SelectedHomePlatformChanged());
  }
  Future<void> getHomeSections(String platformId) async {
    /// get local db
    // JsonStore jsonStore = JsonStore();
    // Map<String, dynamic>? json = await jsonStore.getItem('homeSections');
    // if (json != null) {
    //   logg('homeSection data got from sqfLite');
    //   homeSectionModel = HomeSectionModel.fromJson(json);
    //   logg('local stored homeSection: ${homeSectionModel!.message}');
    // }

    emit(LoadingDataState());
    ///    /// end local db
    logg('getting home section data');
    await MainDioHelper.getData(
            url: '$homeSectionEnd/$platformId', query: {})
        .then((value) async {
      logg('home sections data got');
      logg(value.toString());
      homeSectionModel = HomeSectionModel.fromJson(value.data);
      /// save local db
      // await jsonStore.setItem('homeSections', homeSectionModel!.toJson());
      /// end local db
      emit(DataLoadedSuccessState());
    }).catchError((error,stacktrace) {
      logg('an error occurred');
      logg(error.toString());
      logg('stack trace');
      logg(stacktrace.toString());
      emit(ErrorLoadingDataState());
    });
  }
}
