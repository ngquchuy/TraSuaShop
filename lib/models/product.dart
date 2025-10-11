import 'dart:isolate';

class Product {
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String descriptions;

  const Product(
      {required this.category,
      required this.price,
      this.oldPrice,
      required this.imageUrl,
      this.isFavorite = false,
      required this.descriptions,
      required this.name});
}

final List<Product> products = [
  const Product(
    name: 'Trà Sữa Trân Châu Đường Đen',
    category: 'Trà Sữa',
    price: 45000,
    oldPrice: 50000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Trà sữa béo ngậy, trân châu dai mềm, đường đen thơm lừng.',
  ),
  const Product(
    name: 'Hồng Trà Kem Cheese',
    category: 'Hồng Trà',
    price: 40000,
    oldPrice: 42000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Hồng trà đậm vị kết hợp lớp kem cheese mặn mặn béo béo.',
  ),
  const Product(
    name: 'Trà Đào Cam Sả',
    category: 'Trà Trái Cây',
    price: 35000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Hương vị đào tươi mát, cam sả thanh lọc cơ thể.',
  ),
  const Product(
    name: 'Trà Sữa Khoai Môn',
    category: 'Trà Sữa',
    price: 48000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Trà sữa vị khoai môn tự nhiên, bùi và thơm.',
  ),
  const Product(
    name: 'Hồng Trà Chanh Leo',
    category: 'Hồng Trà',
    price: 38000,
    oldPrice: 45000,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: false,
    descriptions: 'Vị chua ngọt hài hòa của chanh leo và hồng trà.',
  ),
  const Product(
    name: 'Trà Vải Thiều',
    category: 'Trà Trái Cây',
    price: 39000,
    oldPrice: null,
    imageUrl: 'assets/images/bubble-tea-png-graphic-clipart.png',
    isFavorite: true,
    descriptions: 'Những múi vải tươi mọng kết hợp trà xanh thanh mát.',
  ),
];
