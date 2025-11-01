import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/features/checkout/widgets/address_card.dart';
import 'package:milktea_shop/features/checkout/widgets/checkout_bottom_bar.dart';
import 'package:milktea_shop/features/checkout/widgets/order_summary_card.dart';
import 'package:milktea_shop/features/checkout/widgets/payment_method_card.dart';
import 'package:milktea_shop/features/order%20confirmation/screens/order_confirmation_screen.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ShoppingController shoppingController =
        Get.find<ShoppingController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'Thông tin đơn hàng',
          style: AppTextstyles.withColor(
            AppTextstyles.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Địa chỉ nhận hàng'),
            const SizedBox(
              height: 16,
            ),
            const AddressCard(),
            const SizedBox(
              height: 24,
            ),
            _buildSectionTitle(context, 'Phương thức thanh toán'),
            const SizedBox(
              height: 16,
            ),
            const PaymentMethodCard(),
            const SizedBox(
              height: 16,
            ),
            _buildSectionTitle(context, 'Chi tiết thanh toán'),
            const OrderSummaryCard(),
          ],
        ), // Column
      ),
      bottomNavigationBar: CheckoutBottomBar(
        totalAmount: 45000,
        onPlaceOrder: () {
          final orderNumber =
              'ORDS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

          Get.to(() => OrderConfirmationScreen(
                orderNumber: orderNumber,
                totalAmount: 45000,
              ));
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextstyles.withColor(
        AppTextstyles.h3,
        Theme.of(context).textTheme.bodyLarge!.color!,
      ),
    );
  }
}
