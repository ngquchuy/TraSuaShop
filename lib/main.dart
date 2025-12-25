import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/controllers/navigation_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/view/splash_screen.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'utils/app_themes.dart';

// --- 2. HÀM XỬ LÝ TIN NHẮN KHI TẮT APP (BACKGROUND) ---
// Hàm này phải nằm ngoài void main()
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Cần khởi tạo Firebase để xử lý ngầm
  await Firebase.initializeApp();
  print("Nhận tin nhắn khi tắt app: ${message.messageId}");
}
// ------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo bộ nhớ cục bộ
  await GetStorage.init();

  // --- 3. KHỞI TẠO FIREBASE & ĐĂNG KÝ BACKGROUND ---
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // ------------------------------------------------

  // Khởi tạo các Controller (Dependency Injection)
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(NavigationController());
  Get.put(ShoppingController());
  // Get.put(NotificationController());
  Get.put(WishListController());
  Get.put(UserController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tra Sua Shop',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreen(),
    );
  }
}
