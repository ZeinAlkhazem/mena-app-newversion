import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/models/api_model/provider_details_model.dart';

import '../../../core/cache/cache.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/provider_professionals_model.dart';
import '../../../models/local_models.dart';
import '../supplier_profile/provider_home_bodies/departments_body.dart';
import '../supplier_profile/provider_home_bodies/profile_body.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  ProviderCubit() : super(ProviderInitial());

  static ProviderCubit get(context) => BlocProvider.of(context);

  // String selectedBody = 'Profile';// first element of profileSelectorButtonsTitles

  ///
  ///
  ///
  ///
  /// old cubit
  ///
  /// see new
  ///
  ///
  BodyItemModel? selectedBody;
  bool isExpanded = true;

  List<BodyItemModel> profileSelectorButtonsTitles = [
    BodyItemModel(title: 'Profile', bodyWidget: const ProviderProfileBody()),
    BodyItemModel(
        title: 'Departments', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(title: 'Branch', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(title: 'Feeds', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(
        title: 'Webinar', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(
        title: 'Appointments', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(title: 'Events', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(title: 'Deals', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(title: 'Jobs', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(
        title: 'Reviews', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(
        title: 'E-services', bodyWidget: const ProviderDepartmentsBody()),
    BodyItemModel(
        title: 'Contact', bodyWidget: const ProviderDepartmentsBody()),
  ];

  void initialBody() {
    selectedBody = profileSelectorButtonsTitles[0];
    emit(BodyChangedState());
  }

  void changeIsExpanded(bool status) {
    if (isExpanded != status) {
      logg('changing is expanded ${status.toString()}');
      isExpanded = status;
      emit(IsExpandedChangedState());
    }
  }

  Future<void> changeSelectedBody(BodyItemModel newSelectedBody) async {
    selectedBody = newSelectedBody;
    emit(BodyChangedState());
  }

  ///
  ///
  ///
  ///
  ///
  /// new cubit started here
  ///
  ///
  ///
  ///

  ProviderDetailsModel? providerDetailsModel;
  ProviderProfessionalsModel? professionalsModel;

  String selectedSpeciality = '';

  Future<void> getProviderDetails(String providerId) async {
    emit(LoadingProviderDetails());
    await MainDioHelper.getData(
        url: '${providerDetailsEnd}/$providerId', query: {}).then((value) {
      logg('got provider details');
      logg(value.toString());
      providerDetailsModel = ProviderDetailsModel.fromJson(value.data);
      logg('providerDetailsModel model filled');
      emit(SuccessProviderDetailsData());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorProviderDetailsData());
    });
  }

  Future<void> getProfessionals(
      {required String providerId, String specialityId = ''}) async {
    // professionalsModel=null;
    if (professionalsModel != null) {
      professionalsModel!.data.professionals = [];
    }
    emit(LoadingProviderProfessionals());
    await MainDioHelper.getData(
        url:
            '${providerProfessionalsEnd}?provider_id=$providerId${specialityId == '' ? '' : '&speciality_id=$specialityId'}',
        query: {}).then((value) {
      logg('got provider professionals');
      logg(value.toString());
      professionalsModel = ProviderProfessionalsModel.fromJson(value.data);
      logg('professionalsModel model filled');
      logg('professionals :${professionalsModel!.data.professionals}');

      emit(SuccessLoadingProviderProfessionals());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingProviderProfessionals());
    });
  }

  void updateSelectedSpeciality(String newSpeciality) {
    if (selectedSpeciality == newSpeciality) {
      selectedSpeciality = ''; //unselect
    } else {
      selectedSpeciality = newSpeciality;
    }

    emit(SpecialityUpdatedState());
  }
  void resetProfessionalModel() {
   professionalsModel=null;
    emit(SpecialityUpdatedState());
  }
}
