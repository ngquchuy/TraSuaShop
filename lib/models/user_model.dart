class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String role;
  final String? token; // Token để dùng cho các request sau này

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    this.token,
  });

  // Factory để chuyển đổi từ JSON (Server trả về) sang Object Dart
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Lưu ý: Backend MongoDB trả về '_id', ta map sang 'id'
      id: json['_id'] ?? '', 
      
      username: json['username'] ?? '',
      
      // Backend trả về 'FullName' (viết hoa chữ F), map đúng tên key
      fullName: json['FullName'] ?? '', 
      
      email: json['email'] ?? '',
      
      // Quan trọng: Đây là biến quyết định quyền
      role: json['role'] ?? 'customer', 
      
      // Token xác thực
      token: json['token'], 
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
    };
  }

  // Helper check quyền nhanh
  bool get isAdmin => role == 'admin';
  bool get isStaff => role == 'staff';
}