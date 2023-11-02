part of '../cubit/messenger_cubit.dart';

@immutable
abstract class MessengerState {}

class MessengerInitial extends MessengerState {}
class ExpandChangedState extends MessengerState {}

class SendingMsgState extends MessengerState {}
class DeletingMsgState extends MessengerState {}
class SuccessDeletingMsgState extends MessengerState {}
class ErrorDeletingMsgState extends MessengerState {}
class AttachedFilesUpdated extends MessengerState {}
class VoiceFilesUpdated extends MessengerState {}
class SuccessSendingMsgState extends MessengerState {}
class ChatResetState extends MessengerState {}
class ErrorSendingMsgState extends MessengerState {}
class GettingMessagesData extends MessengerState {}
class GettingMyMessagesData extends MessengerState {}
class GettingUsersData extends MessengerState {}
class SuccessGettingUsersDataState extends MessengerState {}
class ErrorGettingUsersDataState extends MessengerState {}
class ChangedMessengerNewMessageLayout extends MessengerState {}
class SuccessGettingMessagesDataState extends MessengerState {}
class SuccessGettingMyMessagesDataState extends MessengerState {}
class ErrorGettingMessagesDataState extends MessengerState {}

class ToggleRecordingState extends MessengerState {}
