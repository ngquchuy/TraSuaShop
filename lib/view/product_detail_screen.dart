import 'package:flutter/material.dart';
import 'package:milktea_shop/models/product.dart';
// import 'package:milktea_shop/utils/app_textstyles.dart'; // Đảm bảo đã import nếu cần

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  // Hàm tiện ích để định dạng tiền tệ
  String _formatPrice(double price) {
    // Tùy chỉnh định dạng tiền tệ Việt Nam nếu cần, hiện tại dùng định dạng USD
    return '\$${price.toStringAsFixed(0)}'; 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Thanh app bar với nút back
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent, // Làm appbar trong suốt
        elevation: 0,
      ),
      
      // Nút "Thêm vào giỏ hàng" cố định ở dưới
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Xử lý logic Thêm vào Giỏ hàng
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đã thêm ${product.name} vào giỏ hàng!')),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'THÊM VÀO GIỎ (${_formatPrice(product.price)})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      
      // Nội dung chi tiết cuộn được
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KHU VỰC HÌNH ẢNH (Có thể dùng Stack để thêm nút Favorite)
            Stack(
              children: [
                // Hình ảnh chính
                Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  // Xử lý lỗi ảnh dự phòng
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Không tải được ảnh')),
                  ),
                ),
                
                // Nút Favorite (Tùy chọn)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: Icon(
                        product.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        // TODO: Xử lý logic Yêu thích
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            // 2. KHU VỰC CHI TIẾT SẢN PHẨM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.name,
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Text(
                    product.category,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Giá
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatPrice(product.price),
                        style: theme.textTheme.headlineLarge!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (product.oldPrice != null && product.oldPrice! > product.price)
                        Text(
                          _formatPrice(product.oldPrice!),
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 30),

                  // 3. KHU VỰC MÔ TẢ
                  Text(
                    'Mô tả sản phẩm',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.descriptions,
                    style: theme.textTheme.bodyLarge,
                  ),
                  // Thêm một khoảng cách lớn nếu muốn thêm các tùy chọn khác (Size, Topping,...)
                  const SizedBox(height: 50), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}