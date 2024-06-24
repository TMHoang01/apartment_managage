import 'package:apartment_managage/bloc_observer.dart';
import 'package:apartment_managage/data/datasources/auth_remote.dart';
import 'package:apartment_managage/data/datasources/ecom/category_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/order_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/product_repository.dart';
import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:apartment_managage/domain/repository/service/service_repository.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';
import 'package:apartment_managage/firebase_options.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/parking/parking_bloc.dart';
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
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();

  await geFireBaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // RepositoryProvider(create: (_) => sl<AuthFirebase>()),
        // RepositoryProvider(create: (_) => sl<OrderRepository>()),
        // RepositoryProvider(create: (_) => sl<ProductRepository>()),
        // RepositoryProvider(create: (_) => sl<CategoryRemote>()),
        // RepositoryProvider(create: (_) => sl<UserRepository>()),
        // RepositoryProvider(create: (_) => sl<FileRepository>()),
        RepositoryProvider(create: (_) => sl<ServiceRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<AuthBloc>()..add(CheckAuthRequested()),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => sl<ManageProductBloc>(),
                  ),
                  BlocProvider(
                    create: (_) => sl<CategoryBloc>(),
                  ),
                  BlocProvider(
                      create: (_) => sl.get<PostsBloc>()..add(PostsStarted())),
                  BlocProvider(
                      create: (_) => sl<UsersBloc>()..add(UsersGetAllUsers())),
                  BlocProvider(
                      create: (_) =>
                          sl<ServicesBloc>()..add(ServicesStarted())),
                  BlocProvider(
                      create: (_) =>
                          sl<FeedBacksBloc>()..add(FeedBacksStarted())),
                  BlocProvider(create: (_) => sl<EmployeeFormBloc>()),
                  BlocProvider(create: (_) => sl<EmployeesBloc>()),
                  BlocProvider(create: (_) => sl<ServiceBookingBloc>()),

                  // pảking
                  BlocProvider(create: (_) => sl<ManageVehicleTicketBloc>()),
                  BlocProvider(create: (_) => sl<ParkingBloc>()),
                ],
                child: MyMaterialApp(
                  initialRoute: AppRouter.dashboard,
                  routes: AppRouter.routes,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                ),
              );
            }
            return MyMaterialApp(
              initialRoute: AppRouter.splash,
              routes: AppRouter.routes,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;
  final dynamic onGenerateRoute;
  const MyMaterialApp({
    super.key,
    required this.initialRoute,
    required this.routes,
    this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý chung cư',
      locale: const Locale('vi', 'VN'),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kOfWhite,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      initialRoute: initialRoute,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
