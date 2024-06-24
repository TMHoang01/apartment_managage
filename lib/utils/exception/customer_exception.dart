import 'package:firebase_auth/firebase_auth.dart';

void handleFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      throw Exception('Không tìm thấy tài khoản.');
    case 'wrong-password':
      throw Exception('Sai mật khẩu.');
    case 'invalid-email':
      throw Exception('Email không hợp lệ.');
    case 'user-disabled':
      throw Exception('Tài khoản đã bị vô hiệu hóa.');
    case 'too-many-requests':
      throw Exception('Quá nhiều yêu cầu.');
    case 'operation-not-allowed':
      throw Exception('Không thể thực hiện thao tác này.');
    case 'email-already-in-use':
      throw Exception('Email đã được sử dụng.');
    default:
      throw Exception(e.message ?? 'Đã xảy ra lỗi.');
  }
}
