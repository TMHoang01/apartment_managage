import 'package:apartment_managage/presentation/blocs/auth/auth/auth_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated || state is AuthError) {
          navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
        } else if (state is Authenticated) {
          navService.pushNamedAndRemoveUntil(context, AppRouter.feedback);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     kPrimaryColor,
            //     kSecondaryLightColor,
            //     kPrimaryLightColor,
            //   ],
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: 'assets/images/logo.png',
                height: 200.0,
              ),
              const Center(
                child: Text(
                  'Quản lý chung cư',
                  style: TextStyle(
                    fontSize: 24.0,
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
