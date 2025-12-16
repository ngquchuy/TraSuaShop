import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/utils/number_formatter.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ShoppingController shoppingController =
        Get.find<ShoppingController>();

    // Tính tổng giá gốc (không giảm)
    double totalOriginal = 0.0;
    double totalDiscount = 0.0;
    for (var item in shoppingController.shoppingItems) {
      double itemTotal = item.product.price * item.quantity;
      totalOriginal += itemTotal;
      if (item.discountPercentage > 0) {
        totalDiscount += itemTotal * (item.discountPercentage / 100);
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
              context, 'Tạm tính', NumberFormatter.formatPrice(totalOriginal)),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'Phí áp dụng', '0 đ'),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'Giảm giá',
              '-${NumberFormatter.formatPrice(totalDiscount)}',
              isDiscount: totalDiscount > 0),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildSummaryRow(context, 'Tổng giá',
              NumberFormatter.formatPrice(shoppingController.totalPrice.value),
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    final textStyle = isTotal ? AppTextstyles.h3 : AppTextstyles.bodyLarge;
    Color color = Theme.of(context).textTheme.bodyLarge!.color!;

    if (isTotal) {
      color = Theme.of(context).primaryColor;
    } else if (isDiscount && value != '-0 đ') {
      color = Colors.green;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextstyles.withColor(textStyle, color),
        ),
        Text(
          value,
          style: AppTextstyles.withColor(textStyle, color),
        ),
      ],
    ); // Row
  }
}
