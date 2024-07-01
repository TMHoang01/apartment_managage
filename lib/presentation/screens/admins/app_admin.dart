import 'package:apartment_managage/presentation/blocs/admins/users_approve/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/main.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/category/category_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_backs/feed_backs_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts/posts_bloc.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/products/product_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/services/services_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';
import 'package:apartment_managage/presentation/blocs/auth/auth/auth_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/sl.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ManageProductBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(GetCategoriesEvent()),
        ),
        BlocProvider(create: (context) => sl<PostsBloc>()..add(PostsStarted())),
        BlocProvider(create: (_) => sl<UsersBloc>()),
        BlocProvider(create: (_) => sl<ServicesBloc>()..add(ServicesStarted())),
        BlocProvider(
            create: (_) => sl<FeedBacksBloc>()..add(FeedBacksStarted())),
        BlocProvider(
          create: (_) => sl<EmployeeFormBloc>(),
        ),
        BlocProvider(create: (_) => sl<EmployeesBloc>()),
        BlocProvider(create: (_) => sl<ServiceBookingBloc>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // sl<CategoryBloc>().add(GetCategoriesEvent());
          return MyMaterialApp(
            initialRoute: RouterAdmin.initialRoute,
            routes: RouterAdmin.routes,
            onGenerateRoute: RouterAdmin.onGenerateRoute,
          );
        },
      ),
    );
  }
}
