import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart'; // Import Controller
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/widgets/category_chips.dart';
import 'package:milktea_shop/view/widgets/custom_searchbar.dart';
import 'package:milktea_shop/view/widgets/product_grid.dart';
import 'package:milktea_shop/view/widgets/sale_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Khởi tạo các Controller cần thiết
    // final notificationController = Get.find<NotificationController>();

    // QUAN TRỌNG: Lấy ShoppingController đã được khởi tạo ở main.dart
    final shoppingController = Get.find<ShoppingController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          // Tính năng kéo xuống để load lại API
          onRefresh: () async {
            shoppingController.fetchProducts();
          },
          child: ListView(
            children: [
              // 👤 Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                          'assets/images/avatar-with-black-hair-and-hoodie.png'),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi', style: TextStyle(color: Colors.grey)),
                        Text(
                          'Good day',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // 🔔 Thanh thông báo (không dùng Obx vì chưa có Rx variable)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                        ),
                        // Nếu sau này có notificationController.count thì thêm Positioned ở đây
                      ],
                    ),

                    // 🛒 Nút giỏ hàng
                    IconButton(
                      onPressed: () => Get.to(() => ShoppingScreen()),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),

                    // ☀️ / 🌙 Nút theme
                    GetBuilder<ThemeController>(
                      builder: (controller) => IconButton(
                        onPressed: () => controller.toggleTheme(),
                        icon: Icon(
                          controller.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔍 Search bar & Banner & Chips
              // Bọc trong SingleChildScrollView hoặc giữ nguyên nếu ProductGrid là Expanded
              // Ở đây mình giữ nguyên cấu trúc của bạn
              CustomSearchbar(),
              CategoryChips(),
              SaleBanner(),

              // Tiêu đề Popular Product
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sản phẩm phổ biến',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const AllProductScreen()),
                      child: Text(
                        'Hiển thị tất cả',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // QUAN TRỌNG: Grid sản phẩm (Đã được sửa ở bước 2)
              ProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
