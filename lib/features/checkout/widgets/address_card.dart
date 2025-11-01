import 'package:flutter/material.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Home',
                      style: AppTextstyles.withColor(
                        AppTextstyles.bodyLarge,
                        Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ), // Text
                    const SizedBox(height: 4),
                    Text(
                      '45 Ngõ 521 Trương Định, Quận Hoàng Mai\nHà Nội',
                      style: AppTextstyles.withColor(
                        AppTextstyles.bodySmall,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ), // Text
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
