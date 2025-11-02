import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milktea_shop/controllers/auth_controller.dart';
import 'package:milktea_shop/controllers/navigation_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/firebase_options.dart';
import 'package:milktea_shop/view/main_screen.dart';
import 'package:milktea_shop/view/splash_screen.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
<<<<<<< HEAD

=======
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
import 'utils/app_themes.dart';

Future<void> main() async {
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(NavigationController());
<<<<<<< HEAD
  Get.put(ShoppingController());  
  Get.put(NotificationController());
  Get.put(WishListController());
  Get.put(UserController());
=======
  Get.put(ShoppingController());
  Get.put(NotificationController());
  Get.put(WishListController());
  Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return SplashScreen();
            }
            return const MainScreen();
          }),
    );
  }
}
