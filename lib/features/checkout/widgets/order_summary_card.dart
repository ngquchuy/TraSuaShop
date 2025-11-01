import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ShoppingController shoppingController =
        Get.find<ShoppingController>();
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
          _buildSummaryRow(context, 'Tạm tính',
              '${shoppingController.totalPrice.toStringAsFixed(0)}đ'),
          const SizedBox(
            height: 8,
          ),
          _buildSummaryRow(context, 'Phí áp dụng', '0đ'),
          const SizedBox(
            height: 8,
          ),
          _buildSummaryRow(context, 'Giảm giá', '-0đ'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildSummaryRow(context, 'Tổng giá',
              '${shoppingController.totalPrice.toStringAsFixed(0)}đ',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    final textStyle = isTotal ? AppTextstyles.h3 : AppTextstyles.bodyLarge;
    final color = isTotal
        ? Theme.of(context).primaryColor
        : Theme.of(context).textTheme.bodyLarge!.color!;

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
