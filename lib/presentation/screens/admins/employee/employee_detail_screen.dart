import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/models/manage/position.dart';
import 'package:apartment_managage/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final formKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  final brithDay = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final postion = TextEditingController();
  Position? _positionController;
  @override
  void initState() {
    super.initState();
    userName.text = widget.employee.username ?? '';
    brithDay.text = TextFormat.formatDate(widget.employee.birthDay);
    phone.text = widget.employee.phone ?? '';
    address.text = widget.employee.address ?? '';
    postion.text = widget.employee.position?.name ?? '';
    _positionController = widget.employee.position;
  }

  @override
  void dispose() {
    userName.dispose();
    brithDay.dispose();
    phone.dispose();
    address.dispose();
    postion.dispose();
    super.dispose();
  }

  static const Sizebox = SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
      listener: (context, state) {
        if (state is EmployeeFormInforSuccess) {
          showSnackBarSuccess(context, 'Cập nhập thông tin thành công');
          // context.read<EmployeesBloc>().add(EmployeesEditLocal(state.employee));
        } else if (state is EmployeeFormError) {
          showSnackBarError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Thông tin nhân viên'),
          ),
          body: _buildState(context, state),
        );
      },
    );
  }

  Widget _buildState(BuildContext context, EmployeeFormState state) {
    return switch (state) {
      EmployeeFormInforLoading() => Stack(
          children: [
            _formInit(context, state),
            Container(
              color: Colors.white70,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      _ => _formInit(context, state),
    };
  }

  SingleChildScrollView _formInit(
      BuildContext context, EmployeeFormState state) {
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('  Sơ yếu lý lịch', style: theme.textTheme.titleMedium),
              Sizebox,
              CustomTextFormField(
                controller: userName,
                hintText: 'Tên nhân viên',
                validator: (value) => Validators.validateName(value),
              ),
              Sizebox,
              PickerDateInput(
                context,
                title: 'Ngày sinh',
                controller: brithDay,
                onDateSelected: (date) {
                  brithDay.text = TextFormat.formatDate(date);
                },
              ),
              Sizebox,
              CustomTextFormField(
                controller: phone,
                hintText: 'Số điện thoại',
                textInputType: TextInputType.phone,
                validator: (value) => Validators.validateEmpty(value),
              ),
              Sizebox,
              CustomTextFormField(
                controller: address,
                hintText: 'Địa chỉ',
                validator: (value) => Validators.validateEmpty(value,
                    message: 'Vui lòng nhập địa chỉ'),
              ),
              Sizebox,
              CustomTextFormField(
                controller: postion,
                hintText: 'Chức vụ',
              ),
              Sizebox,
              if (state is EmployeeFormError)
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              Sizebox,
              Text('  Vị trí', style: theme.textTheme.titleMedium),
              Sizebox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField<Position>(
                  decoration: const InputDecoration(
                    labelText: 'Chọn chức vụ',
                  ),
                  iconSize: 20,
                  hint: const Text('Chọn chức vụ'),
                  value: _positionController,
                  validator: (value) =>
                      value == null ? 'Vui lòng chọn chức vụ' : null,
                  items: listPosition
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(' ${e.name}'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _positionController = value;
                  },
                ),
              ),
              Sizebox,
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final employee = Employee(
                      id: widget.employee.id,
                      username: userName.text,
                      birthDay: TextFormat.parseJson(brithDay.text),
                      phone: phone.text,
                      address: address.text,
                      position: _positionController,
                      status: widget.employee.status,
                    );
                    context.read<EmployeeFormBloc>().add(
                          EmployeeUpdatedInforSubmit(
                            employee: employee,
                          ),
                        );
                  }
                },
                title: 'Cập nhập',
              ),
              Sizebox,
            ],
          ),
        ),
      ),
    );
  }
}
