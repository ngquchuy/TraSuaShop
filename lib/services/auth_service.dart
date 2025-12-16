import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // 2. Khởi tạo đối tượng Logger
  // PrettyPrinter giúp log hiển thị đẹp, có màu sắc và ngăn cách rõ ràng
  final logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static const String baseUrl = 'http://10.0.2.2:5001/api/auth';

  final _storage = const FlutterSecureStorage();
  
  // Hàm lưu token (Dùng khi Login/Register thành công)
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Hàm lấy token (Dùng để gắn vào Header các request sau này)
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Hàm xóa token (Dùng khi Logout)
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Hàm Đăng ký
  Future<bool> register(
      String username, String fullName, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'FullName': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('Đăng ký thành công: $email'); // Log thông tin (Màu xanh)
        return true;
      } else {
        // Log lỗi từ phía server (Màu đỏ)
        logger.e('Lỗi đăng ký (Server): ${response.body}');
        return false;
      }
    } catch (e) {
      // Log lỗi kết nối hoặc exception (Màu đỏ)
      logger.e('Lỗi kết nối (Exception)', error: e);
      return false;
    }
  }

  // Hàm Đăng nhập
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        logger.i('Đăng nhập thành công: $username'); // Log thông tin
        return jsonDecode(response.body);
      } else {
        logger.e('Lỗi đăng nhập (Server): ${response.body}'); // Log lỗi
        return null;
      }
    } catch (e) {
      logger.e('Lỗi kết nối (Exception)', error: e); // Log lỗi kèm chi tiết lỗi
      return null;
    }
  }

  // Gửi yêu cầu OTP
  Future<bool> sendForgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Gửi mật khẩu mới kèm OTP
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
