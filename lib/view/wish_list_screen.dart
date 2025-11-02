import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/models/product.dart';
<<<<<<< HEAD
import 'package:milktea_shop/view/shopping_screen.dart';
=======
import 'package:milktea_shop/view/cart_screen.dart';
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WishListController wishListController =
        Get.find<WishListController>();
    final ShoppingController shoppingController =
        Get.find<ShoppingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích ❤️'),
        actions: [
          // 🛒 Icon giỏ hàng
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Nếu bạn có ShoppingScreen, có thể mở bằng:
<<<<<<< HEAD
              Get.to(() => ShoppingScreen());
=======
              Get.to(() => CartScreen());
>>>>>>> 73ec81ded91f4a8287c8bc150df3481f30676899
            },
          ),
          // 🗑️ Xóa toàn bộ danh sách yêu thích
          IconButton(
            onPressed: wishListController.clearFavorites,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: Obx(() {
        // Nếu danh sách rỗng
        if (wishListController.favoriteItems.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có sản phẩm yêu thích nào 😢',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Hiển thị danh sách sản phẩm
        return ListView.builder(
          itemCount: wishListController.favoriteItems.length,
          itemBuilder: (context, index) {
            final Product product = wishListController.favoriteItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${product.price.toStringAsFixed(0)} đ',
                  style: const TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🛒 Nút thêm vào giỏ
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      tooltip: 'Thêm vào giỏ hàng',
                      onPressed: () {
                        shoppingController.addToShopping(product);
                        Get.snackbar('Giỏ hàng',
                            '${product.name} đã được thêm vào giỏ hàng',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2));
                      },
                    ),
                    // ❌ Nút xóa khỏi yêu thích
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: 'Xóa khỏi yêu thích',
                      onPressed: () =>
                          wishListController.toggleFavorite(product),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
