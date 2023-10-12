part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

class MeetingInitial extends MeetingState {}

class InitialState extends MeetingState {}

class OnPressAudioMeetingState extends MeetingState {}

class OnPressCameraMeetingState extends MeetingState {}

class OnPressChatMeetingState extends MeetingState {}

class OnPressShareMeetingState extends MeetingState {}

class OnPressRecordMeetingState extends MeetingState {}

class OnPressReactionsMeetingState extends MeetingState {}

class OnPressWhiteboardsMeetingState extends MeetingState {}

class OnPressSecurityMeetingState extends MeetingState {}

class OnPressMoreMeetingState extends MeetingState {}

class OnloadingState extends MeetingState {}
