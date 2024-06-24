import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:apartment_managage/presentation/blocs/auth/auth/auth_bloc.dart';
import 'package:apartment_managage/presentation/blocs/auth/signin/signin_cubit.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/app_styles.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:apartment_managage/utils/vadidate/email.dart';
import 'package:apartment_managage/utils/vadidate/password.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(),
      // create: (context) => SigninCubit(context.read<AuthRepository>()),
      child: const SignInScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final authState = context.watch<AuthBloc>().state;
    late final _emailController = TextEditingController(
        text: switch (authState) {
      AuthLoginPrefilled(email: final email) => email,
      _ => '',
    });
    late final _passwordController = TextEditingController(
        text: switch (authState) {
      AuthLoginPrefilled(password: final password) => password,
      _ => '',
    });

    return BlocProvider(
      create: (context) => SigninCubit(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: _buildAppBar(context),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // navService.pushNamedAndRemoveUntil(
                //     context, RouterClient.dashboard);
              } else if (state is AuthError) {
                showSnackBar(context, state.error, Colors.red);
              }
            },
            builder: (context, state) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.9,
                child: const Column(
                  children: [
                    Spacer(),
                    FormLogin(),
                    Spacer(flex: 2),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
}

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SizedBox(
        width: double.maxFinite,
        // padding:
        //     const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // build avatar
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 40),
                child: CustomImageView(
                  imagePath: ImageConstant.imgLogo,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            _builderFormFieldEmail(),
            const SizedBox(height: 10),
            _builderFormFieldPassword(),
            const SizedBox(height: 10),
            BlocListener<SigninCubit, SigninState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == FormzSubmissionStatus.inProgress) {
                  showSnackBar(
                      context, 'Vui lòng điền đủ thông tin', Colors.red);
                }
                if (state.status == FormzSubmissionStatus.failure) {}
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    bool isLoading = (state is AuthLoginLoading);

                    return CustomButton(
                      title: "Đăng nhập",
                      margin: const EdgeInsets.only(left: 1, top: 10),
                      prefixWidget: isLoading
                          ? Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            )
                          : null,
                      onPressed: () {
                        if (isLoading) return;
                        FocusScope.of(context).unfocus();
                        final cubitLogin = context.read<SigninCubit>();
                        cubitLogin.checkValidation();
                        if (cubitLogin.state.isValid) {
                          context.read<AuthBloc>().add(
                                SignInRequested(cubitLogin.state.email.value,
                                    cubitLogin.state.password.value),
                              );
                        } else {
                          logger.i('Form login chưa chuẩn');
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builderFormFieldEmail() {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextFormField(
          hintText: "Email",
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.emailAddress,
          errorText: state.email.error == EmailValidationError.invalid
              ? 'Email không hợp lệ'
              : null,
          isObscureText: false,
          onChanged: (value) {
            context.read<SigninCubit>().emailChanged(value);
          },
        );
      },
    );
  }

  Widget _builderFormFieldPassword() {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isShowPassword != current.isShowPassword,
      builder: (context, state) {
        return CustomTextFormField(
          hintText: "Mật khẩu",
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          isObscureText: !state.isShowPassword,
          onFieldSubmitted: (_) {
            print('submit complete password');
          },
          errorText: state.password.error == PasswordValidationError.invalid
              ? 'Mật khẩu không hợp lệ'
              : null,
          suffix: InkWell(
            onTap: () {
              context.read<SigninCubit>().togglePasswordVisibility();
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              child: CustomImageView(
                svgPath: context.read<SigninCubit>().state.isShowPassword
                    ? ImageConstant.iconEyeSlash
                    : ImageConstant.iconEye,
              ),
            ),
          ),
          suffixConstraints: const BoxConstraints(maxHeight: (40)),
          onChanged: (value) {
            context.read<SigninCubit>().passwordChanged(value);
          },
        );
      },
    );
  }
}
