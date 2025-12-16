import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/shopping_controller.dart';
import 'package:milktea_shop/controllers/wish_list_controller.dart'; // Import WishListController
import 'package:milktea_shop/models/item_option.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus
import 'package:milktea_shop/view/shopping_screen.dart'; // Import ShoppingScreen để chuyển hướng
import 'package:milktea_shop/utils/number_formatter.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<OptionGroup> _optionGroups;
  int _quantity = 1;
  late TextEditingController _noteController;

  // Gọi các Controller cần thiết
  final ShoppingController shoppingController = Get.find<ShoppingController>();
  // Khởi tạo WishListController (nếu chưa có thì Get.put, nếu có rồi thì Get.find)
  // Ở đây dùng Get.put để đảm bảo nó tồn tại nếu người dùng vào thẳng trang chi tiết
  final WishListController wishListController = Get.put(WishListController());

  @override
  void initState() {
    super.initState();
    _optionGroups = _createInitialOptionGroups();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<OptionGroup> _createInitialOptionGroups() {
    return [
      OptionGroup(
        title: 'Kích Cỡ',
        isRequired: true,
        isSingleChoice: true,
        options: [
          ItemOption(name: 'Size M', price: 0.0),
          ItemOption(name: 'Size L', price: 5000),
          ItemOption(name: 'Size XL', price: 10000),
        ],
      ),
      OptionGroup(
        title: 'Mức Đường',
        isRequired: true,
        isSingleChoice: true,
        options: [
          ItemOption(name: '100% Đường'),
          ItemOption(name: '70% Đường', isSelected: true),
          ItemOption(name: '50% Đường'),
          ItemOption(name: '30% Đường'),
          ItemOption(name: 'Không Đường'),
        ],
      ),
      OptionGroup(
        title: 'Topping',
        isRequired: false,
        isSingleChoice: false,
        options: [
          ItemOption(name: 'Trân châu đen', price: 5000),
          ItemOption(name: 'Thạch phô mai', price: 8000),
          ItemOption(name: 'Kem Cheese', price: 12000),
          ItemOption(name: 'Nước cơm', price: 3000),
          ItemOption(name: 'Sương sáo', price: 4000),
        ],
      ),
    ];
  }

  void _handleOptionSelection(int groupIndex, int optionIndex) {
    setState(() {
      final group = _optionGroups[groupIndex];
      final option = group.options[optionIndex];

      if (group.isSingleChoice) {
        if (!option.isSelected) {
          for (var opt in group.options) {
            opt.isSelected = false;
          }
          option.isSelected = true;
        }
      } else {
        option.isSelected = !option.isSelected;
      }
    });
  }

  double _calculateTotalPrice() {
    double basePrice = widget.product.price;
    double optionPrice = 0.0;

    for (var group in _optionGroups) {
      for (var option in group.options) {
        if (option.isSelected) {
          optionPrice += option.price;
        }
      }
    }
    return basePrice + optionPrice;
  }

  // Hàm tính tổng giá với giảm giá nếu số lượng > 20
  double _calculateFinalTotal() {
    double pricePerUnit = _calculateTotalPrice();
    double total = pricePerUnit * _quantity;

    // Áp dụng giảm giá 15% nếu số lượng > 20
    if (_quantity > 20) {
      total = total * 0.85; // Giảm 15%
    }
    return total;
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1) {
      setState(() {
        _quantity = newQuantity;
      });

      // Hiển thị thông báo giảm giá nếu số lượng > 20
      if (newQuantity > 20) {
        Get.snackbar(
          'Ưu đãi đặc biệt!',
          'Bạn sẽ được giảm 15% cho đơn hàng này',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    }
  }

  // --- 1. HÀM SỬA LỖI ĐƯỜNG DẪN ẢNH ---
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

  // --- 2. WIDGET HIỂN THỊ ẢNH (CẬP NHẬT) ---
  Widget _buildImage(String rawUrl) {
    // Bước 1: Sửa đường dẫn trước
    final String finalUrl = fixImageUrl(rawUrl);

    if (finalUrl.isEmpty) {
      return const Icon(Icons.image_not_supported,
          color: Colors.grey, size: 80);
    }

    // Bước 2: Nếu là link HTTP (sau khi đã sửa) -> Dùng Image.network
    if (finalUrl.startsWith('http')) {
      return Image.network(
        finalUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (c, o, s) => const Center(
            child: Icon(Icons.broken_image, color: Colors.red, size: 80)),
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
    return Image.asset(
      finalUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (c, o, s) => const Center(
          child: Icon(Icons.broken_image, color: Colors.red, size: 80)),
    );
  }

  // Hàm chia sẻ sản phẩm
  Future<void> _shareProduct(
      BuildContext context, String name, String desc) async {
    // Code xử lý share
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      '$name\n$desc',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        actions: [
          // Nút share
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: () => _shareProduct(
                      context,
                      widget.product.name,
                      widget.product.descriptions,
                    ),
                icon: const Icon(Icons.share, color: Colors.white)),
          ),
          // Nút giỏ hàng (Thêm vào để tiện chuyển trang)
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: () => Get.to(() => ShoppingScreen()),
                icon: const Icon(Icons.shopping_cart, color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ẢNH SẢN PHẨM ---
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: _buildImage(widget.product.imageUrl),
                      ),
                      // --- NÚT YÊU THÍCH (TIM) ---
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Obx(() {
                          // Kiểm tra xem sản phẩm này có trong danh sách yêu thích không
                          bool isFav =
                              wishListController.isFavorite(widget.product);
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ]),
                            child: IconButton(
                              onPressed: () {
                                // Gọi hàm toggleFavorite từ WishListController
                                wishListController
                                    .toggleFavorite(widget.product);
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  // --- THÔNG TIN CHI TIẾT ---
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: AppTextstyles.withColor(
                                  AppTextstyles.h2,
                                  Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .color!,
                                ),
                              ),
                            ),
                            Text(
                              NumberFormatter.formatPrice(widget.product.price),
                              style: AppTextstyles.withColor(
                                AppTextstyles.h2,
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.category,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Đánh giá & Đã bán
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.rating > 0
                                  ? widget.product.rating.toStringAsFixed(1)
                                  : 'N/A',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 20),
                            Icon(Icons.shopping_bag_outlined,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                size: 18),
                            const SizedBox(width: 4),
                            Text('Đã bán: ${widget.product.soldCount}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),

                        // Mô tả
                        const Text("Mô tả",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.descriptions.isNotEmpty
                              ? widget.product.descriptions
                              : "Chưa có mô tả.",
                          style:
                              TextStyle(color: Colors.grey[600], height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  // Danh sách Option
                  _buildOptionGroups(context),
                  _buildNoteSection(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildOptionGroups(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: _optionGroups.map((group) {
          int groupIndex = _optionGroups.indexOf(group);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  '${group.title}${group.isRequired ? ' (Bắt buộc)' : ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ...group.options.map((option) {
                int optionIndex = group.options.indexOf(option);
                final priceText = option.price > 0
                    ? ' (+${NumberFormatter.formatCurrency(option.price)}đ)'
                    : '';

                if (group.isSingleChoice) {
                  return RadioListTile<bool>(
                    title: Text('${option.name}$priceText'),
                    value: true,
                    groupValue: option.isSelected,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) =>
                        _handleOptionSelection(groupIndex, optionIndex),
                  );
                } else {
                  return CheckboxListTile(
                    title: Text('${option.name}$priceText'),
                    value: option.isSelected,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) =>
                        _handleOptionSelection(groupIndex, optionIndex),
                  );
                }
              }).toList(),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    double pricePerUnit = _calculateTotalPrice();
    double currentTotal = _calculateFinalTotal();
    double discountAmount =
        (_quantity > 20) ? (pricePerUnit * _quantity * 0.15) : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_quantity > 20) ...[
                      const Text('Tổng (gốc):'),
                      Text(
                        NumberFormatter.formatPrice(pricePerUnit * _quantity),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    const Text('Tổng cộng:'),
                    Text(
                      'Giảm ${_quantity > 20 ? '15%' : '0%'}: -${NumberFormatter.formatPrice(discountAmount)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: discountAmount > 0 ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      NumberFormatter.formatPrice(currentTotal),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onPressed: () => _updateQuantity(_quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('$_quantity', style: AppTextstyles.h3),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onPressed: () => _updateQuantity(_quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Thêm vào Giỏ hàng',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  bool _isSelectionValid() {
    for (var group in _optionGroups) {
      if (group.isRequired) {
        if (!group.options.any((option) => option.isSelected)) {
          return false;
        }
      }
    }
    return true;
  }

  void _addToCart() {
    if (_isSelectionValid()) {
      // Thêm toàn bộ số lượng cùng lúc (thay vì thêm từng cái một)
      shoppingController.addToShopping(
        widget.product,
        options: _optionGroups,
        notes: _noteController.text.trim(),
        quantity: _quantity,
      );

      // Hiển thị thông báo thành công
      Get.snackbar(
        'Thành công',
        '${widget.product.name} × $_quantity đã thêm vào giỏ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );

      // Chuyển sang ShoppingScreen sau 1 giây
      Future.delayed(const Duration(seconds: 1), () {
        Get.to(() => ShoppingScreen());
      });
    } else {
      Get.snackbar(
        'Vui lòng chọn đầy đủ các tùy chọn bắt buộc!',
        '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      );
    }
  }

  Widget _buildNoteSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ghi chú thêm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Ví dụ: Ít đá, nhiều trân châu...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
