part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class AttachedFilesUpdated extends ProfileState {}
class UpdatingDataState extends ProfileState {}
class UpdatingPictureState extends ProfileState {}
class SuccessUpdatingPictureState extends ProfileState {}
class ErrorUpdatingPictureState extends ProfileState {}
class SuccessUpdatingDataState extends ProfileState {}
class ErrorUpdatingDataState extends ProfileState {}
class UpdateState extends ProfileState {}
