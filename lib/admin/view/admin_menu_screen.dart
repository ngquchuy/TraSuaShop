import 'package:flutter/material.dart';
import '../../models/product.dart'; // Đảm bảo import đúng file model
import '../../models/user_model.dart';
import '../../services/product_service.dart';
import 'admin_edit_product_screen.dart';

class AdminMenuScreen extends StatefulWidget {
  final User user;
  const AdminMenuScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = ''; // Biến lưu thông báo lỗi

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      // Bắt lỗi và hiện lên màn hình để dễ debug
      setState(() {
        _isLoading = false;
        _errorMessage =
            "Lỗi kết nối: $e\nHãy kiểm tra lại IP trong product_service.dart";
      });
      print("Lỗi load sản phẩm: $e");
    }
  }

  Future<void> _deleteProduct(String id) async {
    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Xác nhận xóa"),
            content: const Text("Bạn có chắc muốn xóa món này không?"),
            actions: [
              TextButton(
                  child: const Text("Hủy"),
                  onPressed: () => Navigator.pop(ctx, false)),
              TextButton(
                  child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.pop(ctx, true)),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await _productService.deleteProduct(id, widget.user.token ?? '');
      _loadProducts();
    }
  }

  void _openEditScreen([Product? product]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              AdminEditProductScreen(user: widget.user, product: product)),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách Menu"),
        actions: [
          IconButton(onPressed: _loadProducts, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openEditScreen(null),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Nếu có lỗi, hiện lỗi ra giữa màn hình
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 10),
              Text(_errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _loadProducts, child: const Text("Thử lại"))
            ],
          ),
        ),
      );
    }

    // Nếu danh sách rỗng
    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fastfood_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("Chưa có món nào trong Menu.\nHãy bấm nút (+) để thêm."),
          ],
        ),
      );
    }

    // Nếu có dữ liệu, hiển thị danh sách
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported)),
              ),
            ),
            title: Text(product.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${product.price.toStringAsFixed(0)} đ"),
                if (product.isAvailable == false)
                  const Text("HẾT HÀNG",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openEditScreen(product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(product.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
