class Validators {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập email của bạn';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // validate password
  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    if (value != password) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại của bạn';
    }
    if (!RegExp(r'^(\+84|0)+([0-9]{9,10})$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  // validate date
  static String? validateDateTime(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng chọn ngày sinh của bạn';
    }
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }
    return null;
  }

  // validate name
  static String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập tên của bạn';
    }
    return null;
  }

  // validate empty
  static String? validateEmpty(String? value, {String? message}) {
    if (value!.isEmpty) {
      return message ?? 'Vui lòng nhập thông tin';
    }
    return null;
  }
}
