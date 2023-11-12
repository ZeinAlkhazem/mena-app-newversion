part of 'create_live_cubit.dart';

@immutable
abstract class CreateLiveState {}

class CreateLiveInitial extends CreateLiveState {}

class ChangeAutoValidateModeState extends CreateLiveState {}

class RecordliveState extends CreateLiveState {}

class WhoCanCommentAndShowState extends CreateLiveState {}


class CreatingLiveState extends CreateLiveState {}

class SuccessCreateLive extends CreateLiveState{}