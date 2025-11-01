import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/view/forgot_password_screen.dart';
import 'package:milktea_shop/view/main_screen.dart';
import 'package:milktea_shop/view/signup_screen.dart';
import 'package:milktea_shop/view/widgets/custom_textfield.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Chào mừng trở lại',
                style: AppTextstyles.withColor(
                  AppTextstyles.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đăng nhập để tiếp tục mua trà sữa',
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 40),
              //Email textfield
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
              //password tesxtfield
              CustomTextfield(
                label: 'Mật khẩu',
                prefixIcon: Icons.lock_outlined,
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
              const SizedBox(height: 8),
              //forgot password textbutton
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  child: Text(
                    'Quên mật khẩu?',
                    style: AppTextstyles.withColor(
                      AppTextstyles.buttonMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              //sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: AppTextstyles.withColor(
                          AppTextstyles.buttonMedium, Colors.white),
                    )),
              ),
              const SizedBox(height: 24),
              //sign up textbutton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn chưa có tài khoản?",
                    style: AppTextstyles.withColor(AppTextstyles.bodyMedium,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!),
                  ),
                  TextButton(
                    onPressed: () => Get.to(
                      () => SignupScreen(),
                    ),
                    child: Text(
                      'Đăng ký',
                      style: AppTextstyles.withColor(
                        AppTextstyles.buttonMedium,
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1, // Độ dày của đường kẻ
                endIndent: 10, // Khoảng cách tới chữ
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đăng nhập bằng phương thức khác',
                    textAlign: TextAlign.center,
                    style: AppTextstyles.withColor(
                      AppTextstyles.bodySmall,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signInAnonymously();
                  Get.offAll(() => const MainScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  // Màu chữ: Màu tối
                  foregroundColor: Colors.black87,
                  // Độ cao (Elevation)
                  elevation: 0,
                  // Hình dạng: Viền bo tròn
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // Thêm viền nếu cần
                    side: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),
                  // Kích thước tối thiểu để nút luôn rộng
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  'Đăng nhập như khách',
                  style: AppTextstyles.withColor(
                    AppTextstyles.buttonMedium,
                    Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //sign in button onpressed
  void _handleSignIn() {
    final AuthController authController = Get.find<AuthController>();
    authController.login();
    Get.offAll(() => const MainScreen());
  }
}
