part of 'employee_form_bloc.dart';

sealed class EmployeeFormEvent extends Equatable {
  const EmployeeFormEvent();

  @override
  List<Object> get props => [];
}

class EmployeeAccountCreated extends EmployeeFormEvent {
  final String email;
  final String password;

  const EmployeeAccountCreated({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class EmployeeUpdatedInforStared extends EmployeeFormEvent {
  final Employee employee;

  const EmployeeUpdatedInforStared({required this.employee});
}

class EmployeeUpdatedInforSubmit extends EmployeeFormEvent {
  final Employee employee;

  const EmployeeUpdatedInforSubmit({required this.employee});
}
