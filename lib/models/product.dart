import 'package:milktea_shop/models/item_option.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String descriptions;
  final int soldCount;
  final double rating;
  final List<OptionGroup> optionGroups;

  const Product({
    required this.id,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
    required this.descriptions,
    required this.name,
    this.soldCount = 0,
    this.rating = 0.0,
    this.optionGroups = const [],
  });
}

final List<Product> products = [
  Product(
    id: 1,
    name: 'Trà Sữa Trân Châu Đường Đen',
    category: 'Trà Sữa',
    price: 45000,
    oldPrice: 50000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Trà sữa béo ngậy, trân châu dai mềm, đường đen thơm lừng.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
  Product(
    id: 2,
    name: 'Hồng Trà Kem Cheese',
    category: 'Hồng Trà',
    price: 40000,
    oldPrice: 42000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Hồng trà đậm vị kết hợp lớp kem cheese mặn mặn béo béo.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
  Product(
    id: 3,
    name: 'Trà Đào Cam Sả',
    category: 'Trà Trái Cây',
    price: 35000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Hương vị đào tươi mát, cam sả thanh lọc cơ thể.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
  Product(
    id: 4,
    name: 'Trà Sữa Khoai Môn',
    category: 'Trà Sữa',
    price: 48000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Trà sữa vị khoai môn tự nhiên, bùi và thơm.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
  Product(
    id: 5,
    name: 'Hồng Trà Chanh Leo',
    category: 'Hồng Trà',
    price: 38000,
    oldPrice: 45000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Vị chua ngọt hài hòa của chanh leo và hồng trà.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
  Product(
    id: 6,
    name: 'Trà Vải Thiều',
    category: 'Trà Trái Cây',
    price: 39000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Những múi vải tươi mọng kết hợp trà xanh thanh mát.',
    soldCount: 1540,
    rating: 4.8,
    optionGroups: [
      OptionGroup(
        title: 'Chọn Size',
        isSingleChoice: true,
        isRequired: true,
        options: [
          ItemOption(name: 'Size M', price: 0, isSelected: true),
          ItemOption(name: 'Size L', price: 5000, isSelected: false),
        ],
      ),
      OptionGroup(
        title: 'Chọn Topping',
        isSingleChoice: false, // Checkbox (Chọn nhiều)
        isRequired: false,
        options: [
          ItemOption(name: 'Trân châu trắng', price: 10000, isSelected: false),
          ItemOption(name: 'Thạch phô mai', price: 12000, isSelected: false),
        ],
      ),
    ],
  ),
];
