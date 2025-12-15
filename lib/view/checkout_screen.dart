import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/order_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/models/shopping_item_model.dart';
import 'package:milktea_shop/features/checkout/widgets/address_card.dart';
import 'package:milktea_shop/features/checkout/widgets/order_summary_card.dart';
import 'package:milktea_shop/features/checkout/widgets/payment_method_card.dart';
import 'package:milktea_shop/features/checkout/widgets/checkout_bottom_bar.dart';
import 'package:milktea_shop/features/order%20confirmation/screens/order_confirmation_screen.dart';
import 'package:milktea_shop/features/shipping%20address/repositories/address_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ShoppingController shoppingController = Get.find<ShoppingController>();
  final OrderController orderController = Get.put(OrderController());
  final UserController userController = Get.find<UserController>();
  final AddressRepository _addressRepository = AddressRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danh sách sản phẩm
            const Text(
              'Sản phẩm đã chọn',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildProductsList(),
            const SizedBox(height: 24),

            // Địa chỉ nhận hàng
            const Text(
              'Địa chỉ nhận hàng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const AddressCard(),
            const SizedBox(height: 24),

            // Tóm tắt đơn hàng
            const Text(
              'Tóm tắt đơn hàng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const OrderSummaryCard(),
            const SizedBox(height: 24),

            // Phương thức thanh toán
            const Text(
              'Phương thức thanh toán',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const PaymentMethodCard(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => CheckoutBottomBar(
            totalAmount: shoppingController.totalPrice.value,
            onPlaceOrder:
                orderController.isLoading.value ? () {} : _submitOrder,
          )),
    );
  }

  // Hiển thị danh sách sản phẩm
  Widget _buildProductsList() {
    return Obx(() {
      if (shoppingController.shoppingItems.isEmpty) {
        return const Center(
          child: Text('Giỏ hàng trống'),
        );
      }
      return Column(
        children: List.generate(
          shoppingController.shoppingItems.length,
          (index) {
            final item = shoppingController.shoppingItems[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh sản phẩm
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.product.imageUrl.isNotEmpty
                          ? Image.network(
                              item.product.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Thông tin sản phẩm
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Giá: ${item.product.price.toStringAsFixed(0)} đ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Số lượng: ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          // Hiển thị các tùy chọn đã chọn
                          if (item.selectedOptions.isNotEmpty)
                            ...item.selectedOptions.map((group) {
                              final selectedOptions = group.options
                                  .where((opt) => opt.isSelected)
                                  .toList();
                              if (selectedOptions.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${group.title}: ${selectedOptions.map((e) => e.name).join(', ')}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange,
                                  ),
                                ),
                              );
                            }).toList(),
                          // Hiển thị ghi chú nếu có
                          if (item.notes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Ghi chú: ${item.notes}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.purple,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            'Tổng: ${(item.product.price * item.quantity).toStringAsFixed(0)} đ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _submitOrder() async {
    // Kiểm tra dữ liệu user có đầy đủ không
    if (userController.userName.value.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng cập nhật tên trong thông tin cá nhân',
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (userController.userPhone.value.isEmpty) {
      Get.snackbar(
          'Lỗi', 'Vui lòng cập nhật số điện thoại trong thông tin cá nhân',
          snackPosition: SnackPosition.TOP);
      return;
    }

    // Lấy địa chỉ default từ AddressRepository
    final addresses = _addressRepository.getAddresses();
    final defaultAddress = addresses.firstWhereOrNull((addr) => addr.isDefault);

    if (defaultAddress == null || defaultAddress.fullAddress.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng chọn địa chỉ nhận hàng mặc định',
          snackPosition: SnackPosition.TOP);
      return;
    }

    // Chuyển đổi ShoppingItem thành ShoppingItemModel (bao gồm options + notes)
    final items = shoppingController.shoppingItems
        .map((item) => ShoppingItemModel(
              product: item.product,
              quantity: item.quantity,
              selectedOptions: item.selectedOptions,
              notes: item.notes,
            ))
        .toList();

    // Tạo đơn hàng (dùng dữ liệu từ user controller + default address)
    bool success = await orderController.createOrder(
      customerName: userController.userName.value,
      customerPhone: userController.userPhone.value,
      customerAddress: defaultAddress.fullAddress,
      notes: '',
      items: items,
      totalPrice: shoppingController.totalPrice.value,
    );

    if (success) {
      Get.snackbar('Thành công', 'Đơn hàng đã được tạo thành công',
          snackPosition: SnackPosition.TOP);
      shoppingController.clearShopping();
      // Điều hướng tới OrderConfirmationScreen
      Get.offAll(() => OrderConfirmationScreen(
            orderNumber: 'ORD${DateTime.now().millisecondsSinceEpoch}',
            totalAmount: shoppingController.totalPrice.value,
          ));
    } else {
      Get.snackbar('Lỗi', 'Không thể tạo đơn hàng',
          snackPosition: SnackPosition.TOP);
    }
  }
}
