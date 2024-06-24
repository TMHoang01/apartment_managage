part of 'employees_bloc.dart';

sealed class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class EmployeesFetch extends EmployeesEvent {}

class EmployeesEditLocal extends EmployeesEvent {
  final Employee employee;

  const EmployeesEditLocal(this.employee);

  @override
  List<Object> get props => [employee];
}
