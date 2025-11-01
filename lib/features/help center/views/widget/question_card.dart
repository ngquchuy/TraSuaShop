import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class QuestionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const QuestionCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ), // BoxShadow
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: AppTextstyles.withColor(
            AppTextstyles.bodyMedium,
            Theme.of(context).textTheme.bodyLarge!.color!,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          size: 16,
        ),
        onTap: () => _showAnswerBottomSheet(context, title, isDark),
      ),
    );
  }

  void _showAnswerBottomSheet(
      BuildContext context, String question, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: AppTextstyles.withColor(
                      AppTextstyles.h3,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                  ), // Icon
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              _getAnswer(question),
              style: AppTextstyles.withColor(
                AppTextstyles.bodyMedium,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Đã hiểu',
                  style: AppTextstyles.withColor(
                    AppTextstyles.buttonMedium,
                    Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String _getAnswer(String question) {
    final answers = {
      'Làm thế nào để theo dõi đơn hàng của tôi?': 'Để theo dõi đơn hàng của bạn:\n\n'
          '1. Vào mục "Đơn hàng của tôi" (My Orders) trong tài khoản của bạn\n'
          '2. Chọn đơn hàng bạn muốn theo dõi\n'
          '3. Nhấn vào "Theo dõi đơn hàng" (Track Order)\n'
          '4. Bạn sẽ thấy các cập nhật theo thời gian thực về vị trí kiện hàng của mình\n\n'
          'Bạn cũng có thể nhấp vào số theo dõi trong email xác nhận đơn hàng để theo dõi kiện hàng trực tiếp.',
      'Làm thế nào để trả lại hàng?': 'Để trả lại hàng:\n\n'
          '1. Vào mục "Đơn hàng của tôi" (My Orders) trong tài khoản của bạn\n'
          '2. Chọn đơn hàng có món hàng bạn muốn trả lại\n'
          '3. Nhấn vào "Trả lại hàng" (Return Item)\n'
          '4. Chọn lý do trả lại\n'
          '5. In nhãn trả hàng (return label)\n'
          '6. Đóng gói món hàng cẩn thận\n'
          '7. Mang kiện hàng đến điểm gửi hàng gần nhất\n\n'
          'Yêu cầu trả hàng phải được thực hiện trong vòng 30 ngày kể từ ngày giao hàng. Sau khi chúng tôi nhận được món hàng, tiền hoàn lại của bạn sẽ được xử lý trong vòng 5-7 ngày làm việc.'
    };

    return answers[question] ??
        'Thông tin hiện không khả dụng. Vui lòng liên hệ ngay với nhân viên hỗ trợ của chúng tôi';
  }
}
