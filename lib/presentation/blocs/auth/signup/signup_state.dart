part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupError extends SignupState {
  final String error;

  const SignupError(this.error);

  @override
  List<Object> get props => [error];
}

final class SignupUpdateInforStarted extends SignupState {
  Role role;
  SignupUpdateInforStarted({this.role = Role.user});

  @override
  List<Object> get props => [role];

  SignupUpdateInforStarted copyWith({Role? role}) {
    return SignupUpdateInforStarted(role: role ?? this.role);
  }
}

final class SignupUpdateProviderFormStarted extends SignupState {}

final class SignupUpdateResidentFormStarted extends SignupState {}
