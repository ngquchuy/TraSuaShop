import 'package:get/get.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/models/item_option.dart';
import '../services/api_service.dart';

// Model phụ cho giỏ hàng (Lưu sản phẩm + số lượng + options + notes)
class ShoppingItem {
  final Product product;
  int quantity;
  List<OptionGroup> selectedOptions;
  String notes;

  ShoppingItem({
    required this.product,
    this.quantity = 1,
    this.selectedOptions = const [],
    this.notes = '',
  });
}

class ShoppingController extends GetxController {
  // ==================================================
  // PHẦN 1: QUẢN LÝ DANH SÁCH SẢN PHẨM (TÌM KIẾM, TIM)
  // ==================================================
  var products = <Product>[].obs; // Danh sách gốc (Tất cả sp từ API)
  var filteredProducts =
      <Product>[].obs; // Danh sách hiển thị (Đã lọc theo từ khóa)
  var isLoading = true.obs; // Trạng thái đang tải

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Tự động tải dữ liệu khi App mở
  }

  // 1. Tải danh sách từ API
  void fetchProducts() async {
    try {
      isLoading(true);
      var list = await ApiService.fetchProducts();
      if (list.isNotEmpty) {
        products.assignAll(list);
        filteredProducts
            .assignAll(list); // Ban đầu chưa tìm kiếm gì thì hiện tất cả
      }
    } finally {
      isLoading(false);
    }
  }

  // 2. Hàm Tìm kiếm (Gọi mỗi khi gõ chữ vào thanh tìm kiếm)
  void searchProducts(String query) {
    if (query.isEmpty) {
      // Nếu xóa hết chữ -> Hiện lại toàn bộ
      filteredProducts.assignAll(products);
    } else {
      // Lọc danh sách theo tên (không phân biệt hoa thường)
      var result = products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredProducts.assignAll(result);
    }
  }

  // 3. Hàm Yêu thích (Thả tim)
  void toggleFavorite(String productId) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final old = products[index];

      // Tạo bản sao sản phẩm mới với trạng thái tim bị đảo ngược
      final newProduct = Product(
        id: old.id,
        name: old.name,
        category: old.category,
        price: old.price,
        oldPrice: old.oldPrice,
        imageUrl: old.imageUrl,
        descriptions: old.descriptions,
        soldCount: old.soldCount,
        rating: old.rating,
        isFavorite: !old.isFavorite, // <-- Đảo ngược trạng thái ở đây
      );

      // Cập nhật vào danh sách gốc
      products[index] = newProduct;

      // Cập nhật vào danh sách đang hiển thị (để UI thay đổi ngay lập tức)
      final filterIndex = filteredProducts.indexWhere((p) => p.id == productId);
      if (filterIndex != -1) {
        filteredProducts[filterIndex] = newProduct;
      }

      // Bắt buộc gọi refresh để UI vẽ lại
      products.refresh();
      filteredProducts.refresh();
    }
  }

  // ... (Dán tiếp Phần 2 vào ngay dưới dòng này)
  // ==================================================
  // PHẦN 2: QUẢN LÝ GIỎ HÀNG (ADD, REMOVE, TOTAL...)
  // ==================================================
  var shoppingItems = <ShoppingItem>[].obs;
  var totalPrice = 0.0.obs;

  // 4. Thêm vào giỏ hàng
  void addToShopping(Product product,
      {List<OptionGroup> options = const [], String notes = ''}) {
    // Kiểm tra xem sản phẩm này đã có trong giỏ chưa
    final existing =
        shoppingItems.firstWhereOrNull((item) => item.product.id == product.id);

    if (existing != null) {
      existing.quantity++; // Có rồi thì tăng số lượng
    } else {
      shoppingItems.add(
        ShoppingItem(
          product: product,
          selectedOptions: options,
          notes: notes,
        ),
      );
    }
    shoppingItems.refresh(); // Cập nhật UI giỏ hàng
    updateTotal(); // Tính lại tổng tiền

    // Hiện thông báo nhỏ (chỉ hiện nếu chưa có thông báo nào đang chạy)
    if (!Get.isSnackbarOpen) {
      Get.snackbar("Thành công", "Đã thêm ${product.name} vào giỏ",
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP);
    }
  }

  // 5. Tính tổng tiền
  void updateTotal() {
    totalPrice.value = shoppingItems.fold(
        0.0, (sum, item) => sum + item.product.price * item.quantity);
  }

  // 6. Giảm số lượng (Nút trừ trong giỏ hàng)
  void decreaseQuantity(ShoppingItem item) {
    final index = shoppingItems.indexOf(item);
    if (index != -1) {
      if (shoppingItems[index].quantity > 1) {
        shoppingItems[index].quantity--; // Giảm 1
      } else {
        shoppingItems.removeAt(index); // Hết số lượng thì xóa luôn
      }
      shoppingItems.refresh();
      updateTotal();
    }
  }

  // 7. Xóa hẳn khỏi giỏ hàng (Nút thùng rác)
  void removeFromShopping(ShoppingItem item) {
    shoppingItems.remove(item);
    shoppingItems.refresh();
    updateTotal();
  }

  // 8. Xóa sạch giỏ hàng (Sau khi thanh toán xong)
  void clearShopping() {
    shoppingItems.clear();
    totalPrice.value = 0;
  }
} // <-- Dấu ngoặc đóng class ShoppingController
