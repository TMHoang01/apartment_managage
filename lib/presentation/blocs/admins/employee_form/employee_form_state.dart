part of 'employee_form_bloc.dart';

sealed class EmployeeFormState extends Equatable {
  const EmployeeFormState();

  @override
  List<Object> get props => [];
}

final class EmployeeFormInitial extends EmployeeFormState {}

final class EmployeeFormInforInitial extends EmployeeFormState {
  final Employee newEmployee;
  const EmployeeFormInforInitial({required this.newEmployee});
}

final class EmployeeFormInforLoading extends EmployeeFormState {}

final class EmployeeFormInforSuccess extends EmployeeFormState {
  final Employee employee;
  const EmployeeFormInforSuccess({required this.employee});

  @override
  List<Object> get props => [employee];
}

final class EmployeeFormError extends EmployeeFormState {
  final String message;
  EmployeeFormError({required this.message});

  @override
  List<Object> get props => [message];
}

final class EmployeeAccountCreatedLoading extends EmployeeFormState {}
