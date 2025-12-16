enum UserRole {
  guest,      // Khách (chưa đăng nhập)
  customer,   // Khách hàng (đã đăng nhập)
  admin,      // Quản trị viên
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.guest:
        return 'Khách';
      case UserRole.customer:
        return 'Khách hàng';
      case UserRole.admin:
        return 'Quản trị viên';
    }
  }

  String get value {
    switch (this) {
      case UserRole.guest:
        return 'guest';
      case UserRole.customer:
        return 'customer';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'guest':
        return UserRole.guest;
      case 'customer':
        return UserRole.customer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.guest;
    }
  }
}
