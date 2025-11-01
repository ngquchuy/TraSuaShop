import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Tìm các Controllers
    final shoppingController = Get.find<ShoppingController>();
    final wishListController = Get.find<WishListController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tính toán phần trăm giảm giá để điền vào banner "SALE"
    String discountText = '';
    if (product.oldPrice != null && product.oldPrice! > product.price) {
      double discountPercentage =
          ((product.oldPrice! - product.price) / product.oldPrice!) * 100;
      discountText = '-${discountPercentage.toStringAsFixed(0)}%';
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.9,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image & Overlay Stack
          Stack(
            children: [
              // image
              AspectRatio(
                // AspectRatio 16:9 là khá rộng, có thể gây tràn. Nếu bị tràn, hãy thử 4/3 hoặc 1/1
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? Image.asset(
                          // Hoặc Image.network nếu dùng ảnh mạng
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                ),
              ),
              // Discount Banner
              if (product.oldPrice != null && product.oldPrice! > product.price)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discountText,
                      style: AppTextstyles.withColor(
                          AppTextstyles.withWeight(
                              AppTextstyles.bodySmall, FontWeight.bold),
                          Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          // 2. Product details (Name, Category, Price)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextstyles.withColor(
                    AppTextstyles.withWeight(AppTextstyles.h3, FontWeight.bold),
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  product.category,
                  style: AppTextstyles.withColor(AppTextstyles.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!),
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    // Giá sản phẩm
                    Text(
                      '${product.price.toStringAsFixed(0)} đ',
                      style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // 4. Buttons (Favorite & Add to Cart)
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.01,
                right: screenWidth * 0.01,
                bottom: screenWidth * 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ❤️ Nút yêu thích
                Obx(() {
                  final isFavorite = wishListController.isFavorite(product);
                  return IconButton(
                    // Đảm bảo không chiếm quá nhiều không gian với BoxConstraints
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite ? Colors.red : Theme.of(context).hintColor,
                      size: 24,
                    ),
                    onPressed: () {
                      wishListController.toggleFavorite(product);
                    },
                  );
                }),

                // 🛒 Nút giỏ hàng
                IconButton(
                  // Đảm bảo không chiếm quá nhiều không gian với BoxConstraints
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(Icons.add_shopping_cart,
                      size: 24, color: Theme.of(context).primaryColor),
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
          ),
        ],
      ),
    );
  }
}
