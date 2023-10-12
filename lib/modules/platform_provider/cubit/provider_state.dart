part of 'provider_cubit.dart';

@immutable
abstract class ProviderState {}

class ProviderInitial extends ProviderState {}
class BodyChangedState extends ProviderState {}
class IsExpandedChangedState extends ProviderState {}
class LoadingProviderDetails extends ProviderState {}
class SuccessProviderDetailsData extends ProviderState {}
class ErrorProviderDetailsData extends ProviderState {}
class LoadingProviderProfessionals extends ProviderState {}
class SuccessLoadingProviderProfessionals extends ProviderState {}
class ErrorLoadingProviderProfessionals extends ProviderState {}
class SpecialityUpdatedState extends ProviderState {}
