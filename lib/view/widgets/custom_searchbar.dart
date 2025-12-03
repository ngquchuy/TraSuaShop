import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';

class CustomSearchbar extends StatelessWidget {
  const CustomSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi controller để dùng hàm search
    final controller = Get.find<ShoppingController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          // Bắt sự kiện khi gõ chữ
          onChanged: (value) {
            controller.searchProducts(value);
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm trà sữa...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // Nút xóa nhanh (Option)
            suffixIcon: IconButton(
              icon: const Icon(Icons.filter_list), // Icon lọc (trang trí cho đẹp)
              onPressed: () {
                // Sau này có thể mở BottomSheet để lọc nâng cao (Giá, Danh mục...)
                Get.snackbar("Thông báo", "Tính năng lọc nâng cao đang phát triển");
              },
            ),
          ),
        ),
      ),
    );
  }
}