// lib/models/product.dart

class ProductTopping {
  final String name;
  final double price;

  ProductTopping({required this.name, required this.price});

  // Map từ JSON (Server -> App)
  factory ProductTopping.fromJson(Map<String, dynamic> json) {
    return ProductTopping(
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Map sang JSON (App -> Server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String descriptions;
  final int soldCount;
  final double rating;
  final bool isAvailable;

  // Danh sách Topping đi kèm món này
  final List<ProductTopping> toppings;

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
    this.isAvailable = true,
    this.toppings = const [], // Mặc định rỗng
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse mảng availableToppings từ backend
    var toppingsList = json['availableToppings'] as List<dynamic>?;
    List<ProductTopping> parsedToppings = toppingsList != null
        ? toppingsList.map((t) => ProductTopping.fromJson(t)).toList()
        : [];

    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Chưa có tên',
      category: json['category'] ?? 'Trà Sữa',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      imageUrl: json['image'] ?? '',
      descriptions: json['description'] ?? '',
      soldCount: json['soldCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      isAvailable: json['isAvailable'] ?? true,
      toppings: parsedToppings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': imageUrl,
      'description': descriptions,
      'category': category,
      'isAvailable': isAvailable,
      'availableToppings': toppings.map((t) => t.toJson()).toList(),
    };
  }
}
