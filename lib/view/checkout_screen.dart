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
            const Text('Sản phẩm đã chọn',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildProductsList(),
            const SizedBox(height: 24),
            const Text('Địa chỉ nhận hàng',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const AddressCard(),
            const SizedBox(height: 24),
            const Text('Tóm tắt đơn hàng',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const OrderSummaryCard(),
            const SizedBox(height: 24),
            const Text('Phương thức thanh toán',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const PaymentMethodCard(),
          ],
        ),
      ),
      // Sử dụng Obx để cập nhật trạng thái nút bấm (Enable/Disable) khi đang loading
      bottomNavigationBar: Obx(() => CheckoutBottomBar(
            totalAmount: shoppingController.totalPrice.value,
            onPlaceOrder:
                orderController.isLoading.value ? () {} : _submitOrder,
          )),
    );
  }

  Widget _buildProductsList() {
    return Obx(() {
      if (shoppingController.shoppingItems.isEmpty) {
        return const Center(child: Text('Giỏ hàng trống'));
      }
      return Column(
        children: List.generate(
          shoppingController.shoppingItems.length,
          (index) {
            final item = shoppingController.shoppingItems[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.product.imageUrl.isNotEmpty
                          ? Image.network(item.product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 60))
                          : const Icon(Icons.image, size: 60),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${item.quantity} x ${item.product.price.toStringAsFixed(0)} đ'),
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

  // --- HÀM ĐÃ SỬA LẠI LOGIC ---
  void _submitOrder() async {
    if (shoppingController.shoppingItems.isEmpty) {
      Get.snackbar('Lỗi', 'Giỏ hàng trống',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // 1. Hiện Loading
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      // Lấy thông tin user
      // LƯU Ý: Đoạn này giả định UserController của bạn dùng .obs (RxString).
      // Nếu bạn dùng String thường thì bỏ .value đi.
      final customerName = userController.userName.value.isEmpty
          ? 'Khách hàng'
          : userController.userName.value;

      final customerPhone = userController.userPhone.value.isEmpty
          ? '0000000000'
          : userController.userPhone.value;

      final addresses = _addressRepository.getAddresses();
      final defaultAddress =
          addresses.firstWhereOrNull((addr) => addr.isDefault);
      final customerAddress =
          defaultAddress?.fullAddress ?? 'Chưa chọn địa chỉ';

      // Map dữ liệu
      final items = shoppingController.shoppingItems
          .map((item) => ShoppingItemModel(
                product: item.product,
                quantity: item.quantity,
                selectedOptions: item.selectedOptions,
                notes: item.notes,
              ))
          .toList();

      // 2. QUAN TRỌNG: Thêm 'await' để chờ Server trả lời thành công/thất bại
      // Hàm createOrder cần trả về Future<bool> (True = thành công)
      final bool success = await orderController.createOrder(
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        notes: '',
        items: items,
        totalPrice: shoppingController.totalPrice.value,
      );

      // 3. Đóng Loading Dialog
      if (Get.isDialogOpen == true) Get.back();

      // 4. Xử lý kết quả
      if (success) {
        // Chỉ khi Server báo thành công (200/201) thì mới xóa giỏ hàng
        final orderNumber =
            'ORDS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        final totalAmount = shoppingController.totalPrice.value;

        shoppingController.clearShopping();

        Get.off(() => OrderConfirmationScreen(
              orderNumber: orderNumber,
              totalAmount: totalAmount,
            ));
      }
      // Nếu thất bại (success == false), OrderController đã tự hiện Snackbar báo lỗi rồi.
      // App sẽ giữ nguyên màn hình để khách thử lại, không bị mất giỏ hàng oan.
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      print('Lỗi checkout: $e');
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
