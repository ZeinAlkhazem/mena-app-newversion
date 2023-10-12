
abstract class CompleteInfoState {}

class CompleteInfoInitial extends CompleteInfoState {}
class AttachmentPicked extends CompleteInfoState {}
class AttachmentRemoved extends CompleteInfoState {}
class SubmittingAdditionalRequiredData extends CompleteInfoState {}
class LoadingAdditionalRequiredData extends CompleteInfoState {}
class SuccessLoadingAdditionalRequiredData extends CompleteInfoState {}
class ErrorLoadingAdditionalRequiredData extends CompleteInfoState {}
