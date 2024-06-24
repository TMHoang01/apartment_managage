import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/utils.dart';

class EmployeeSelectScreen extends StatefulWidget {
  final List<Employee> employees;
  const EmployeeSelectScreen({super.key, required this.employees});

  @override
  State<EmployeeSelectScreen> createState() => _EmployeeSelectScreenState();
}

class _EmployeeSelectScreenState extends State<EmployeeSelectScreen> {
  List<String> selectedEmployeesId = [];
  List<Employee> selectedEmployees = [];
  @override
  void initState() {
    selectedEmployees = widget.employees.toList();

    selectedEmployeesId = selectedEmployees
        .map((e) => e.id ?? '')
        .where((element) => element.isNotEmpty)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      bloc: sl.get<EmployeesBloc>()..add(EmployeesFetch()),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách người dùng'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is EmployeesLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (state is EmployeesLoaded)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.employees.length,
                    itemBuilder: (context, index) {
                      if (state.employees.isEmpty) {
                        return const Center(
                          child: Text('Không có dữ liệu'),
                        );
                      }
                      final user = state.employees[index];
                      return StatefulBuilder(builder: (context, setSate) {
                        return EmployeeTitle(
                          user: user,
                          isSelected: selectedEmployeesId.contains(user.id),
                          onChanged: (value) {
                            logger.d('value: $value');
                            setSate(
                              () {
                                if (value == true) {
                                  selectedEmployeesId.add(user.id ?? '');
                                  selectedEmployees.add(user);
                                } else {
                                  selectedEmployeesId.remove(user.id);
                                  selectedEmployees.removeWhere(
                                      (element) => element.id == user.id);
                                }
                              },
                            );
                          },
                        );
                      });
                    },
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Navigator.pop(context, selectedEmployees);
            },
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
              semanticLabel: 'Chọn',
            ),
          ),
        );
      },
    );
  }
}

class EmployeeTitle extends StatelessWidget {
  final Employee user;
  final Function(bool?) onChanged;
  final bool isSelected;
  const EmployeeTitle(
      {super.key,
      required this.user,
      required this.onChanged,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String name = user.username != null && user.username!.isNotEmpty
        ? user.username![0]
        : '';

    Widget secondary = CircleAvatar(
      radius: 24,
      child: Text(name.toUpperCase()),
    );

    if (user.avatar != null && user.avatar!.isNotEmpty) {
      secondary = CustomImageView(
        borderRadius: BorderRadius.circular(40),
        url: user.avatar,
        width: 50,
        height: 50,
      );
    }
    return CheckboxListTile(
      // controlAffinity: ListTileControlAffinity.leading,
      activeColor: kSecondaryColor,
      value: isSelected,
      onChanged: onChanged,
      title: Text('${user.username} '),
      subtitle: Text('${user.position?.name} '),
      secondary: secondary,
    );

    return ListBody(
      children: [
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: CustomImageView(
              borderRadius: BorderRadius.circular(40),
              url: user.avatar,
              width: 50,
              height: 50,
            ),
            title: Text('${user.username} '),
            subtitle: Text('${user.position?.name} '),
          ),
        ),
      ],
    );
  }
}
