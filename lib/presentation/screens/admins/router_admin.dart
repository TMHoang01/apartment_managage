import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/a_features/posts/blocs/post_form/post_form_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/dashboard/dash_board.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/post_list_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/employee/employee_create_account_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/employee/employee_detail_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/employee/employee_list_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/employee/employee_select_screen.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/screens/feed_back_detail_screen.dart';
import 'package:apartment_managage/presentation/a_features/feed_back/screens/feed_back_list_screen.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/post_create_screen.dart';
import 'package:apartment_managage/presentation/a_features/posts/screens/post_detail_screen.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/form/product_detail_form.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/product_detail.dart';
import 'package:apartment_managage/presentation/a_features/product/screens/products_screen.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/service_booking/service_booking_detail_screen.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/service_booking/service_booking_list_screen.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/services/service_details_screen.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/services/service_form_screen.dart';
import 'package:apartment_managage/presentation/a_features/service/screens/services/service_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/users/user_details_screen.dart';
import 'package:apartment_managage/presentation/screens/admins/users/users_screen.dart';
import 'package:apartment_managage/router.dart';

class RouterAdmin extends AppRouter {
  static const String initialRoute = dashboard;
  static const String splash = '/splash';
  static const String dashboard = '/admin/dashboard';
  static const String products = '/admin/product/list';
  static const String productDetail = '/admin/product/detail';
  static const String productEdit = '/admin/product/edit';
  static const String productAdd = '/admin/product/add';

  static const String post = '/admin/post';
  static const String postDetail = '/admin/post/detail';
  static const String postEdit = '/admin/post/edit';
  static const String postAdd = '/admin/post/add';
  static const String oderDetail = '/admin/order';

  static const String users = '/admin/user/list';
  static const String userDetail = '/admin/user/detail';
  // services
  static const String services = '/admin/service';
  static const String serviceDetail = '/service/detail';
  static const String serviceEdit = '/admin/service/edit';
  static const String serviceAdd = '/admin/service/add';
  //booking
  static const String bookings = '/admin/booking/list';
  static const String bookingDetail = '/admin/booking/detail';

  // feedback
  static const String feedback = '/admin/feedback';
  static const String feedbackDetail = '/admin/feedback/detail';
  // employ select user
  static const String employSelect = '/admin/employ/select_user';
  static const String employDetail = '/admin/employ/detail';
  static const String employEdit = '/admin/employ/edit';
  static const String employAdd = '/admin/employ/add';
  static const String employList = '/admin/employ/list';

  // settings
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    // home: (BuildContext context) => BottomAppBar()
    ...AppRouter.routes,
    dashboard: (context) => const DashBoarAdmindScreen(),
    products: (context) => const ManageProductsScreen(),
    productAdd: (context) => const ProductFormDetail(),
    post: (context) => const PostListScreen(),
    users: (context) => const UsersScreen(),
    services: (context) => const ServicesScreen(),
    bookings: (context) => const ServiceBookingListScreen(),
    feedback: (context) => const FeedBackListScreen(),
    employList: (context) => const EmployeeListScreen(),
    employAdd: (context) => const EmployeeCreateAccountScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case productDetail:
        return MaterialPageRoute(
          builder: (context) =>
              AdminProductDetail(product: args as ProductModel),
        );
      case productEdit:
        return MaterialPageRoute(
          builder: (context) =>
              ProductFormDetail(product: args as ProductModel),
        );
      // post
      case postAdd:
        return MaterialPageRoute(
          builder: (context) => PostCreateScreen(bloc: args as PostFormBloc),
        );
      case postDetail:
        return MaterialPageRoute(
          builder: (context) => PostDetailScreen(post: args as PostModel),
        );

      case userDetail:
        return MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: args as UserModel),
        );
      // services
      case serviceAdd:
        return MaterialPageRoute(
          builder: (context) => const ServiceFormScreen(),
        );
      case serviceEdit:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceFormScreen(service: args as ServiceModel),
        );
      case serviceDetail:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceDetailScreen(service: args as ServiceModel),
        );
      // booking
      case bookingDetail:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceBookingDetailScreen(booking: args as BookingService),
        );
      // feedback
      case feedbackDetail:
        return MaterialPageRoute(
          builder: (context) =>
              FeedBackDetailScreen(feedBack: args as FeedBackModel),
        );

      // manage employee
      case employSelect:
        return MaterialPageRoute(
          builder: (context) => EmployeeSelectScreen(
            employees: args as List<Employee>,
          ),
        );
      case employDetail:
        return MaterialPageRoute(
          builder: (context) => EmployeeDetailScreen(
            employee: args as Employee,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoarAdmindScreen(),
        );
    }
  }
}
