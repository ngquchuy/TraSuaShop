import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart'; // Import WishListController
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/utils/number_formatter.dart';
import 'package:milktea_shop/view/shopping_screen.dart'; // Import ShoppingScreen
import 'package:milktea_shop/view/product_detail_screen.dart'; // Import ProductDetailScreen

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  // Hàm xử lý ảnh (Copy từ ProductGrid/CartScreen sang để tái sử dụng)
  // Tốt nhất là nên tách hàm này ra file utils riêng để dùng chung
  String fixImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    if (!url.startsWith('http')) {
      if (url.startsWith('/')) {
        return 'http://10.0.2.2:5001$url';
      }
      return 'http://10.0.2.2:5001/$url';
    }
    return url;
  }

  Widget _buildImage(String rawUrl) {
    final String finalUrl = fixImageUrl(rawUrl);

    if (finalUrl.isEmpty) {
      return const Icon(Icons.image_not_supported,
          color: Colors.grey, size: 50);
    }

    if (finalUrl.startsWith('http')) {
      return Image.network(
        finalUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.grey, size: 50),
      );
    }
    return Image.asset(finalUrl, width: 60, height: 60, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo/Tìm các Controller
    final WishListController wishListController = Get.put(WishListController());
    final ShoppingController shoppingController =
        Get.find<ShoppingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích ❤️'),
        centerTitle: true, // Căn giữa tiêu đề cho đẹp
        actions: [
          // 🛒 Icon giỏ hàng
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Get.to(() => ShoppingScreen());
            },
          ),
          // 🗑️ Xóa toàn bộ danh sách yêu thích
          IconButton(
            onPressed: () {
              if (wishListController.favoriteItems.isNotEmpty) {
                // Hiện dialog xác nhận trước khi xóa hết
                Get.defaultDialog(
                    title: "Xác nhận",
                    middleText: "Bạn có chắc muốn xóa hết danh sách yêu thích?",
                    textConfirm: "Xóa",
                    textCancel: "Hủy",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      wishListController.clearFavorites();
                      Get.back(); // Đóng dialog
                    });
              } else {
                Get.snackbar("Thông báo", "Danh sách đang trống",
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: Obx(() {
        // Nếu danh sách rỗng
        if (wishListController.favoriteItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'Chưa có sản phẩm yêu thích nào 😢',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
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
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Chuyển sang màn hình chi tiết khi bấm vào item
                  Get.to(() => ProductDetailScreen(product: product));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Ảnh sản phẩm
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(product.imageUrl),
                      ),
                      const SizedBox(width: 12),

                      // Thông tin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormatter.formatPrice(product.price),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nút hành động
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🛒 Nút thêm vào giỏ
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart,
                                color: Colors.blue),
                            tooltip: 'Thêm vào giỏ hàng',
                            onPressed: () {
                              shoppingController.addToShopping(product);
                              // Không cần snackbar ở đây nữa vì Controller đã có rồi
                            },
                          ),
                          // ❌ Nút xóa khỏi yêu thích
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            tooltip: 'Xóa khỏi yêu thích',
                            onPressed: () =>
                                wishListController.toggleFavorite(product),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
