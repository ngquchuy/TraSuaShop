import 'package:get/get.dart';
import 'package:milktea_shop/models/product.dart';
import 'package:milktea_shop/models/item_option.dart';
import '../services/api_service.dart';

// Model phụ cho giỏ hàng
class ShoppingItem {
  final Product product;
  int quantity;
  List<OptionGroup> selectedOptions;
  String notes;
  double discountPercentage;

  ShoppingItem({
    required this.product,
    this.quantity = 1,
    this.selectedOptions = const [],
    this.notes = '',
    this.discountPercentage = 0,
  });
}

class ShoppingController extends GetxController {
  // ==================================================
  // PHẦN 1: QUẢN LÝ DANH SÁCH SẢN PHẨM
  // ==================================================
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;
  var selectedCategory = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var list = await ApiService.fetchProducts();
      if (list.isNotEmpty) {
        products.assignAll(list);
        filteredProducts.assignAll(list);
      }
    } catch (e) {
      print("Lỗi tải sản phẩm: $e");
    } finally {
      isLoading(false);
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      var result = products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredProducts.assignAll(result);
    }
  }

  // Lọc theo danh mục
  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'ALL') {
      filteredProducts.assignAll(products);
    } else {
      // Logic lọc đơn giản theo tên hoặc category
      var result = products.where((p) {
        // Nếu bạn có trường categoryId hoặc categoryName chuẩn từ server thì so sánh ở đây
        // Tạm thời so sánh theo tên category chứa trong tên sản phẩm hoặc trường category của model
        return p.category == category || p.name.contains(category);
      }).toList();
      filteredProducts.assignAll(result);
    }
  }

  // ==================================================
  // PHẦN 2: QUẢN LÝ GIỎ HÀNG (ĐÃ SỬA LỖI TÍNH TIỀN)
  // ==================================================
  var shoppingItems = <ShoppingItem>[].obs;
  var totalPrice = 0.0.obs;

  // --- 1. THÊM MỚI: Getter đếm tổng số lượng item để hiện Badge đỏ ---
  int get count => shoppingItems.fold(0, (sum, item) => sum + item.quantity);

  // 4. Thêm vào giỏ hàng (Đã nâng cấp logic merge)
  void addToShopping(Product product,
      {List<OptionGroup> options = const [],
      String notes = '',
      int quantity = 1}) {
    // Logic tìm sản phẩm trùng: Phải trùng cả ID lẫn Option
    // (Tạm thời để đơn giản: Luôn thêm mới nếu có option khác nhau.
    // Nếu muốn merge chính xác cần so sánh sâu list options).

    // Cách đơn giản: Tìm item có cùng ID
    final existingIndex =
        shoppingItems.indexWhere((item) => item.product.id == product.id);

    // Ở đây ta chấp nhận logic đơn giản: Nếu sản phẩm đã có trong giỏ (bất kể topping gì)
    // thì ta coi như là dòng mới để tránh bug gộp nhầm topping.
    // Hoặc bạn có thể dùng logic: Luôn add mới.

    // SỬA ĐỔI: Luôn add dòng mới nếu có option, để tránh lỗi gộp Trà sữa (trân châu) vào Trà sữa (bánh flan)
    // Trừ khi options rỗng và items trong giỏ cũng options rỗng.

    bool found = false;
    for (var item in shoppingItems) {
      if (item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, options)) {
        item.quantity += quantity;
        found = true;
        break;
      }
    }

    if (!found) {
      shoppingItems.add(ShoppingItem(
        product: product,
        quantity: quantity,
        selectedOptions: options,
        notes: notes,
      ));
    }

    shoppingItems.refresh();
    updateTotal();
  }

  // Hàm phụ để so sánh 2 danh sách option (để biết có nên gộp dòng không)
  bool _areOptionsEqual(List<OptionGroup> list1, List<OptionGroup> list2) {
    if (list1.length != list2.length) return false;
    // So sánh đơn giản: Convert sang String rồi so sánh
    String str1 = list1
        .map((g) =>
            g.options.where((o) => o.isSelected).map((o) => o.name).join())
        .join();
    String str2 = list2
        .map((g) =>
            g.options.where((o) => o.isSelected).map((o) => o.name).join())
        .join();
    return str1 == str2;
  }

  // 5. Tính tổng tiền (ĐÃ SỬA: CỘNG CẢ TIỀN TOPPING)
  void updateTotal() {
    double total = 0.0;
    for (var item in shoppingItems) {
      // Giá gốc
      double itemPrice = item.product.price;

      // Cộng giá topping/options
      for (var group in item.selectedOptions) {
        for (var option in group.options) {
          if (option.isSelected) {
            itemPrice += option.price;
          }
        }
      }

      // Nhân số lượng
      double lineTotal = itemPrice * item.quantity;

      // Trừ giảm giá (nếu có logic giảm giá)
      if (item.discountPercentage > 0) {
        lineTotal = lineTotal * (1 - item.discountPercentage / 100);
      }

      total += lineTotal;
    }
    totalPrice.value = total;
  }

  // 6. Giảm số lượng
  void decreaseQuantity(ShoppingItem item) {
    final index = shoppingItems.indexOf(item);
    if (index != -1) {
      if (shoppingItems[index].quantity > 1) {
        shoppingItems[index].quantity--;
      } else {
        shoppingItems.removeAt(index);
      }
      shoppingItems.refresh();
      updateTotal();
    }
  }

  // 7. Xóa khỏi giỏ
  void removeFromShopping(ShoppingItem item) {
    shoppingItems.remove(item);
    shoppingItems.refresh();
    updateTotal();
  }

  // 8. Xóa sạch giỏ hàng
  void clearShopping() {
    shoppingItems.clear();
    totalPrice.value = 0;
  }
}
