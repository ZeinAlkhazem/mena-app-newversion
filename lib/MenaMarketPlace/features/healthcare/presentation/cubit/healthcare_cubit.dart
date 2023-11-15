import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../Market Core/error/failures.dart';
import '../../../../Market Core/error/map_failure_to_msg.dart';
import '../../domain/entities/healthcare_category.dart';
import '../../domain/usecases/get_healthcare_categories_usecase.dart';

part 'healthcare_state.dart';

class HealthcareCubit extends Cubit<HealthcareState> {
  final GetHealthcareCategoriesUsecase getHealthcareCategoriesUsecase;
  List<HealthcareCategory> categoriesList = [];
  HealthcareCubit({required this.getHealthcareCategoriesUsecase})
      : super(HealthcareInitial());
  Future<void> getHealthcareCategories(Map<String, dynamic>? catData) async {
    emit(HealthcareLoadingState());
    Either<Failure, List<HealthcareCategory>> catListOrFailure =
        await getHealthcareCategoriesUsecase(catData);
    emit(catListOrFailure.fold(
        (l) => HealthcareErrorState(errorMsg: mapFailureToMessage(l)), (r) {
      categoriesList = r;
      return HealthcareLoadedState(
          healthcareCategories: r, healthcareCategory: r[0]);
    }));
  }

  void filterSubCategory(HealthcareCategory hc) {
    emit(HealthcareLoadedState(
        healthcareCategories: categoriesList, healthcareCategory: hc));
  }
}
