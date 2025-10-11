import 'package:flutter/material.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tính toán phần trăm giảm giá để điền vào banner "SALE"
    String discountText = '';
    if (product.oldPrice != null && product.oldPrice! > product.price) {
      double discountPercentage =
          ((product.oldPrice! - product.price) / product.oldPrice!) * 100;
      discountText = '-${discountPercentage.toStringAsFixed(0)}%';
    }

    return Container(
      // Giữ nguyên logic tính toán chiều rộng cho Container
      constraints: BoxConstraints(
        // Chiều rộng tối đa của Card (khoảng 165.3 pixels trong ví dụ lỗi)
        maxWidth: screenWidth * 0.9,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? Image.asset(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          // Thay thế bằng một widget dự phòng (placeholder)
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                ),
              ),
              // Favorite button
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: product.isFavorite
                        ? Theme.of(context).primaryColor
                        : isDark
                            ? Colors.grey[400]
                            : Colors.grey,
                  ),
                ),
              ),
              // Discount Banner
              if (product.oldPrice != null && product.oldPrice! > product.price)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // discount text
                    child: Text(
                      // SỬ DỤNG TEXT ĐÃ TÍNH TOÁN
                      discountText,
                      style: AppTextstyles.withColor(
                          AppTextstyles.withWeight(
                              AppTextstyles.bodySmall, FontWeight.bold),
                          Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          // product details
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn trái
              children: [
                Text(
                  product.name,
                  style: AppTextstyles.withColor(
                    AppTextstyles.withWeight(AppTextstyles.h3, FontWeight.bold),
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: screenWidth * 0.01,
                ),
                Text(
                  product.category,
                  style: AppTextstyles.withColor(AppTextstyles.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!),
                ),
                SizedBox(
                  height: screenWidth * 0.01,
                ),
                // ROW GÂY LỖI ĐÃ ĐƯỢC SỬA
                Row(
                  // Dùng MainAxisSize.min để Row chỉ chiếm đủ chỗ cần thiết
                  // mainAxisSize: MainAxisSize.min, // Nếu cần
                  children: [
                    // Giá mới (Giá hiện tại)
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextstyles.withColor(
                          AppTextstyles.withWeight(
                              AppTextstyles.bodyLarge, FontWeight.bold),
                          Theme.of(context).textTheme.bodyLarge!.color!),
                    ),

                    // Khoảng cách và Giá cũ (Chỉ hiển thị nếu có oldPrice)
                    if (product.oldPrice != null &&
                        product.oldPrice! > product.price) ...[
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),

                      // SỬ DỤNG FLEXIBLE ĐỂ GIÁ CŨ TỰ ĐỘNG CO LẠI
                      Flexible(
                        child: Text(
                          // ĐÃ SỬA: Dùng product.oldPrice
                          '\$${product.oldPrice!.toStringAsFixed(2)}',
                          style: AppTextstyles.withColor(
                            AppTextstyles.bodySmall,
                            isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ).copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                          // Đảm bảo văn bản sẽ bị cắt/ẩn đi nếu không đủ chỗ
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
