import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:milktea_shop/admin/view/admin_main_screen.dart';
import 'package:milktea_shop/controllers/navigation_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/view/account_screen.dart';
import 'package:milktea_shop/view/home_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/widgets/custom_bottom_navbar.dart';
import 'package:milktea_shop/view/wish_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    // --- LẮNG NGHE THÔNG BÁO KHI APP ĐANG MỞ (Foreground) ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận tin nhắn foreground: ${message.notification?.title}');

      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'Thông báo',
          message.notification!.body ?? '',
          icon: const Icon(Icons.notifications_active, color: Colors.white),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          onTap: (_) {
            print("Người dùng đã bấm vào thông báo");
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.find<NavigationController>();
    final UserController userController = Get.find<UserController>();

    // --- QUAN TRỌNG: Bọc Obx để tự động chuyển màn hình khi Role thay đổi ---
    return Obx(() {
      // Kiểm tra Role ngay trong Obx
      if (userController.role.value == 'admin') {
        // Nếu là Admin -> Vào màn hình Admin
        return const AdminMainScreen();
      } else {
        // Nếu là Khách -> Vào màn hình Khách
        return GetBuilder<ThemeController>(
          builder: (themeController) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              // Vẫn giữ Obx con này để chuyển tab (Home/Cart/Profile...)
              child: Obx(() => IndexedStack(
                    key: ValueKey(navigationController.currentIndex.value),
                    index: navigationController.currentIndex.value,
                    children: [
                      const HomeScreen(),
                      ShoppingScreen(),
                      const WishListScreen(),
                      const AccountScreen(),
                    ],
                  )),
            ),
            bottomNavigationBar: const CustomBottomNavbar(),
          ),
        );
      }
    });
  }
}
