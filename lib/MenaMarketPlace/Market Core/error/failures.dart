// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class UnexpectedFailure extends Failure {
  
}

class CacheFailure extends Failure {}

class NoInternetFailure extends Failure {}

class UnprocessableFailure extends Failure {
  static String msg='';
 
}
class VerifyFailure extends Failure {
  static String msg='';
 
}

class UnauthorizedFailure extends Failure {}

class FetchDataFailure extends Failure {}

class InvalidParametersFailure extends Failure {
  static String msg='';
}
class ForbiddenFailure extends Failure {
  static String msg='';
}

class OTPinvalidFailure extends Failure {}

class BadRequestFailure extends Failure {}

class NotFoundFailure extends Failure {}

class ConflictFailure extends Failure {}

class InternalServerFailure extends Failure {}
