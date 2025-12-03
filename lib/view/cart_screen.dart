import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
// Đảm bảo bạn đã có file checkout_screen.dart, nếu chưa thì tạm comment dòng này
import 'package:milktea_shop/features/checkout/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final ShoppingController shoppingController = Get.find<ShoppingController>();

  CartScreen({super.key});

  // --- 1. HÀM XỬ LÝ ẢNH (Copy từ ProductGrid sang) ---
  String fixImageUrl(String url) {
    if (url.isEmpty) return '';
    // Fix lỗi localhost trên Android Emulator
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    // Fix lỗi đường dẫn tương đối (uploads/...)
    if (!url.startsWith('http')) {
      if (url.startsWith('/')) {
        return 'http://10.0.2.2:5001$url';
      }
      return 'http://10.0.2.2:5001/$url';
    }
    return url;
  }

  // --- 2. WIDGET HIỂN THỊ ẢNH ---
  Widget _buildImage(String rawUrl) {
    final String finalUrl = fixImageUrl(rawUrl);

    if (finalUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey, size: 40);
    }

    if (finalUrl.startsWith('http')) {
      return Image.network(
        finalUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => 
            const Icon(Icons.broken_image, color: Colors.grey, size: 40),
      );
    }
    return Image.asset(finalUrl, width: 60, height: 60, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (shoppingController.shoppingItems.isEmpty) {
          return const Center(
            child: Text(
              'Giỏ hàng của bạn đang trống',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            // Danh sách sản phẩm
            Expanded(
              child: ListView.builder(
                itemCount: shoppingController.shoppingItems.length,
                itemBuilder: (context, index) {
                  final item = shoppingController.shoppingItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // --- SỬA LẠI PHẦN ẢNH ---
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImage(item.product.imageUrl), // Dùng hàm _buildImage
                          ),
                          const SizedBox(width: 10),

                          // Tên và giá
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Giá: ${item.product.price.toStringAsFixed(0)} đ',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Cụm nút hành động (Tăng/Giảm/Xóa)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  shoppingController.decreaseQuantity(item);
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  shoppingController.addToShopping(item.product);
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                onPressed: () {
                                  shoppingController.removeFromShopping(item);
                                  Get.snackbar(
                                    'Giỏ hàng',
                                    'Đã xóa sản phẩm khỏi giỏ',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.black.withOpacity(0.5),
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tổng tiền + nút thanh toán
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Tự động theo theme sáng/tối
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng cộng:", style: TextStyle(color: Colors.grey)),
                      Text(
                        '${shoppingController.totalPrice.toStringAsFixed(0)} đ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )),
                  ElevatedButton.icon(
                    // Nếu chưa có CheckoutScreen thì tạm comment dòng này lại
                    onPressed: () => Get.to(() => const CheckoutScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.payment, color: Colors.white),
                    label: const Text(
                      'Thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}