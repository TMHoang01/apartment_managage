import 'package:apartment_managage/data/datasources/auth_remote.dart';
import 'package:apartment_managage/data/datasources/ecom/category_repository.dart';
import 'package:apartment_managage/data/datasources/ecom/order_remote.dart';
import 'package:apartment_managage/data/datasources/ecom/post_remote.dart';
import 'package:apartment_managage/data/datasources/ecom/product_repository.dart';
import 'package:apartment_managage/data/datasources/feed_back/feed_back_remote.dart';
import 'package:apartment_managage/data/datasources/file_store.dart';
import 'package:apartment_managage/data/datasources/manage/employee_remote.dart';
import 'package:apartment_managage/data/datasources/service/booking_service_remote.dart';
import 'package:apartment_managage/data/datasources/service/service_remote.dart';
import 'package:apartment_managage/data/datasources/user_remote.dart';
import 'package:apartment_managage/data/repository/auth_repository.dart';
import 'package:apartment_managage/data/repository/ecom/category_repository.dart';
import 'package:apartment_managage/data/repository/ecom/order_repository.dart';
import 'package:apartment_managage/data/repository/ecom/product_repository.dart';
import 'package:apartment_managage/data/repository/post/post_repository.dart';
import 'package:apartment_managage/data/repository/user_repository.dart';
import 'package:apartment_managage/domain/repository/auth_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/category_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/order_repository.dart';
import 'package:apartment_managage/domain/repository/ecom/product_repository.dart';
import 'package:apartment_managage/domain/repository/feed_back/feed_back_repository.dart';
import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:apartment_managage/domain/repository/manage/employee_repository.dart';
import 'package:apartment_managage/domain/repository/post/post_repository.dart';
import 'package:apartment_managage/domain/repository/service/booking_repository.dart';
import 'package:apartment_managage/domain/repository/service/service_repository.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/parking/parking_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/data/parking_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/data/vehicle_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/paking_lot_repository.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/vehicle_repository.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/category/category_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_back_detail/feed_back_detail_bloc.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/blocs/feed_backs/feed_backs_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_detail/post_detail_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/posts/posts_bloc.dart';
import 'package:apartment_managage/presentation/a_features/product/blocs/products/product_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_form/service_form_bloc.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/services/services_bloc.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';
import 'package:apartment_managage/presentation/blocs/auth/auth/auth_bloc.dart';
import 'package:apartment_managage/presentation/blocs/auth/signin/signin_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<FileRepository>(() => FileStoreIml());

  sl.registerLazySingleton<CategoryRemote>(() => CategoryRemote());
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryIml(sl.call()));
  sl.registerFactory<CategoryBloc>(
      () => CategoryBloc(categoryRepository: sl.call()));

  sl.registerLazySingleton<ProductRemote>(() => ProductRemote());
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryIml(sl.call()));
  sl.registerLazySingleton<OrderRemote>(() => OrderRemote());
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryIml(sl.call()));

  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl());
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl.call()));

  sl.registerLazySingleton<UserRemote>(() => UserRemote());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryIml(sl.call()));
  sl.registerFactory<UsersBloc>(() => UsersBloc(sl.call()));

  sl.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl());
  sl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(sl.call()));
  sl.registerFactory<ServicesBloc>(() => ServicesBloc(sl.call()));
  sl.registerFactory<ServiceFormBloc>(
      () => ServiceFormBloc(sl.call(), sl.call()));

  // service
  sl.registerLazySingleton<BookingServiceRemoteDataSource>(
      () => BookingServiceRemoteDataSourceImpl());
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryIml(sl.call()));

  // feed back
  sl.registerLazySingleton<FeedBackRemoteDataSource>(
      () => FeedBackRemoteDataSourceImpl());
  sl.registerLazySingleton<FeedBackRepository>(
      () => FeedBackRepositoryImpl(sl.call()));

  _initAuth();
  _initAdmin();
}

void _initAdmin() {
  sl.registerFactory<ManageProductBloc>(() => ManageProductBloc(
      productRepository: sl.call(), fileRepository: sl.call()));

  //post
  sl.registerFactory<PostsBloc>(() => PostsBloc(sl.call()));
  sl.registerFactory<PostFormBloc>(
    () => PostFormBloc(postRepository: sl.call(), fileRepository: sl.call()),
  );
  sl.registerFactory<PostDetailBloc>(
    () => PostDetailBloc(sl.call(), sl.call()),
  );
  // feed back
  sl.registerFactory<FeedBacksBloc>(() => FeedBacksBloc(sl.call()));
  sl.registerFactory<FeedBackDetailBloc>(
    () => FeedBackDetailBloc(sl.call()),
  );

  // manage user
  sl.registerFactory<EmployeeRemoteDataSource>(
      () => EmployeeRemoteDataSourceImpl());
  sl.registerFactory<EmployeeRepository>(
      () => EmployeeRepositoryImpl(sl.call()));
  sl.registerFactory<EmployeesBloc>(() => EmployeesBloc(sl.call()));
  sl.registerFactory<EmployeeFormBloc>(() => EmployeeFormBloc(sl.call()));

  // booking service
  sl.registerFactory<ServiceBookingBloc>(() => ServiceBookingBloc(sl.call()));
}

void _initAuth() {
  sl.registerLazySingleton<AuthFirebase>(() => AuthFirebase());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryIml(sl.call()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl.call()));
  sl.registerLazySingleton<SigninCubit>(() => SigninCubit());

  // sl.registerFactory<UserInforBloc>(() => UserInforBloc(sl.call(), sl.call()));

  // parking
  sl.registerLazySingleton<ParkingRemoteDataSource>(
    () => ParkingRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ParkingLotRepository>(
    () => ParkingLotRepositoryImpl(sl.call()),
  );
  sl.registerLazySingleton<VehicleRemoteDataSource>(
    () => VehicleRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(sl.call()),
  );
  sl.registerFactory<ManageVehicleTicketBloc>(
      () => ManageVehicleTicketBloc(sl.call()));
  sl.registerFactory<ParkingBloc>(() => ParkingBloc(sl.call()));
}
