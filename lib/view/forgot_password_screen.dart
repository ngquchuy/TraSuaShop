import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/services/auth_service.dart';
import 'package:milktea_shop/view/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _sendOtp() async {
    if (_emailController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập email");
      return;
    }

    setState(() => _isLoading = true);
    bool success = await _authService.sendForgotPassword(_emailController.text);
    setState(() => _isLoading = false);

    if (success) {
      Get.snackbar("Thành công", "Đã gửi mã OTP vào email của bạn");
      // Chuyển sang trang nhập OTP và đổi mật khẩu
      Get.to(() => ResetPasswordScreen(email: _emailController.text));
    } else {
      Get.snackbar("Thất bại", "Email không tồn tại hoặc lỗi hệ thống");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Nhập email đã đăng ký để nhận mã OTP"),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Gửi mã OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
