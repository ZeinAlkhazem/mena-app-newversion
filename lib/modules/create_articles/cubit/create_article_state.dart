part of 'create_article_cubit.dart';

@immutable
abstract class CreateArticleState {}
class CreateArticleInitial extends CreateArticleState {}
class ImageUploaded extends CreateArticleState {}
class GettingArticleInfoState extends CreateArticleState {}
class ArticleLoadingState extends CreateArticleState {}
class SavingAppointmentState extends CreateArticleState  {}
class ErrorGettingArticleState extends CreateArticleState {}
class SuccessGettingArticleState extends  CreateArticleState {}

class ArticleErrorState extends CreateArticleState {
  final String? error;

  ArticleErrorState(this.error);
}


class SelectedPlatformUpdated extends CreateArticleState {}


class ChangeAutoValidateModeState extends CreateArticleState {}