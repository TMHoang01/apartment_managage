import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<EmployeesBloc>();
    if (bloc.state is EmployeesInitial) {
      bloc.add(EmployeesFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách nhân viên'),
      ),
      body: BlocProvider(
        create: (_) => sl.get<EmployeesBloc>()..add(EmployeesFetch()),
        child: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            return _buildState(state);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        onPressed: () {
          navService.pushNamed(context, RouterAdmin.employAdd);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildState(EmployeesState state) {
    if (state is EmployeesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is EmployeesLoaded) {
      return ListView.builder(
        itemCount: state.employees.length,
        itemBuilder: (context, index) {
          final employee = state.employees[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text(
                employee.username != null && employee.username!.isNotEmpty
                    ? employee.username![0].toUpperCase()
                    : '',
                style: const TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(employee.username ?? ''),
                const SizedBox(width: 4),
                Text(
                  employee.roles == Role.admin
                      ? 'Quản trị viên'
                      : employee.position?.name ?? 'Nhân viên',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            subtitle: Text(employee.email ?? ''),
            onTap: () {
              navService.pushNamed(context, RouterAdmin.employDetail,
                  args: employee);
            },
          );
        },
      );
    } else if (state is EmployeesError) {
      return Center(
        child: Text(state.message),
      );
    }
    return const SizedBox();
  }
}
