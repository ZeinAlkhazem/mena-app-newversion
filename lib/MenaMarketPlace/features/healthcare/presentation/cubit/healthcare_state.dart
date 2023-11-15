// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'healthcare_cubit.dart';

abstract class HealthcareState extends Equatable {
  const HealthcareState();

  @override
  List<Object> get props => [];
}

class HealthcareInitial extends HealthcareState {}

class HealthcareLoadingState extends HealthcareState {}

class HealthcareLoadedState extends HealthcareState {
  final List<HealthcareCategory> healthcareCategories;
  final HealthcareCategory healthcareCategory;
  HealthcareLoadedState({
    required this.healthcareCategories,
    required this.healthcareCategory,
  });
  @override
  List<Object> get props => [healthcareCategories , healthcareCategory];
}

class HealthcareErrorState extends HealthcareState {
  final String errorMsg;
  HealthcareErrorState({
    required this.errorMsg,
  });
  @override
  List<Object> get props => [errorMsg];
}
