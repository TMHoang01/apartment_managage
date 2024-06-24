import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/repository/manage/employee_repository.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeeRepository employeeRepository;
  EmployeesBloc(this.employeeRepository) : super(EmployeesInitial()) {
    on<EmployeesEvent>((event, emit) {});
    on<EmployeesFetch>(_onEmployeesFetch);
    on<EmployeesEditLocal>(_onEmployeesEditLocal);
  }

  void _onEmployeesFetch(EmployeesFetch event, Emitter emit) async {
    emit(EmployeesLoading());
    try {
      final employees = await employeeRepository.getAllEmployees();
      emit(EmployeesLoaded(employees: employees));
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }

  void _onEmployeesEditLocal(EmployeesEditLocal event, Emitter emit) {
    if (state is EmployeesLoaded) {
      final employees = (state as EmployeesLoaded)
          .employees
          .map((e) => e.id == event.employee.id ? event.employee : e)
          .toList();
      emit(EmployeesLoaded(employees: employees));
    }
  }
}
