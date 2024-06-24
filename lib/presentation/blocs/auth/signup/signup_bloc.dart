import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/user_model.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>((event, emit) {});
    on<SignupUpdateTypeUserInit>(_updatetypeUserInit);
    on<SignupSelectRoleAccount>(_selectRoleAccount);
    on<SinupUpdateInforInit>(_updateInforInit);
  }

  void _updatetypeUserInit(
      SignupUpdateTypeUserInit event, Emitter<SignupState> emit) {
    emit(SignupUpdateInforStarted());
  }

  void _selectRoleAccount(
      SignupSelectRoleAccount event, Emitter<SignupState> emit) {
    final roleSelect = event.role;
    // if (state is SignupUpdateInforStarted) {
    //   emit(state.copyWith(role: roleSelect));
    // }
    emit(SignupUpdateInforStarted(role: roleSelect));
  }

  void _updateInforInit(SinupUpdateInforInit event, Emitter<SignupState> emit) {
    emit(SignupUpdateProviderFormStarted());
  }
}
