import 'package:flutter/material.dart';
import 'package:milktea_shop/features/help%20center/views/widget/question_card.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class PopularQuestionsSection extends StatelessWidget {
  const PopularQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Một số câu hỏi phổ biến',
            style: AppTextstyles.withColor(
              AppTextstyles.h3,
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          const SizedBox(height: 16),
          const QuestionCard(
            title: 'Làm thế nào để theo dõi đơn hàng của tôi?',
            icon: Icons.local_shipping_outlined,
          ),
          const SizedBox(height: 12),
          const QuestionCard(
            title: 'Làm thế nào để trả đơn hàng?',
            icon: Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }
}
