import 'package:get/get.dart';
import 'package:milktea_shop/models/product.dart';

class WishListController extends GetxController {
  // Danh sách sản phẩm yêu thích
  var favoriteItems = <Product>[].obs;

  // ✅ Kiểm tra xem sản phẩm có trong danh sách không
  bool isFavorite(Product product) {
    return favoriteItems.any((item) => item.id == product.id);
  }

  // ✅ Thêm hoặc gỡ bỏ yêu thích
  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      favoriteItems.removeWhere((item) => item.id == product.id);
      Get.snackbar("Yêu thích", "Đã xóa khỏi danh sách ❤️");
    } else {
      favoriteItems.add(product);
      Get.snackbar("Yêu thích", "Đã thêm vào danh sách ❤️");
    }
  }

  // ✅ Xóa toàn bộ
  void clearFavorites() {
    favoriteItems.clear();
    Get.snackbar("Yêu thích", "Đã xóa toàn bộ danh sách");
  }
}
