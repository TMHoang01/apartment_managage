import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/sl.dart';

abstract class EmployeeRemoteDataSource {
  Future<void> addEmployee(Employee employee);
  Future<void> deleteEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<List<Employee>> getAllEmployees({String? last, int? limit});
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final db = sl.get<FirebaseFirestore>();
  late final CollectionReference employeeCollection = db.collection('users');
  @override
  Future<void> addEmployee(Employee employee) async {
    try {
      if (employee.id != null && employee.id!.isNotEmpty) {
        // check Id in collection thorw error if not found esle create new
        final doc = await employeeCollection.doc(employee.id).get();
        if (doc.exists) {
          throw Exception('Mã nhân viên đã tồn tại');
        } else {
          await employeeCollection.doc(employee.id).set(employee.toJson());
        }
      } else {
        employeeCollection.add(employee.toJson());
      }
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteEmployee(Employee employee) {
    // TODO: implement deleteEmployee
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> getAllEmployees(
      {String? last, int? limit = 15}) async {
    limit = limit ?? 15;
    List<Employee> employees = [];
    try {
      final arrIn = [Role.employee.toJson(), Role.admin.toJson()];
      final query = employeeCollection.where('roles', whereIn: arrIn);
      if (last != null) {
        query.startAfter([last]);
      }
      query.orderBy('createdAt', descending: false);
      query.limit(limit);

      employees = await query.get().then((value) {
        return value.docs.map((e) {
          return Employee.fromSnapshot(e);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
    return employees;
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    try {
      if (employee.id != null && employee.id!.isNotEmpty) {
        await employeeCollection.doc(employee.id).update(employee.toJson());
      } else {
        throw Exception('Lỗi không tìm thấy mã nhân viên');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
