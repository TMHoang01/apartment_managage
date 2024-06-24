import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';
import 'package:apartment_managage/utils/firebase.dart';

class UserRemote {
  UserRemote();

  Future<UserModel> getUser(String userId) async {
    try {
      final user = await usersRef.doc(userId).get();
      return UserModel.fromDocumentSnapshot(user);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<UserModel>> getUserPending() async {
    try {
      final roles = [
        Role.provider.toJson(),
        Role.resident.toJson(),
        Role.user.toJson()
      ];
      // roles not null or have field roles
      final users = await usersRef
          .where('roles', whereIn: roles)
          .where('status', isEqualTo: StatusUser.pending.toJson())
          .get();
      return users.docs.map((e) => UserModel.fromDocumentSnapshot(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateStatus(String userId, String status) async {
    try {
      await usersRef.doc(userId).update({'status': status});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> swtichLockAccount(String userId, bool isLock) async {
    try {
      await usersRef.doc(userId).update({'isLock': isLock});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<UserModel>> getUsersQuery(UsersQuery query) async {
    try {
      final db = FirebaseFirestore.instance;
      Query queryRef =
          db.collection('users'); // Replace 'users' with your collection name

      // Apply search filter
      if (query.search != null) {
        queryRef = queryRef
            .where('name', isGreaterThanOrEqualTo: query.search)
            .where('name',
                isLessThanOrEqualTo: query
                    .search); // Search by name starting with the query string
      }

      // Apply status filter
      if (query.status != null) {
        queryRef = queryRef.where('status', isEqualTo: query.status);
      }

      // Apply sorting
      if (query.sort != null) {
        queryRef = queryRef.orderBy(query.sort as Object,
            descending: query.order == 'desc');
      }

      // Apply pagination
      if (query.page != null && query.pageSize != null) {
        queryRef = queryRef.limit(query.pageSize!).startAfter([query.lastId]);
      }

      final snapshot = await queryRef.get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
      return users;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<UserModel>> getListNotInIds(List<String> ids) async {
    try {
      final users = await usersRef.where('id', whereNotIn: ids).get();
      return users.docs.map((e) => UserModel.fromDocumentSnapshot(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
