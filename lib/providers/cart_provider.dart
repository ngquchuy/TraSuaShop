import 'package:flutter/foundation.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/models/item_option.dart';

class CartItem {
  final Product product;
  final int quantity;
  final List<OptionGroup> selectedOptions;
  final double totalPrice;
  final String? note;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedOptions,
    required this.totalPrice,
    this.note,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      total += item.totalPrice * item.quantity;
    }
    return total;
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
