import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lọc sản phẩm',
                    style: AppTextstyles.withColor(
                      AppTextstyles.h3,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Khoảng giá',
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Thấp',
                        suffixText: 'đ',
                        prefixIcon: Icon(Icons.attach_money,
                            color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cao',
                        suffixText: 'đ',
                        prefixIcon: Icon(Icons.attach_money,
                            color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Loại trà',
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All',
                  'Trà sữa',
                  'Trà trái cây',
                  'Hồng trà',
                ]
                    .map((category) => FilterChip(
                          label: Text(category),
                          selected: category == 'All',
                          onSelected: (selected) {},
                          backgroundColor: Theme.of(context).cardColor,
                          selectedColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          labelStyle: AppTextstyles.withColor(
                            AppTextstyles.bodyMedium,
                            category == 'All'
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodyLarge!.color!,
                          ),
                        ))
                    .toList(),
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
                    'Áp dụng lọc',
                    style: AppTextstyles.withColor(
                        AppTextstyles.buttonMedium, Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
