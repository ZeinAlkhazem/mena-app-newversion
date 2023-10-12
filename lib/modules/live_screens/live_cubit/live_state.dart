part of 'live_cubit.dart';

@immutable
abstract class LiveState {}

class LiveInitial extends LiveState {}

class CurrentViewChanged extends LiveState {}
class UpdatePickedLiveTime extends LiveState {}

class ThumbnailFileUpdated extends LiveState {}
class LoadingMeetingsState extends LiveState {}
class SuccessLoadingMeetingsState extends LiveState {}

class GettingLiveCategories extends LiveState {}

class UpdatingLiveStatus extends LiveState {}
class UpdatingMeetingStatus extends LiveState {}

class UpdatedLiveStatus extends LiveState {}

class ErrorUpdatedLiveStatus extends LiveState {}

class SuccessGetLivesNowAndUpcoming extends LiveState {}

class ErrorGetLivesNowAndUpcoming extends LiveState {}

class GettingLivesState extends LiveState {}

class SuccessGettingLivesState extends LiveState {}

class ErrorGettingLivesState extends LiveState {}

class GettingGoLiveAndGetLiveFromServer extends LiveState {}

class SuccessGoLiveAndGetLiveFromServer extends LiveState {}

class ErrorGoLiveAndGetLiveFromServer extends LiveState {}
