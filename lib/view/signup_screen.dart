import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/view/signin_screen.dart';
import 'widgets/custom_textfield.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void handleSignUp() async {
      String name = _usernameController.text;
      String fullname = _fullnameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // Validate cơ bản
      if (name.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
        );
        return;
      }

      // Gọi API (Hiện loading nếu cần)
      bool success =
          await _authService.register(name, fullname, email, password);
      if (!context.mounted) return;

      if (success) {
        // Thông báo và chuyển sang trang đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công! Hãy đăng nhập.")),
        );
        Navigator.pop(context); // Quay lại trang Login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thất bại. Vui lòng thử lại")),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back button
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Đăng ký tài khoản',
              style: AppTextstyles.withColor(
                AppTextstyles.h1,
                Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Đăng ký để bắt đầu',
              style: AppTextstyles.withColor(
                AppTextstyles.bodyLarge,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 40),

            //full name textfield

            CustomTextfield(
              label: 'Họ và tên',
              prefixIcon: Icons.person_2_outlined,
              keyboardType: TextInputType.name,
              controller: _fullnameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên của bạn';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),
            CustomTextfield(
              label: 'Tên đăng nhập',
              prefixIcon: Icons.person_2_rounded,
              keyboardType: TextInputType.name,
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên đăng nhập của bạn';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            CustomTextfield(
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email của bạn';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Email của bạn không hợp lệ';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),
            //passord textfield

            CustomTextfield(
              label: 'Mật khẩu',
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu của bạn';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),
            //confirmpassword textfield

            CustomTextfield(
              label: 'Xác nhận mật khẩu',
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              controller: _confirmpasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận lại của bạn';
                }
                if (value != _passwordController.text) {
                  return 'Mật khẩu không trùng khớp';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            //sign up button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Đăng ký',
                    style: AppTextstyles.withColor(
                        AppTextstyles.buttonMedium, Colors.white),
                  )),
            ),

            const SizedBox(height: 16),

            //sign in textbutton
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bạn đã có tải khoản?",
                  style: AppTextstyles.withColor(AppTextstyles.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!),
                ),
                TextButton(
                  onPressed: () => Get.to(
                    () => SigninScreen(),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: AppTextstyles.withColor(
                      AppTextstyles.buttonMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
