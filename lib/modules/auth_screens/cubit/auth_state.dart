abstract class AuthState {}

class AuthInitial extends AuthState {}

class SelectedPlatformUpdated extends AuthState {}
class SignupUserTypeUpdated extends AuthState {}

class ChangeAutoValidateModeState extends AuthState {}

class AuthLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {}

class VerifyingNumState extends AuthState {}

class SuccessVerifyingNumState extends AuthState {}

class ProceedingToResetPass extends AuthState {}

class SubmittingResetPass extends AuthState {}

class AuthGetPlatformCategoriesLoadingState extends AuthState {}

class PassVisibilityChanged extends AuthState {}

class AuthErrorState extends AuthState {
  final String? error;

  AuthErrorState(this.error);
}

class VerifyingNumErrorState extends AuthState {
  final String? error;

  VerifyingNumErrorState(this.error);
}
