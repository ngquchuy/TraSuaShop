import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/admin/view/admin_main_screen.dart';
import 'package:milktea_shop/controllers/navigation_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/view/account_screen.dart';
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/home_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/widgets/custom_bottom_navbar.dart';
import 'package:milktea_shop/view/wish_list_screen.dart';

class MainScreen extends StatelessWidget {
  // --- XÓA: final User user; ---

  // Constructor không cần user nữa
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.find<NavigationController>();
    // Gọi UserController để kiểm tra quyền
    final UserController userController = Get.find<UserController>();

    // Kiểm tra role trực tiếp từ Controller
    if (userController.role.value == 'admin') {
      // Lưu ý: Bạn cũng cần vào AdminMainScreen xóa biến user tương tự như CheckoutScreen nhé!
      // Tạm thời nếu AdminMainScreen chưa sửa thì sẽ báo lỗi ở dòng dưới
      return const AdminMainScreen();
    } else {
      return GetBuilder<ThemeController>(
          builder: (themeController) => Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
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
              ));
    }
  }
}
