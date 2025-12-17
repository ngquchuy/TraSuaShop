import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/order_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/models/shopping_item_model.dart';
import 'package:milktea_shop/features/checkout/widgets/address_card.dart';
import 'package:milktea_shop/features/checkout/widgets/payment_method_card.dart';
import 'package:milktea_shop/features/checkout/widgets/checkout_bottom_bar.dart';
import 'package:milktea_shop/features/order%20confirmation/screens/order_confirmation_screen.dart';
import 'package:milktea_shop/features/shipping%20address/repositories/address_repository.dart';
import 'package:milktea_shop/utils/number_formatter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ShoppingController shoppingController = Get.find<ShoppingController>();
  final OrderController orderController = Get.put(OrderController());
  final UserController userController = Get.find<UserController>();
  final NotificationController notificationController =
      Get.put(NotificationController());
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
            _buildOrderSummary(),
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

  // Tính tổng giá option cho một sản phẩm
  double _calculateOptionPrice(ShoppingItem item) {
    double optionPrice = 0.0;
    for (var group in item.selectedOptions) {
      for (var option in group.options) {
        if (option.isSelected) {
          optionPrice += option.price;
        }
      }
    }
    return optionPrice;
  }

  // Tính tổng giá gốc (product + options) × quantity
  double _calculateItemTotalOriginal(ShoppingItem item) {
    double pricePerUnit = item.product.price + _calculateOptionPrice(item);
    return pricePerUnit * item.quantity;
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
                          // Hiển thị tổng giá option nếu có
                          if (item.selectedOptions.isNotEmpty)
                            Text(
                              'Option thêm: +${NumberFormatter.formatPrice(_calculateOptionPrice(item))} đ',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.orange,
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
                          // Hiển thị giảm giá nếu có
                          if (item.discountPercentage > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tổng gốc: ${NumberFormatter.formatPrice(_calculateItemTotalOriginal(item))}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    'Giảm ${item.discountPercentage.toStringAsFixed(0)}%: -${NumberFormatter.formatPrice(_calculateItemTotalOriginal(item) * item.discountPercentage / 100)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
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

  // Hiển thị tóm tắt đơn hàng với giảm giá
  Widget _buildOrderSummary() {
    return Obx(() {
      double totalOriginal = 0.0;
      double totalDiscount = 0.0;

      for (var item in shoppingController.shoppingItems) {
        double pricePerUnit = item.product.price + _calculateOptionPrice(item);
        double itemTotal = pricePerUnit * item.quantity;
        totalOriginal += itemTotal;
        if (item.discountPercentage > 0) {
          totalDiscount += itemTotal * (item.discountPercentage / 100);
        }
      }

      double finalTotal = totalOriginal - totalDiscount;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tạm tính:'),
                Text(
                  NumberFormatter.formatPrice(totalOriginal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (totalDiscount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giảm giá (15%):',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '-${NumberFormatter.formatPrice(totalDiscount)}',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (totalDiscount > 0) const SizedBox(height: 8),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormatter.formatPrice(finalTotal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _submitOrder() async {
    // Kiểm tra giỏ hàng có sản phẩm không
    if (shoppingController.shoppingItems.isEmpty) {
      Get.snackbar('Lỗi', 'Giỏ hàng của bạn đang trống',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    // Hiển thị loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Nếu không có thông tin user, dùng giá trị mặc định
      final customerName = userController.userName.value.isEmpty
          ? 'Khách hàng'
          : userController.userName.value;
      final customerPhone = '0000000000'; // Giá trị mặc định

      // Lấy địa chỉ default từ AddressRepository
      final addresses = _addressRepository.getAddresses();
      final defaultAddress =
          addresses.firstWhereOrNull((addr) => addr.isDefault);
      final customerAddress =
          defaultAddress?.fullAddress ?? 'Chưa chọn địa chỉ';

      // Chuyển đổi ShoppingItem thành ShoppingItemModel (bao gồm options + notes)
      final items = shoppingController.shoppingItems
          .map((item) => ShoppingItemModel(
                product: item.product,
                quantity: item.quantity,
                selectedOptions: item.selectedOptions,
                notes: item.notes,
              ))
          .toList();

      // Gửi API lên server và chờ response
      final success = await orderController
          .createOrder(
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        notes: '',
        items: items,
        totalPrice: shoppingController.totalPrice.value,
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('API Timeout: Đơn hàng vẫn được gửi lên server');
          return true; // Coi như thành công vì Firestore có thể đã lưu
        },
      );

      // Đóng loading dialog
      Get.back();

      if (!success) {
        Get.snackbar('Cảnh báo',
            'Không thể gửi lên server, nhưng đơn hàng đã được lưu cục bộ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
      }

      // Tạo số đơn hàng
      final orderNumber =
          'ORDS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      final totalAmount = shoppingController.totalPrice.value;

      // Thêm thông báo đặt hàng thành công
      notificationController.addNotification(
        'Đặt hàng thành công! Mã đơn: $orderNumber, Tổng cộng: ${NumberFormatter.formatCurrency(totalAmount)}',
      );

      // Clear giỏ hàng
      shoppingController.clearShopping();

      // Điều hướng tới OrderConfirmationScreen
      Get.off(() => OrderConfirmationScreen(
            orderNumber: orderNumber,
            totalAmount: totalAmount,
          ));
    } catch (e) {
      // Đóng loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      print('Error creating order: $e');
      Get.snackbar('Lỗi', 'Lỗi: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
