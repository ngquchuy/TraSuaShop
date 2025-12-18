import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/view/forgot_password_screen.dart';
import 'package:milktea_shop/view/main_screen.dart';
import 'package:milktea_shop/view/signup_screen.dart';
import 'package:milktea_shop/view/widgets/custom_textfield.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:logger/logger.dart';

class SigninScreen extends StatelessWidget {
  // 1. Đã xóa biến isUser ở đây vì không cần thiết khi mới vào màn hình đăng nhập
  SigninScreen({
    super.key,
  });

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final logger = Logger(
      printer: PrettyPrinter(),
    );

    void _handleLogin() async {
      String username = _usernameController.text;
      String password = _passwordController.text;

      logger.d("Bắt đầu xử lý đăng nhập cho: $username");

      // Gọi API Backend
      var result = await _authService.login(username, password);

      if (result != null) {
        logger.i("Đăng nhập thành công. Token: ${result['token']}");

        String token = result['token'];
        await _authService.saveToken(token);

        final userController = Get.find<UserController>();

        // Cập nhật dữ liệu user vào Controller
        userController.setUserData(result);

        if (!context.mounted) return;

        // 2. Lấy thông tin User từ kết quả trả về hoặc từ Controller để chuyển trang
        // Giả sử result chứa thông tin user, ta tạo đối tượng User từ đó
        User loggedInUser = User.fromJson(result);

        // Chuyển sang trang Dashboard và truyền user vào
        Get.offAll(() => MainScreen(user: loggedInUser));
      } else {
        logger.w("Đăng nhập thất bại");

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Tên đăng nhập hoặc mật khẩu không đúng")),
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
                label: 'Tên đăng nhập',
                prefixIcon: Icons.person_2_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập của bạn';
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
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
              // Nút Đăng nhập
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => _handleLogin(),
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
              // Sign up
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
                thickness: 1,
                endIndent: 10,
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

              // NÚT GOOGLE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handleGoogleSignIn(context),
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    'Đăng nhập với Google',
                    style: AppTextstyles.withColor(
                      AppTextstyles.buttonMedium,
                      Colors.black87,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // NÚT KHÁCH
              // ElevatedButton(
              //   onPressed: () async {
              //     // 3. Tạo User ảo cho chế độ khách
              //     // Lưu ý: Bạn hãy điền các trường required trong User model của bạn vào đây
              //     User guestUser = User(
              //       id: "guest",
              //       fullName: "Khách hàng",
              //       email: "",
              //       phoneNumber: "",
              //       address: "",
              //       isAdmin: false,
              //       // thêm các trường khác nếu Model User của bạn yêu cầu
              //     );

              //     Get.offAll(() => MainScreen(user: guestUser));
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey.shade200,
              //     foregroundColor: Colors.black87,
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       side: BorderSide(color: Colors.grey.shade400, width: 1),
              //     ),
              //     minimumSize: const Size(double.infinity, 50),
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //     textStyle: const TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   child: Text(
              //     'Đăng nhập như khách',
              //     style: AppTextstyles.withColor(
              //       AppTextstyles.buttonMedium,
              //       Colors.black87,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn(BuildContext context) async {
    Get.snackbar(
      'Thông báo',
      'Tính năng đăng nhập Google đang được cập nhật cho hệ thống mới.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
