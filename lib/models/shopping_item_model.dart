import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/models/item_option.dart';

class ShoppingItemModel {
  final Product product;
  final int quantity;
  final List<OptionGroup> selectedOptions;
  final String notes;

  ShoppingItemModel({
    required this.product,
    required this.quantity,
    this.selectedOptions = const [],
    this.notes = '',
  });

  // Tính tổng giá của item (giá sản phẩm x số lượng)
  double get totalPrice => product.price * quantity;
}
