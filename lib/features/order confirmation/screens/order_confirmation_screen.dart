import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/utils/number_formatter.dart';
import 'package:milktea_shop/view/main_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderNumber;
  final double totalAmount;
  const OrderConfirmationScreen(
      {super.key, required this.orderNumber, required this.totalAmount});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Hiển thị thông báo thanh toán thành công khi vào màn hình
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        '✓ Thanh toán thành công',
        'Đơn hàng #${widget.orderNumber} - Tổng: ${NumberFormatter.formatPrice(widget.totalAmount)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Đơn hàng đã hoàn thành!',
                textAlign: TextAlign.center,
                style: AppTextstyles.withColor(
                  AppTextstyles.h2,
                  isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Đơn hàng #${widget.orderNumber} đã được hoàn thành',
                textAlign: TextAlign.center,
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Tổng tiền: ${NumberFormatter.formatPrice(widget.totalAmount)}',
                textAlign: TextAlign.center,
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  Colors.green,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              ElevatedButton(
                onPressed: () {
                  // Đi đến trang lịch sử đơn hàng
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                child: Text(
                  'Theo dõi đơn hàng',
                  style: AppTextstyles.withColor(
                    AppTextstyles.buttonMedium,
                    Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                  onPressed: () {
                    Get.offAll(() => const MainScreen());
                  },
                  child: Text(
                    'Tiếp tục mua sắm',
                    style: AppTextstyles.withColor(
                      AppTextstyles.buttonMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}