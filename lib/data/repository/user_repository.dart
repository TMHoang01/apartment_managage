import 'package:apartment_managage/data/datasources/user_remote.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';

class UserRepositoryIml implements UserRepository {
  UserRemote _userRemote;

  UserRepositoryIml(UserRemote userRemote) : _userRemote = userRemote;

  @override
  Future<UserModel> getUserById(String id) async {
    return _userRemote.getUserById(id);
  }

  @override
  Future<List<UserModel>> getUserPending() async {
    return _userRemote.getUserPending();
  }

  @override
  Future<void> updateStatus(String userId, String status) async {
    return _userRemote.updateStatus(userId, status);
  }

  @override
  Future<List<UserModel>> getListNotInClude(List<String> ids) async {
    return _userRemote.getListNotInIds(ids);
  }

  @override
  Future<List<UserModel>> getListUsers(String? type) async {
    return _userRemote.getListUsers(type);
  }
}
