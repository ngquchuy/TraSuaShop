import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/utils/number_formatter.dart';
import 'package:milktea_shop/view/product_detail_screen.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  // --- 1. HÀM SỬA LỖI ĐƯỜNG DẪN ẢNH ---
  // Hàm này giúp App hiển thị được ảnh từ localhost hoặc folder uploads
  String fixImageUrl(String url) {
    if (url.isEmpty) return '';

    // Nếu link chứa localhost -> Đổi thành 10.0.2.2 cho máy ảo Android
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }

    // Nếu link là đường dẫn cụt (ví dụ: "uploads/anh1.jpg") -> Nối thêm domain vào
    if (!url.startsWith('http')) {
      // Đảm bảo có dấu / ở giữa
      if (url.startsWith('/')) {
        return 'http://10.0.2.2:5001$url';
      }
      return 'http://10.0.2.2:5001/$url';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy Controller đã được khởi tạo
    final controller = Get.find<ShoppingController>();

    return Obx(() {
      // 1. Trạng thái đang tải
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // 2. Sử dụng filteredProducts (Danh sách ĐÃ LỌC) thay vì products
      // Để khi tìm kiếm, danh sách này sẽ thay đổi
      if (controller.filteredProducts.isEmpty) {
        return const Center(child: Text("Không tìm thấy sản phẩm nào"));
      }

      // 3. Hiển thị lưới sản phẩm
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              0.70, // Tỷ lệ khung hình (cao hơn chút để chứa nút tim)
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = controller.filteredProducts[index];

          return GestureDetector(
            onTap: () {
              // Chuyển sang màn hình chi tiết
              Get.to(() => ProductDetailScreen(product: product));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- A. ẢNH SẢN PHẨM ---
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: _buildImage(product.imageUrl),
                          ),
                        ),
                      ),

                      // --- B. THÔNG TIN SẢN PHẨM ---
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  NumberFormatter.formatPrice(product.price),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                // Nút thêm nhanh (+) - Navigate to ProductDetailScreen
                                InkWell(
                                  onTap: () {
                                    // Chuyển sang ProductDetailScreen thay vì add trực tiếp
                                    Get.to(() =>
                                        ProductDetailScreen(product: product));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 16),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // --- C. NÚT TIM (YÊU THÍCH) Ở GÓC TRÊN PHẢI ---
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Gọi hàm toggleFavorite trong Controller để đổi màu tim
                        controller.toggleFavorite(product.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.8), // Nền mờ cho dễ nhìn
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          // Kiểm tra trạng thái để hiện tim đỏ hoặc tim rỗng
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // --- HÀM HIỂN THỊ ẢNH (ĐÃ NÂNG CẤP) ---
  Widget _buildImage(String rawUrl) {
    // Bước 1: Sửa đường dẫn trước
    final String finalUrl = fixImageUrl(rawUrl);

    if (finalUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }

    // Bước 2: Nếu là link HTTP (sau khi đã sửa) -> Dùng Image.network
    if (finalUrl.startsWith('http')) {
      return Image.network(
        finalUrl,
        fit: BoxFit.cover,
        errorBuilder: (c, o, s) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.red)),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    // Bước 3: Trường hợp còn lại là ảnh Asset
    return Image.asset(finalUrl, fit: BoxFit.cover);
  }
}
