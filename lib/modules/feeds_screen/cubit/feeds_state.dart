part of 'feeds_cubit.dart';

@immutable
abstract class FeedsState {}

class FeedsInitial extends FeedsState {}

class GettingCommentsState extends FeedsState {}

class SuccessGettingCommentsState extends FeedsState {}

class ErrorGettingCommentsState extends FeedsState {}

class GettingFeedsState extends FeedsState {}

class GettingBlogsInfoState extends FeedsState {}

class GettingMyBlogsInfoState extends FeedsState {}

class GettingProviderBlogsInfoState extends FeedsState {}

class GettingBlogDetailsState extends FeedsState {}

class GettingBlogsItemsState extends FeedsState {}

class HidingFeedsState extends FeedsState {}

class UpdatingCommentLikeState extends FeedsState {}

class SuccessUpdatingCommentLikeState extends FeedsState {
  // final MenaFeedComment menaFeedComment;
  // SuccessUpdatingCommentLikeState();
}

class ErrorUpdatingCommentLikeState extends FeedsState {}

class ReportingFeedsState extends FeedsState {}

class SuccessHidingFeedsState extends FeedsState {}

class ErrorHidingFeedsState extends FeedsState {}

class DeletingFeedsState extends FeedsState {}

class SuccessDeletingFeedsState extends FeedsState {}

class ErrorDeletingFeedsState extends FeedsState {}

class SuccessGettingFeedsState extends FeedsState {}

class ErrorGettingFeedsState extends FeedsState {}

class UpdatingLikeState extends FeedsState {}

class SuccessUpdatingLikeState extends FeedsState {}

class ErrorUpdatingLikeState extends FeedsState {}

class FeedAudienceUpdated extends FeedsState {}

class GettingFeedsVideosState extends FeedsState {}

class SuccessGettingFeedsVideosState extends FeedsState {}

class ErrorGettingFeedsVideosState extends FeedsState {}

class SendingFeedState extends FeedsState {}

class SuccessSendingFeedState extends FeedsState {
  final MenaFeed? menaFeed;
  SuccessSendingFeedState({required this.menaFeed});
}

class NoDataToSendState extends FeedsState {}

class ErrorSendingFeedState extends FeedsState {}

class FeedUpdated extends FeedsState {}

class AddingCommentState extends FeedsState {}

class SuccessAddingCommentState extends FeedsState {
  final MenaFeed menaFeed;

  SuccessAddingCommentState({required this.menaFeed});
}

class ErrorAddingCommentState extends FeedsState {}

class SelectedCatChanged extends FeedsState {}

class SelectCategory extends FeedsState {}

class AddStory extends FeedsState {}

class GetStories extends FeedsState {
  final int length;
  GetStories({required this.length});
}
