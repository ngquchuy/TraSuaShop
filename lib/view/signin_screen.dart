import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/view/forgot_password_screen.dart';
import 'package:milktea_shop/view/main_screen.dart';
import 'package:milktea_shop/view/signup_screen.dart';
import 'package:milktea_shop/view/widgets/custom_textfield.dart';
import '../controllers/user_controller.dart';
import '../services/auth_service.dart';
import 'package:logger/logger.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Khởi tạo AuthController để sử dụng cho cả email/pass và Google
  final AuthController authController = Get.find<AuthController>();
  final NotificationController notificationController =
      Get.put(NotificationController());
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

      // Log thông báo bắt đầu xử lý (Optional - để debug luồng chạy)
      logger.d("Bắt đầu xử lý đăng nhập cho: $username");

      // Gọi API
      var result = await _authService.login(username, password);

      if (result != null) {
        // Đăng nhập thành công
        // 3. Thay thế print bằng logger.i (Info)
        logger.i("Đăng nhập thành công. Token: ${result['token']}");

        //Lưu token vào bộ nhớ máy
        String token =
            result['token']; // Đảm bảo backend trả về key tên là 'token'

        // Lưu token vào bộ nhớ máy an toàn
        await _authService.saveToken(token);

        final userController = Get.find<UserController>();
        userController.setUserData(result);

        // Thêm thông báo đăng nhập thành công
        notificationController.addNotification('Đăng nhập thành công!');

        if (!context.mounted) return;

        // Chuyển sang trang Dashboard
        Get.offAll(() => const MainScreen());
      } else {
        // 4. Thêm log cảnh báo (Warning) khi đăng nhập thất bại
        logger.w("Đăng nhập thất bại: Tên đăng nhập hoặc mật khẩu không đúng");

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
                  if (!GetUtils.isEmail(value)) {
                    return 'Tên đăng nhập của bạn không hợp lệ';
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
              //sign in button (Email/Password)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => _handleLogin(), // Cập nhật cách gọi
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
              // NÚT ĐĂNG NHẬP BẰNG GOOGLE (MỚI)
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
              // NÚT ĐĂNG NHẬP NHƯ KHÁCH (Đã có)
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signInAnonymously();
                  Get.offAll(() => const MainScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),
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

  // Hàm xử lý Đăng nhập bằng Google (MỚI)
  void _handleGoogleSignIn(BuildContext context) async {
    // 1. Gọi hàm signInWithGoogle() từ AuthController
    final User? user = await authController.signInWithGoogle();

    // 2. Nếu thành công, chuyển hướng
    if (user != null) {
      // Thêm thông báo đăng nhập Google thành công
      notificationController
          .addNotification('Đăng nhập với Google thành công!');
      Get.offAll(() => const MainScreen());
    } else {
      // Xử lý thất bại (ví dụ: hiển thị snackbar báo lỗi)
      Get.snackbar(
        'Lỗi Đăng nhập',
        'Không thể đăng nhập bằng Google. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
