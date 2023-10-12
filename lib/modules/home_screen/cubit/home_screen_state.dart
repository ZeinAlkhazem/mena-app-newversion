part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}
class SelectedHomePlatformChanged extends HomeScreenState {}
class LoadingDataState extends HomeScreenState {}
class DataLoadedSuccessState extends HomeScreenState {}
class ErrorLoadingDataState extends HomeScreenState {}
