import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/manage/employee_repository.dart';

part 'employee_form_event.dart';
part 'employee_form_state.dart';

class EmployeeFormBloc extends Bloc<EmployeeFormEvent, EmployeeFormState> {
  final EmployeeRepository employeeRepository;
  EmployeeFormBloc(this.employeeRepository) : super(EmployeeFormInitial()) {
    on<EmployeeFormEvent>((event, emit) {});
    on<EmployeeAccountCreated>(_onEmployeeAccountCreated);
    on<EmployeeUpdatedInforStared>(_onEmployeeUpdatedInforStared);
    on<EmployeeUpdatedInforSubmit>(_onEmployeeUpdatedInforSubmit);
  }

  void _onEmployeeAccountCreated(
      EmployeeAccountCreated event, Emitter emit) async {
    emit(EmployeeAccountCreatedLoading());
    try {
      final newEmployee = await employeeRepository.createdAccountEmployee(
          email: event.email, password: event.password);
      if (newEmployee == null) {
        emit(EmployeeFormError(message: 'Tạo tài khoản thất bại'));
        return;
      }
      emit(EmployeeFormInforInitial(
        newEmployee: newEmployee,
      ));
    } catch (e) {
      emit(EmployeeFormError(message: e.toString()));
    }
  }

  void _onEmployeeUpdatedInforStared(
      EmployeeUpdatedInforStared event, Emitter emit) async {
    emit(EmployeeFormInforInitial(
      newEmployee: event.employee,
    ));
  }

  void _onEmployeeUpdatedInforSubmit(
      EmployeeUpdatedInforSubmit event, Emitter emit) async {
    emit(EmployeeFormInforLoading());
    try {
      Employee employee = event.employee;
      await Future.delayed(const Duration(seconds: 1));
      if (employee.status == StatusUser.pending) {
        employee = employee.copyWith(status: StatusUser.active);
      }
      await employeeRepository.updateEmployee(employee);
      emit(EmployeeFormInforSuccess(employee: employee));
    } catch (e) {
      emit(EmployeeFormError(message: e.toString()));
    }
  }
}
