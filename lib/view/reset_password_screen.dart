import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/services/auth_service.dart';
import 'package:milktea_shop/view/signin_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _confirmReset() async {
    if (_otpController.text.isEmpty || _passController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đủ thông tin");
      return;
    }

    setState(() => _isLoading = true);
    bool success = await _authService.resetPassword(
        widget.email, _otpController.text, _passController.text);
    setState(() => _isLoading = false);

    if (success) {
      Get.defaultDialog(
        title: "Thành công",
        middleText: "Mật khẩu đã được thay đổi. Vui lòng đăng nhập lại.",
        textConfirm: "OK",
        onConfirm: () {
          Get.offAll(() => SigninScreen()); // Quay về trang đăng nhập
        },
      );
    } else {
      Get.snackbar("Thất bại", "Mã OTP không đúng hoặc đã hết hạn");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đặt lại mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Đã gửi OTP đến: ${widget.email}"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nhập mã OTP (6 số)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmReset,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Xác nhận đổi mật khẩu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
