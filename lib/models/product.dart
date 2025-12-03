import 'package:milktea_shop/models/item_option.dart';

class Product {
  final String id; // Đổi thành String để khớp với _id của MongoDB
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
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
    required this.descriptions,
    this.soldCount = 0,
    this.rating = 0.0,
    this.optionGroups = const [],
  });

  // --- QUAN TRỌNG: Hàm chuyển đổi JSON từ Server thành Object ---
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', // MongoDB trả về _id
      name: json['name'] ?? 'Chưa có tên',
      category: json['category'] ?? 'Trà sữa',
      
      // Xử lý giá: Server có thể trả về int hoặc double
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      
      // Xử lý giá cũ (nếu có)
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),

      // Xử lý ảnh: Nếu null thì để chuỗi rỗng (UI sẽ xử lý placeholder sau)
      imageUrl: json['image'] ?? '', 
      
      isFavorite: json['isFavorite'] ?? false,
      descriptions: json['description'] ?? '', // Backend bạn đang để là 'description'
      
      soldCount: json['soldCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,

      // Tạm thời để rỗng vì API hiện tại chưa trả về OptionGroup (Size, Topping)
      // Khi nào Backend làm phần Topping, ta sẽ cập nhật dòng này sau.
      optionGroups: [], 
    );
  }
}