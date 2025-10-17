import 'package:flutter/material.dart';

import 'package:milktea_shop/models/product.dart'; 
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = products.where((p) => p.isFavorite).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh Sách Yêu Thích',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: favoriteProducts.isEmpty
          ? _buildEmptyState(theme)
          : _buildWishlist(favoriteProducts, theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: theme.primaryColor.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Danh sách yêu thích đang trống',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm sản phẩm bạn yêu thích vào đây!',
            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildWishlist(List<Product> products, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = products[index];
          return _FavoriteProductItem(
            product: product,
            theme: theme,
            onRemove: () {
              // TODO: Xử lý xóa sản phẩm khỏi Wishlist trong Controller
            },
            onAddToCart: () {
              // TODO: Xử lý thêm vào giỏ hàng trong Controller
            },
          );
        },
      ),
    );
  }
}

// Widget riêng lẻ cho mỗi sản phẩm trong Wishlist
class _FavoriteProductItem extends StatelessWidget {
  final Product product;
  final ThemeData theme;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;


  const _FavoriteProductItem({
    required this.product, 
    required this.theme, 
    required this.onRemove,
    required this.onAddToCart,
  });

  // Sử dụng Image.asset thay vì Image.network để phù hợp với imageUrl trong product.dart
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hình ảnh
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset( // Đã đổi sang Image.asset
              product.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              // Xử lý lỗi tải ảnh
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 30),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. Chi tiết sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Category
                Text(
                  product.category,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),

                // Giá
                Row(
                  children: [
                    Text(
                      _formatPrice(product.price),
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (product.oldPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _formatPrice(product.oldPrice!),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // 3. Nút hành động
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nút xóa khỏi Wishlist
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  // TODO: Xử lý logic xóa sản phẩm khỏi Wishlist
                  onRemove();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa ${product.name} khỏi Yêu thích')),
                  );
                },
              ),
              const SizedBox(height: 10),
              // Nút Thêm vào Giỏ hàng
              Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.shopping_bag_outlined, color: theme.primaryColor, size: 20),
                  onPressed: () {
                    // TODO: Xử lý logic thêm sản phẩm vào giỏ hàng
                    onAddToCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm ${product.name} vào Giỏ hàng')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Hàm định dạng tiền tệ (di chuyển ra ngoài để tránh trùng lặp)
String _formatPrice(double price) {
  return '${price.toStringAsFixed(0)} VNĐ';
}
