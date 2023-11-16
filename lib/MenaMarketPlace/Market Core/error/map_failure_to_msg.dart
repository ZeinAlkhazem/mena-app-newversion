
import '../error/failures.dart';


String mapFailureToMessage(Failure failure, {String? unAuth}) {
  switch (failure.runtimeType) {
    case UnexpectedFailure:
      return "An unexpected error occurred";
    case UnprocessableFailure:
      return UnprocessableFailure.msg;
    case ForbiddenFailure:
      return ForbiddenFailure.msg;
    case CacheFailure:
      return "An internal storage error has occurred";
    case NoInternetFailure:
      return "Please Check Your Internet Connection ";

    case UnauthorizedFailure:
      return unAuth ??"The user is not registered";
    case FetchDataFailure:
      return "An error occurred while fetching data";
    case BadRequestFailure:
      return "Bad Request Error";
    case NotFoundFailure:
      return "Request status not found";
    case ConflictFailure:
      return "A data conflict error occurred";
    case InternalServerFailure:
      return "An internal server error occurred";
    case InvalidParametersFailure:
      return InvalidParametersFailure.msg;
    
    default:
      return "An unexpected error occurred";
  }
}
