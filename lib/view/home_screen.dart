import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/widgets/category_chips.dart';
import 'package:milktea_shop/view/widgets/custom_searchbar.dart';
import 'package:milktea_shop/view/widgets/product_grid.dart';
import 'package:milktea_shop/view/widgets/sale_banner.dart';
import 'package:milktea_shop/view/wish_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔔 Thanh thông báo với badge
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  int count = notificationController.count;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          if (count == 0) {
                            Get.snackbar(
                              'Thông báo',
                              'Không có thông báo mới',
                              snackPosition: SnackPosition.TOP,
                            );
                          } else {
                            Get.defaultDialog(
                              title: 'Thông báo ($count)',
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < count; i++)
                                    ListTile(
                                      title: Text(notificationController
                                          .notifications[i]),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => notificationController
                                            .removeNotification(i),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () =>
                                        notificationController.clearAll(),
                                    child: const Text('Xóa tất cả'),
                                  )
                                ],
                              ),
                            );
                          }
                        },
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
              ),
            ),

            // 👤 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

                  // ❤️ Nút yêu thích
                  IconButton(
                    onPressed: () => Get.to(() => const WishListScreen()),
                    icon: const Icon(Icons.favorite_border),
                  ),

                  // 🛒 Nút giỏ hàng
                  IconButton(
                    onPressed: () => Get.to(() => ShoppingScreen()),
                    icon: const Icon(Icons.shopping_bag_outlined),
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

            // 🔍 Search bar
            const CustomSearchbar(),
            const CategoryChips(),
            const SaleBanner(),

            //popular product

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

            const Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }
}
