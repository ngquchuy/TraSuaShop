import 'package:get/get.dart';
import 'package:milktea_shop/models/product.dart';

class ShoppingItem {
  final Product product;
  int quantity;

  ShoppingItem({required this.product, this.quantity = 1});
}

class ShoppingController extends GetxController {
  var shoppingItems = <ShoppingItem>[].obs;
  var totalPrice = 0.0.obs;

  /// Cập nhật tổng tiền
  void updateTotal() {
    totalPrice.value = shoppingItems.fold(
      0.0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  /// Thêm sản phẩm vào giỏ
  void addToShopping(Product product) {
    final existing = shoppingItems
        .firstWhereOrNull((item) => item.product.name == product.name);

    if (existing != null) {
      existing.quantity++;
    } else {
      shoppingItems.add(ShoppingItem(product: product));
    }

    shoppingItems.refresh(); // 👈 Bắt buộc để UI cập nhật
    updateTotal();
  }

  /// Giảm số lượng sản phẩm
  void decreaseQuantity(ShoppingItem item) {
    final index = shoppingItems.indexOf(item);
    if (index != -1) {
      if (shoppingItems[index].quantity > 1) {
        shoppingItems[index].quantity--;
      } else {
        shoppingItems.removeAt(index);
      }
      shoppingItems.refresh(); // 👈 Cập nhật reactive
      updateTotal();
    }
  }

  /// Xóa sản phẩm khỏi giỏ
  void removeFromShopping(ShoppingItem item) {
    shoppingItems.remove(item);
    shoppingItems.refresh(); // 👈 Bảo đảm UI cập nhật
    updateTotal();
  }

  /// Xóa toàn bộ giỏ hàng
  void clearShopping() {
    shoppingItems.clear();
    updateTotal();
  }
}
