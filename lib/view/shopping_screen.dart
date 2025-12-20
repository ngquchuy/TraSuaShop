import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/services/product_service.dart';
import 'package:milktea_shop/utils/number_formatter.dart';
import 'package:milktea_shop/view/cart_screen.dart'; // Để chuyển sang giỏ hàng

class ShoppingScreen extends StatefulWidget {
  ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  // Controller giỏ hàng (để thêm món)
  final ShoppingController shoppingController = Get.find<ShoppingController>();

  // Service lấy danh sách món ăn
  final ProductService _productService = ProductService();

  List<Product> _allProducts = []; // Danh sách gốc
  List<Product> _displayProducts = []; // Danh sách hiển thị (để search)
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Hàm tải sản phẩm từ Server
  Future<void> _loadProducts() async {
    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _allProducts = products;
        _displayProducts = products; // Ban đầu hiển thị hết
        _isLoading = false;
      });
    } catch (e) {
      print("Lỗi tải sản phẩm: $e");
      setState(() => _isLoading = false);
    }
  }

  // Hàm tìm kiếm
  void _filterProducts(String query) {
    final filtered = _allProducts.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      _displayProducts = filtered;
    });
  }

  // Helper xử lý ảnh
  String fixImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }
    if (!url.startsWith('http')) {
      if (url.startsWith('/')) return 'http://10.0.2.2:5001$url';
      return 'http://10.0.2.2:5001/$url';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực đơn'),
        centerTitle: true,
        actions: [
          // Nút giỏ hàng trên AppBar
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Get.to(() => CartScreen()),
              ),
              Obx(() => shoppingController.count > 0
                  ? Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${shoppingController.count}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          // --- THANH TÌM KIẾM ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Tìm kiếm món ăn...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // --- DANH SÁCH MÓN ĂN (GRID) ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _displayProducts.isEmpty
                    ? const Center(child: Text("Không tìm thấy sản phẩm nào"))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 cột
                          childAspectRatio:
                              0.75, // Tỷ lệ khung hình (Cao hơn rộng)
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _displayProducts.length,
                        itemBuilder: (context, index) {
                          final product = _displayProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị từng món
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    fixImageUrl(product.imageUrl),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child:
                          const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
                // Nếu hết hàng thì hiện nhãn
                if (!product.isAvailable)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Text("HẾT HÀNG",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
              ],
            ),
          ),

          // Thông tin món
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormatter.formatPrice(product.price),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Nút thêm vào giỏ
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: product.isAvailable
                  ? () {
                      // Logic thêm vào giỏ
                      // Nếu muốn chọn Topping thì cần mở Dialog ở đây.
                      // Tạm thời thêm mặc định (không topping)
                      shoppingController.addToShopping(product);
                      Get.snackbar(
                        "Thêm thành công",
                        "Đã thêm ${product.name} vào giỏ",
                        duration: const Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(10),
                      );
                    }
                  : null, // Disable nếu hết hàng
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text("Thêm vào giỏ",
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
