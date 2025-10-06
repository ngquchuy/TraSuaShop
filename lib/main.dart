import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/view/splash_screen.dart';

import 'utils/app_themes.dart';

main() async {
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(AuthController());
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
