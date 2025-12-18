class OrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // Pending, Processing, Delivered, Cancelled
  final DateTime createdAt;
  final String notes;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.notes = '',
  });

  // --- PHẦN QUAN TRỌNG NHẤT: MAP DỮ LIỆU TỪ SERVER ---
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      // 1. Map '_id' của MongoDB sang 'id' của Flutter
      id: json['_id'] ?? json['id'] ?? '',

      customerName: json['customerName'] ?? 'Khách lẻ',

      // 2. Map field 'phone' từ Backend sang 'customerPhone'
      customerPhone: json['phone'] ?? json['customerPhone'] ?? '',

      // 3. Map field 'address' từ Backend sang 'customerAddress'
      customerAddress: json['address'] ?? json['customerAddress'] ?? '',

      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],

      totalAmount: (json['totalAmount'] ?? 0).toDouble(),

      // Backend trả về status (Pending/Processing...), giữ nguyên
      status: json['status'] ?? 'Pending',

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      notes: json['notes'] ?? '',
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final List<SelectedOption> selectedOptions;
  final String notes;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.selectedOptions,
    this.notes = '',
  });

  // Chuyển đổi từ JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? json['product'] ?? '',
      productName: json['productName'] ?? json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)
              ?.map((opt) => SelectedOption.fromJson(opt))
              .toList() ??
          [],
      notes: json['notes'] ?? '',
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'selectedOptions': selectedOptions.map((opt) => opt.toJson()).toList(),
      'notes': notes,
    };
  }
}

class SelectedOption {
  final String group;
  final String name;
  final double price;

  SelectedOption({
    required this.group,
    required this.name,
    this.price = 0,
  });

  // Chuyển đổi từ JSON
  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      group: json['group'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'name': name,
      'price': price,
    };
  }
}
