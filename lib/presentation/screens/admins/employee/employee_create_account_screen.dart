import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/employee/employee_detail_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class EmployeeCreateAccountScreen extends StatefulWidget {
  const EmployeeCreateAccountScreen({super.key});

  @override
  State<EmployeeCreateAccountScreen> createState() =>
      _EmployeeCreateAccountScreenState();
}

class _EmployeeCreateAccountScreenState
    extends State<EmployeeCreateAccountScreen> {
  final emailController = TextEditingController(text: '1@gmail.com ');
  final passwordController = TextEditingController(text: '123456');
  final confirmPasswordController = TextEditingController(text: '123456');
  final keyForm = GlobalKey<FormState>();
  // final tabController = TabController(length: 2, vsync: null);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
      listener: (context, state) {
        if (state is EmployeeFormError) {
          showSnackBarError(context, state.message);
        } else if (state is EmployeeFormInforInitial) {
          // pop end push
          navService.popAndPushNamed(context, RouterAdmin.employDetail,
              args: state.newEmployee);
          showSnackBarSuccess(context, 'Tạo tài khoản thành công');
        }
      },
      buildWhen: (previous, current) {
        return previous != current;
      },
      builder: (context, state) {
        Widget child = buildState(context, state);
        return child;
      },
    );
  }

  Widget buildState(BuildContext context, EmployeeFormState state) {
    return switch (state) {
      EmployeeAccountCreatedLoading() => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      // EmployeeFormInforInitial() => _buildFormUpdateEmployee(context),
      _ => Scaffold(
          appBar: AppBar(
            title: const Text('Tạo tài khoản nhân viên'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: _buildInit(state),
          ),
        ),
    };
  }

  Widget _buildInit(EmployeeFormState state) {
    Widget inputEmail = CustomTextFormField(
        controller: emailController,
        hintText: 'Email',
        validator: (value) => Validators.validateEmail(value!));

    Widget inputPassword = CustomTextFormField(
      controller: passwordController,
      hintText: 'Mật khẩu',
      validator: (value) => Validators.validatePassword(value!),
    );

    Widget inputConfirmPassword = CustomTextFormField(
      controller: confirmPasswordController,
      hintText: 'Nhập lại mật khẩu',
      validator: (value) =>
          Validators.validateConfirmPassword(value!, passwordController.text),
    );

    return Form(
      key: keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$state'),
          inputEmail,
          const SizedBox(height: 10),
          inputPassword,
          const SizedBox(height: 10),
          inputConfirmPassword,
          const SizedBox(height: 10),
          Center(
            child: BlocBuilder<EmployeeFormBloc, EmployeeFormState>(
              builder: (context, state) {
                final isLoading = state is EmployeeAccountCreatedLoading;
                return CustomButton(
                  onPressed: () {
                    if (isLoading) return;
                    if (keyForm.currentState!.validate()) {
                      context.read<EmployeeFormBloc>().add(
                          EmployeeAccountCreated(
                              email: emailController.text,
                              password: passwordController.text));
                    } else {
                      showSnackBarError(
                          context, 'Vui lòng kiểm tra lại thông tin');
                    }
                  },
                  title: 'Tạo tài khoản',
                  prefixWidget: isLoading
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormUpdateEmployee(BuildContext context) {
    return EmployeeDetailScreen(employee: Employee());
  }
}
