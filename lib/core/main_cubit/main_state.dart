part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}
class ConnectionStateChanging extends MainState {}
class SetUpCheckedState extends MainState {}
class UpdateState extends MainState {}
class FollowingUserState extends MainState {}
class SuccessFollowingUserState extends MainState {}
class ErrorFollowingUserState extends MainState {}
class HeaderVisibilityChanged extends MainState {}
class ConnectionStateChanged extends MainState {}
class ExpandedChanged extends MainState {}
class SelectedCountryUpdated extends MainState {}
class SelectedPlatformUpdated extends MainState {}
class CountrySearchQueryUpdated extends MainState {}
class SelectedItemIdChanged extends MainState {}
class LocaleChangedState extends MainState {}

///config
class DataLoadedSuccessState extends MainState {}
class ErrorLoadingDataState extends MainState {}

