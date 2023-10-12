part of 'childs_cubit.dart';

@immutable
abstract class ChildsState {}

class ChildsInitial extends ChildsState {}
class SelectedCatChanged extends ChildsState {}
class LoadingCategoryDetailsData extends ChildsState {}
class SuccessCategoryDetailsData extends ChildsState {}
class ErrorCategoryDetailsData extends ChildsState {}
