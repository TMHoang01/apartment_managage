part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoginInitial extends AuthState {
  final String email;
  final String password;
  const AuthLoginInitial({required this.email, required this.password});
}

class AuthLoginLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);
}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterNeedInfo extends AuthState {}
