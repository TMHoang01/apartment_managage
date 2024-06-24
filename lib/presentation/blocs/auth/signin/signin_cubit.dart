import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:apartment_managage/utils/vadidate/email.dart';
import 'package:apartment_managage/utils/vadidate/password.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(
      // this.authRepository,
      )
      : super(const SigninState());
  // final AuthRepository authRepository;
  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([password, state.email]),
    ));
  }

  void checkValidation() {
    emit(state.copyWith(status: FormzSubmissionStatus.initial, isValid: false));
    //check if email or password is empty
    if (state.email.value.isEmpty || state.password.value.isEmpty) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        email: Email.dirty(state.email.value),
        password: Password.dirty(state.password.value),
      ));
    }

    if (state.email.isValid && state.password.isValid) {
      emit(
          state.copyWith(status: FormzSubmissionStatus.success, isValid: true));
    } else {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }
}
