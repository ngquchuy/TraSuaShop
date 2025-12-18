import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart'; // Import Controller
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/widgets/category_chips.dart';
import 'package:milktea_shop/view/widgets/custom_searchbar.dart';
import 'package:milktea_shop/view/widgets/product_grid.dart';
import 'package:milktea_shop/view/widgets/sale_banner.dart';
import 'package:milktea_shop/view/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo các Controller cần thiết
    // final notificationController = Get.find<NotificationController>();

    // QUAN TRỌNG: Khởi tạo ShoppingController để bắt đầu tải API
    final shoppingController = Get.put(ShoppingController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          // Tính năng kéo xuống để load lại API
          onRefresh: () async {
            shoppingController.fetchProducts();
          },
          child: Column(
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

                    // 🔔 Thanh thông báo
                    Obx(() {
                      int count = 0; // notificationController.count;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () => {},
                            // Get.to(() => NotificationScreen()),
                          ),
                          if (count > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),

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
              const CustomSearchbar(),
              const CategoryChips(),
              const SaleBanner(),

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
              const Expanded(child: ProductGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
