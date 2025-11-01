import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/features/checkout/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final ShoppingController shoppingController = Get.find<ShoppingController>();

  CartScreen({super.key});

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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ảnh sản phẩm
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
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

                          // Cụm nút hành động
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  shoppingController.decreaseQuantity(item);
                                  // Get.snackbar(
                                  //   'Giỏ hàng',
                                  //   'Đã giảm số lượng sản phẩm',
                                  //   snackPosition: SnackPosition.TOP,
                                  //   backgroundColor:
                                  //       Colors.black.withOpacity(0.3),
                                  //   colorText: Colors.white,
                                  // );
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
                                  shoppingController
                                      .addToShopping(item.product);
                                  // Get.snackbar(
                                  //   'Giỏ hàng',
                                  //   'Đã tăng số lượng sản phẩm',
                                  //   snackPosition: SnackPosition.TOP,
                                  //   backgroundColor:
                                  //       Colors.black.withOpacity(0.3),
                                  //   colorText: Colors.white,
                                  // );
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.3),
                                    colorText: Colors.white,
                                  );
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
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
                color: Colors.blue.shade50,
                border: Border(
                  top: BorderSide(color: Colors.blue.shade200, width: 1.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        'Tổng cộng: ${shoppingController.totalPrice.toStringAsFixed(0)} đ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      )),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => const CheckoutScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
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
