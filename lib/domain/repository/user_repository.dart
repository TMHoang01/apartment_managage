import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getUserPending();
  Future<List<UserModel>> getListUsers(String type);
  Future<void> updateStatus(String userId, String status);

  Future<List<UserModel>> getListNotInClude(List<String> ids);
}
