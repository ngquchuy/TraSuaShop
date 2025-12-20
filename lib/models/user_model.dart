class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String role;
  final String? token;
  final String phone;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    this.token,
    this.phone = '',
  });

  // Factory để chuyển đổi từ JSON (Server trả về) sang Object Dart
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['FullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
      token: json['token'],
      phone: json['phone'] ?? '',
    );
  }

  // Chuyển Object ngược lại thành JSON (nếu cần lưu xuống local storage)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'FullName': fullName,
      'email': email,
      'role': role,
      'token': token,
      'phone': phone,
    };
  }

  // Helper check quyền nhanh
  bool get isAdmin => role == 'admin';
  bool get isStaff => role == 'staff';
}
