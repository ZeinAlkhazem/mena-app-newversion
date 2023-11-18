// ignore_for_file: public_member_api_docs, sort_constructors_first

class UnexpectedException implements Exception {
  
}

class FetchDataException implements Exception {}

class BadrequestException implements Exception {}

class UnauthorizedException implements Exception {}

class NotFoundException implements Exception {}

class ConflictException implements Exception {}

class UnprocessableException implements Exception {
  static String msg = '';
}
class ForbiddenException implements Exception {
  static String msg = '';
}
class VerifyException implements Exception {
  static String msg = '';
}

class InternalServerErrorException implements Exception {}

class NoInternetConnectionException implements Exception {}

class CachException implements Exception {}

class InvalidParametersException implements Exception {
  static String msg='';
}

class OTPinvalidException implements Exception {}
