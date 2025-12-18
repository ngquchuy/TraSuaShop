import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/controllers/navigation_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
// import 'package:milktea_shop/view/main_screen.dart';
import 'package:milktea_shop/view/splash_screen.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'utils/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Khởi tạo bộ nhớ cục bộ
  await GetStorage.init();

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
