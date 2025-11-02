import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
<<<<<<< HEAD
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/wish_list_screen.dart'; // ✅ thêm file mới
=======
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/cart_screen.dart';
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
import 'package:milktea_shop/view/widgets/category_chips.dart';
import 'package:milktea_shop/view/widgets/custom_searchbar.dart';
import 'package:milktea_shop/view/widgets/product_grid.dart';
import 'package:milktea_shop/view/widgets/sale_banner.dart';

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
<<<<<<< HEAD
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
=======
            // 👤 Header (Bây giờ bao gồm cả icon thông báo)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      8), // Điều chỉnh padding để không cần top: 8 riêng nữa
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
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
                    ],
                  ),
                  const Spacer(),

<<<<<<< HEAD
                  // ❤️ Nút yêu thích
                  IconButton(
                    onPressed: () => Get.to(() => const WishListScreen()),
                    icon: const Icon(Icons.favorite_border),
                  ),

                  // 🛒 Nút giỏ hàng
                  IconButton(
                    onPressed: () => Get.to(() => ShoppingScreen()),
                    icon: const Icon(Icons.shopping_bag_outlined),
=======
                  // 🔔 Thanh thông báo với badge (Đã di chuyển vào đây)
                  Obx(() {
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
                                          onPressed: () =>
                                              notificationController
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
                  // 🛒 Nút giỏ hàng
                  IconButton(
                    onPressed: () => Get.to(() => CartScreen()),
                    icon: const Icon(Icons.shopping_cart_outlined),
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
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
<<<<<<< HEAD

=======
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
            // 🔍 Search bar
            const CustomSearchbar(),
            const CategoryChips(),
            const SaleBanner(),

<<<<<<< HEAD
            // Tiêu đề sản phẩm phổ biến
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
=======
            //popular product

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sản phẩm phổ biến',
<<<<<<< HEAD
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Hiển thị tất cả',
                      style: TextStyle(color: Theme.of(context).primaryColor),
=======
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
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
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
