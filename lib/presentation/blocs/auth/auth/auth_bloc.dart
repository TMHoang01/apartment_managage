import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // check go on app
    on<CheckAuthRequested>((event, emit) async {
      try {
        await _getCurrentUser(emit);
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<SignInRequested>(_signInWithEmailAndPassword);

    on<SignUpRequested>(_signUp);

    on<GoogleSignInRequested>(_signInWithGoogle);

    on<SignOutRequested>(_signOut);

    on<AuthLoginPrefilled>(_loginPrefilled);
  }

  Future<void> _getCurrentUser(Emitter<AuthState> emit) async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      if (user.roles == null) {
        emit(AuthRegisterNeedInfo());
      } else {
        emit(Authenticated(user));
      }
    } else {
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    emit(AuthLoginLoading());
    await authRepository.signOut();
    emit(UnAuthenticated());
  }

  FutureOr<void> _signInWithGoogle(event, emit) async {
    emit(AuthLoginLoading());
    try {
      await authRepository.signInWithGoogle();
      await _getCurrentUser(emit);
    } catch (e) {
      authRepository.signOut();
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signInWithEmailAndPassword(event, emit) async {
    emit(AuthLoginLoading());
    try {
      await authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      await _getCurrentUser(emit);
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _signUp(event, emit) async {
    emit(AuthRegisterLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      await _getCurrentUser(emit);

      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  FutureOr<void> _loginPrefilled(
      AuthLoginPrefilled event, Emitter<AuthState> emit) async {
    emit(AuthLoginInitial(email: event.email, password: event.password));
  }

  void _onAuthStart(AuthInitial event, Emitter<AuthState> emit) {
    final user = authRepository.getCurrentUser();
  }
}
