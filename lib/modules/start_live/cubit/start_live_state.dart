part of 'start_live_cubit.dart';

@immutable
abstract class StartLiveState {}

class StartLiveInitial extends StartLiveState {}

class OnPressStopLiveState extends StartLiveState {}

class OnPressPauseLiveState extends StartLiveState {}

class OnPressCreatePollState extends StartLiveState {}

class OnPressShareLiveState extends StartLiveState {}

class OnPressCopyLinkState extends StartLiveState {}

class OnPressReportState extends StartLiveState {}

class OnPressFollowState extends StartLiveState {}

class OnHideCommentsState extends StartLiveState {}

class OnPick4PhotoState extends StartLiveState {}
