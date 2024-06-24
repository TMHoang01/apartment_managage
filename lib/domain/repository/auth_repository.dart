import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartment_managage/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();
  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
  Future<void> signUp({required String email, required String password});
  Future<void> saveUserToFirestore(
      String name, User user, String email, String country);

  Future<void> updateInforUser(UserModel user);
}
