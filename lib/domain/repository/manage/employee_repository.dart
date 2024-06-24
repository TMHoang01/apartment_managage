import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apartment_managage/data/datasources/manage/employee_remote.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/utils/exception/customer_exception.dart';

abstract class EmployeeRepository {
  Future<void> addEmployee(Employee employee);
  Future<void> deleteEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<List<Employee>> getAllEmployees({String? last, int? limit});
  Future<Employee?> createdAccountEmployee({required email, required password});
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource employeeRemoteDataSource;

  EmployeeRepositoryImpl(this.employeeRemoteDataSource);

  @override
  Future<Employee?> createdAccountEmployee(
      {required email, required password}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      Employee employee = Employee(
        id: user!.uid,
        username: user.displayName ?? user.email!.split('@').first,
        phone: user.phoneNumber ?? '',
        avatar: user.photoURL ?? '',
        email: email,
        roles: Role.employee,
        status: StatusUser.pending,
        defaultPassword: password,
        createdAt: DateTime.now(),
      );
      await employeeRemoteDataSource.addEmployee(employee);
      return employee;
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      await app.delete();
    }
  }

  @override
  Future<void> addEmployee(Employee employee) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEmployee(Employee employee) async {
    // TODO: implement deleteEmployee
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> getAllEmployees({String? last, int? limit}) async {
    return await employeeRemoteDataSource.getAllEmployees();
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    return await employeeRemoteDataSource.updateEmployee(employee);
  }
}
