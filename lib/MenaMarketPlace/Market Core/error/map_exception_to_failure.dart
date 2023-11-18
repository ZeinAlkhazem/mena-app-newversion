import '../error/exceptions.dart';
import '../error/failures.dart';

Failure mapExceptionToFailure(Exception exception) {
  switch (exception.runtimeType) {
    case NoInternetConnectionException:
      return NoInternetFailure();

    case FetchDataException:
      return FetchDataFailure();
    case UnprocessableException:
      {
        UnprocessableFailure.msg = UnprocessableException.msg;
        return UnprocessableFailure();
      }
    case ForbiddenException:
      {
        ForbiddenFailure.msg = ForbiddenException.msg;
        return ForbiddenFailure();
      }

    case BadrequestException:
      return BadRequestFailure();
    case UnauthorizedException:
      return UnauthorizedFailure();
    case NotFoundException:
      return NotFoundFailure();
    case ConflictException:
      return ConflictFailure();
    case InternalServerErrorException:
      return InternalServerFailure();
    case CachException:
      return CacheFailure();
    case InvalidParametersException: {
        InvalidParametersFailure.msg = InvalidParametersException.msg;
         return InvalidParametersFailure();
      }
     
    case OTPinvalidException:
      return OTPinvalidFailure();
    default:
      return UnexpectedFailure();
  }
}
