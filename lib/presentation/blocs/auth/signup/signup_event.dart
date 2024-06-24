part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

final class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;

  const SignupSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignupUpdateTypeUserInit extends SignupEvent {}

class SignupSelectRoleAccount extends SignupEvent {
  final Role role;

  const SignupSelectRoleAccount({required this.role});

  @override
  List<Object> get props => [role];
}

class SinupUpdateInforInit extends SignupEvent {
  const SinupUpdateInforInit();

  @override
  List<Object> get props => [];
}
