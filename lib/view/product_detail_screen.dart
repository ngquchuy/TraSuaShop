import 'package:flutter/material.dart';
import 'package:milktea_shop/models/item_option.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<OptionGroup> _optionGroups;

  @override
  void initState() {
    super.initState();
    _optionGroups = _createInitialOptionGroups();
  }

  List<OptionGroup> _createInitialOptionGroups() {
    return [
      OptionGroup(
        title: 'Kích Cỡ',
        isRequired: true,
        isSingleChoice: true,
        options: [
          ItemOption(name: 'Size M', price: 0.0, isSelected: true),
          ItemOption(name: 'Size L', price: 10000),
          ItemOption(name: 'Size XL', price: 15000),
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
        title: 'Thêm Topping',
        isRequired: false,
        isSingleChoice: false,
        options: [
          ItemOption(name: 'Trân châu đen', price: 5000),
          ItemOption(name: 'Thạch phô mai', price: 8000),
          ItemOption(name: 'Kem Cheese', price: 12000),
          ItemOption(name: 'Bánh Plan', price: 10000),
        ],
      ),
      OptionGroup(
        title: 'Đá',
        isRequired: false,
        isSingleChoice: true,
        options: [
          ItemOption(name: 'Nhiều đá'),
          ItemOption(name: 'Ít đá', isSelected: true),
          ItemOption(name: 'Không đá'),
        ],
      ),
      // ... Thêm các OptionGroup khác ...
    ];
  }

  // Hàm xử lý logic chọn option
  void _handleOptionSelection(int groupIndex, int optionIndex) {
    setState(() {
      final group = _optionGroups[groupIndex];
      final option = group.options[optionIndex];

      if (group.isSingleChoice) {
        // Radio (Chọn 1)
        if (!option.isSelected) {
          group.options.forEach((opt) => opt.isSelected = false);
          option.isSelected = true;
        }
      } else {
        // Checkbox (Chọn nhiều)
        option.isSelected = !option.isSelected;
      }
    });
  }

// Hàm tính tổng giá hiện tại
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

  int _quantity = 1;

//Tang giam so luong
  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1) {
      setState(() {
        _quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      // Thanh app bar với nút back
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
        ),
        title: Text(
          'Chi tiết',
          style: AppTextstyles.withColor(
            AppTextstyles.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          //share button
          IconButton(
              onPressed: () => _shareProduct(
                    context,
                    widget.product.name,
                    widget.product.descriptions,
                  ),
              icon: Icon(
                Icons.share,
                color: isDark ? Colors.white : Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        widget.product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.product.isFavorite
                            ? Theme.of(context).primaryColor
                            : (isDark ? Colors.white : Colors.black),
                      )),
                ),
              ],
            ),
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
                            Theme.of(context).textTheme.headlineMedium!.color!,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.product.price.toStringAsFixed(0)}đ',
                        style: AppTextstyles.withColor(
                          AppTextstyles.h2,
                          Theme.of(context).textTheme.headlineMedium!.color!,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      //size
                    ],
                  ),
                  Text(
                    widget.product.category,
                    style: AppTextstyles.withColor(
                      AppTextstyles.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      // Hiển thị Rating
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating > 0
                            ? widget.product.rating.toStringAsFixed(1)
                            : 'Chưa có đánh giá',
                        style: AppTextstyles.bodyMedium,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // Hiển thị Số lượng đã bán
                      Icon(Icons.shopping_bag_outlined,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Đã bán: ${widget.product.soldCount}',
                        style: AppTextstyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            _buildOptionGroups(context),
            _buildNoteSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildOptionGroups(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(7),
      child: ListView.builder(
        // Dùng shrinkWrap và NeverScrollableScrollPhysics để ListView lồng vào SingleChildScrollView
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _optionGroups.length,
        itemBuilder: (context, groupIndex) {
          final group = _optionGroups[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 10,
                indent: 0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, bottom: 8.0, right: 0),
                child: Text(
                  '${group.title}${group.isRequired ? ' *Bắt buộc' : ''}',
                  textAlign: TextAlign.right,
                  style: AppTextstyles.withColor(
                    AppTextstyles.h3,
                    Theme.of(context).textTheme.headlineMedium!.color!,
                  ),
                ),
              ),
              ...List.generate(group.options.length, (optionIndex) {
                final option = group.options[optionIndex];
                final priceText = option.price > 0
                    ? ' (+${option.price.toStringAsFixed(0)}đ)'
                    : '';

                if (group.isSingleChoice) {
                  // Radio Button (Single Choice)
                  return Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        indent: 16,
                      ),
                      RadioListTile<bool>(
                        dense: true,
                        title: Text('${option.name}$priceText'),
                        value: true,
                        groupValue: option.isSelected,
                        onChanged: (bool? value) {
                          _handleOptionSelection(groupIndex, optionIndex);
                        },
                      ),
                    ],
                  );
                } else {
                  // Checkbox (Multiple Choice)
                  return Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        indent: 16,
                      ),
                      CheckboxListTile(
                        dense: true,
                        title: Text('${option.name}$priceText'),
                        value: option.isSelected,
                        onChanged: (bool? value) {
                          _handleOptionSelection(groupIndex, optionIndex);
                        },
                      ),
                    ],
                  );
                }
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    // Tính tổng giá hiện tại bao gồm cả số lượng
    double currentTotal = _calculateTotalPrice() * _quantity;

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
      child: Column(
        mainAxisSize: MainAxisSize.min, // Giữ container nhỏ nhất có thể
        children: [
          // HÀNG 1: Tổng cộng (trái) và Bộ điều chỉnh số lượng (phải)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tổng cộng (TRÁI)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: AppTextstyles.bodyMedium,
                  ),
                  Text(
                    '${currentTotal.toStringAsFixed(0)}đ', // Giá đã nhân với số lượng
                    style: AppTextstyles.withColor(
                      AppTextstyles.h2, // Tăng kích thước font cho nổi bật
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),

              // Bộ điều chỉnh số lượng (PHẢI)
              Row(
                children: [
                  // Nút Giảm số lượng
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onPressed: () => _updateQuantity(_quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_quantity',
                      style: AppTextstyles.h3,
                    ),
                  ),
                  // Nút Tăng số lượng
                  _buildQuantityButton(
                    icon: Icons.add,
                    onPressed: () => _updateQuantity(_quantity + 1),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16), // Khoảng cách giữa hàng 1 và nút

          // HÀNG 2: Nút Thêm vào Giỏ hàng
          SizedBox(
            width: double.infinity, // Mở rộng toàn bộ chiều rộng
            child: ElevatedButton(
              onPressed: _addToCart, // Gắn hàm _addToCart
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Thêm vào Giỏ hàng',
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyLarge,
                  Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
    );
  }

  //share product
  Future<void> _shareProduct(
    BuildContext context,
    String productName,
    String description,
  ) async {
    //get the render box for share position origin (required for iPad)
    final box = context.findRenderObject() as RenderBox?;

    const String shopLink = 'https://yourshop.com/product/cotton-tshirt';
    final String shareMessage = '$description\n\nShop now at $shopLink';

    try {
      final ShareResult result = await Share.share(
        shareMessage,
        subject: productName,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      if (result.status == ShareResultStatus.success) {
        debugPrint('Cảm ơn đã chia sẻ!');
      }
    } catch (e) {
      debugPrint('Lỗi chia sẻ: $e');
    }
  }

  bool _isSelectionValid() {
    for (var group in _optionGroups) {
      if (group.isRequired) {
        // Kiểm tra xem có bất kỳ tùy chọn nào được chọn trong nhóm bắt buộc này không
        if (!group.options.any((option) => option.isSelected)) {
          return false; // Phát hiện nhóm bắt buộc chưa được chọn
        }
      }
    }
    return true; // Tất cả các nhóm bắt buộc đều đã được chọn
  }

  void _addToCart() {
    if (_isSelectionValid()) {
      // 1. Logic thêm sản phẩm vào giỏ hàng thực tế sẽ ở đây
      //    Ví dụ: addProductToCart(widget.product, _optionGroups, _calculateTotalPrice());

      // 2. Thông báo thành công cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã thêm ${widget.product.name} vào giỏ hàng!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // 3. Thông báo lỗi nếu thiếu tùy chọn bắt buộc
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng chọn đầy đủ các tùy chọn bắt buộc!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildNoteSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              'Ghi chú thêm',
              style: AppTextstyles.withColor(
                AppTextstyles.h3,
                Theme.of(context).textTheme.headlineMedium!.color!,
              ),
            ),
          ),
          // Sử dụng TextField (hoặc TextFormField) cơ bản
          TextField(
            maxLines: 4, // Cho phép nhập nhiều dòng
            onChanged: (value) {
              // Logic xử lý nội dung (nếu có, nhưng ở đây chúng ta bỏ qua)
              debugPrint('Ghi chú đã nhập: $value');
            },
            decoration: InputDecoration(
              hintText: 'Ví dụ: Ít đường hơn một chút, hoặc thêm ống hút...',
              hintStyle: AppTextstyles.bodyMedium.copyWith(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: AppTextstyles.bodyMedium,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
