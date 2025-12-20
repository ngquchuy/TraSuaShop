import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import '../../models/product.dart';
import '../../models/user_model.dart';
import '../../services/product_service.dart';

class AdminEditProductScreen extends StatefulWidget {
  final Product? product;

  const AdminEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();

  // Controllers cho thông tin cơ bản
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();

  final List<String> _categories = [
    "Trà Sữa",
    "Trà Trái Cây",
    "Cà Phê",
    "Đá Xay",
    "Topping",
    "Hồng Trà"
  ];
  String _selectedCategory = "Trà Sữa";
  bool _isAvailable = true;

  // Danh sách Topping tạm thời (để chỉnh sửa trước khi lưu)
  List<ProductTopping> _toppings = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Load dữ liệu cũ
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toStringAsFixed(0);
      _descController.text = widget.product!.descriptions;
      _imageController.text = widget.product!.imageUrl;
      if (_categories.contains(widget.product!.category)) {
        _selectedCategory = widget.product!.category;
      }
      _isAvailable = widget.product!.isAvailable;

      // Load danh sách topping cũ
      _toppings = List.from(widget.product!.toppings);
    }
  }

  // Hàm thêm Topping mới vào danh sách tạm
  void _addToppingDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Thêm Topping"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Tên Topping (vd: Trân châu)"),
            ),
            TextField(
              controller: priceController,
              decoration:
                  const InputDecoration(labelText: "Giá thêm (vd: 5000)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                setState(() {
                  _toppings.add(ProductTopping(
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Thêm"),
          )
        ],
      ),
    );
  }

  // Hàm lưu sản phẩm lên Server
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newProduct = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text,
      descriptions: _descController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      imageUrl: _imageController.text,
      category: _selectedCategory,
      isAvailable: _isAvailable,
      toppings: _toppings, // Gửi danh sách topping đã sửa lên
    );

    final productService = ProductService();
    bool success;
    final token = userController.token.value;

    try {
      if (widget.product == null) {
        success = await productService.addProduct(newProduct, token);
      } else {
        success = await productService.updateProduct(
            widget.product!.id, newProduct, token);
      }

      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Lưu thành công!")));
      } else {
        throw Exception("Lỗi server");
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Thêm món" : "Sửa món"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // --- THÔNG TIN CƠ BẢN ---
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: "Tên món", border: OutlineInputBorder()),
                      validator: (value) =>
                          value!.isEmpty ? "Cần nhập tên món" : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                                labelText: "Giá bán",
                                border: OutlineInputBorder(),
                                suffixText: "đ"),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Cần nhập giá" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                                labelText: "Danh mục",
                                border: OutlineInputBorder()),
                            items: _categories
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCategory = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                          labelText: "Link ảnh (URL)",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                          labelText: "Mô tả", border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Đang bán (Còn hàng)"),
                      value: _isAvailable,
                      onChanged: (val) => setState(() => _isAvailable = val),
                    ),

                    const Divider(thickness: 2),

                    // --- QUẢN LÝ TOPPING ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Danh sách Topping",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: _addToppingDialog,
                          icon: const Icon(Icons.add_circle),
                          label: const Text("Thêm Topping"),
                        )
                      ],
                    ),

                    // Hiển thị danh sách Topping đang có
                    _toppings.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Chưa có topping nào",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic)),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: _toppings.asMap().entries.map((entry) {
                                int index = entry.key;
                                ProductTopping t = entry.value;
                                return ListTile(
                                  dense: true,
                                  title: Text(t.name),
                                  subtitle:
                                      Text("+${t.price.toStringAsFixed(0)} đ"),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        _toppings.removeAt(index);
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                    const SizedBox(height: 50), // Khoảng trống dưới cùng
                  ],
                ),
              ),
            ),
    );
  }
}
