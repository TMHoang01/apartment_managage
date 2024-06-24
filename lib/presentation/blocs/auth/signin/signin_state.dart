part of 'signin_cubit.dart';

final class SigninInitial extends SigninState {}

final class SigninState extends Equatable {
  const SigninState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isShowPassword = false,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isShowPassword;

  SigninState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
    bool? isShowPassword,
  }) {
    // logger.i(status);
    return SigninState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }

  @override
  List<Object> get props => [status, email, password, isValid, isShowPassword];
}
