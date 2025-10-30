import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';
import 'package:milktea_shop/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shoppingController = Get.find<ShoppingController>();
    final wishListController = Get.find<WishListController>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên sản phẩm
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Giá sản phẩm
            Text(
              '${product.price.toStringAsFixed(0)} đ',
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // Hàng chứa 2 nút: yêu thích + giỏ hàng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ❤️ Nút yêu thích
                Obx(() {
                  final isFavorite = wishListController.isFavorite(product);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      wishListController.toggleFavorite(product);
                      Get.snackbar(
                        'Yêu thích',
                        isFavorite
                            ? 'Đã xóa khỏi danh sách yêu thích'
                            : 'Đã thêm vào danh sách yêu thích',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                  );
                }),

                // 🛒 Nút giỏ hàng (chỉ icon)
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart, size: 22),
                  onPressed: () {
                    shoppingController.addToShopping(product);
                    Get.snackbar(
                      'Giỏ hàng',
                      '${product.name} đã được thêm vào giỏ hàng',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
