import 'package:flutter/material.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class ContactSupportSection extends StatelessWidget {
  const ContactSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.headset_mic_outlined,
            color: Theme.of(context).primaryColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn vẫn còn vấn đề?',
            style: AppTextstyles.withColor(
              AppTextstyles.h3,
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ), // Text
          const SizedBox(height: 16),
          Text(
            'Hãy liên hệ đội ngũ của chúng tôi?',
            style: AppTextstyles.withColor(
              AppTextstyles.h3,
              isDark ? Colors.grey[400]! : Colors.grey[600]!,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ), // RoundedRectangleBorder
            ),
            child: Text(
              'Liên hệ',
              style: AppTextstyles.withColor(
                AppTextstyles.buttonMedium,
                Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
