import 'package:get/get.dart';
import 'package:milktea_shop/models/shopping_item_model.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class OrderController extends GetxController {
  final isLoading = false.obs;

  // Danh sách lịch sử đơn hàng
  var myOrders = <OrderModel>[].obs;

  // URL API Backend (Lưu ý: đổi IP nếu chạy máy thật/máy ảo khác)
  static const String baseUrl = 'http://10.0.2.2:5001/api/orders';

  // --- 1. TẠO ĐƠN HÀNG ---
  Future<bool> createOrder({
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required String notes,
    required List<ShoppingItemModel> items,
    required double totalPrice,
  }) async {
    try {
      isLoading.value = true;

      // Lấy token từ UserController (Lúc này đã hoạt động tốt)
      final UserController userController = Get.find<UserController>();
      String token = userController.token.value;

      // Chuẩn bị dữ liệu
      final orderData = {
        'customerName': customerName,
        'phone': customerPhone,
        'address': customerAddress,
        'items': items.map((item) {
          final selectedOptionsList = [];
          for (var group in item.selectedOptions) {
            final selectedOpts = group.options
                .where((opt) => opt.isSelected)
                .map((opt) => {
                      'group': group.title,
                      'name': opt.name,
                      'price': opt.price
                    })
                .toList();
            selectedOptionsList.addAll(selectedOpts);
          }

          return {
            'product': item.product.id,
            'name': item.product.name,
            'quantity': item.quantity,
            'price': item.product.price,
            'selectedOptions': selectedOptionsList,
            'notes': item.notes,
          };
        }).toList(),
        'totalAmount': totalPrice,
        'status': 'Pending',
      };

      // Gửi request POST kèm Token
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Thành công', 'Đặt hàng thành công!',
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'Có lỗi xảy ra';
        Get.snackbar('Đặt hàng thất bại', errorMsg,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar(
          'Lỗi kết nối', 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // LẤY LỊCH SỬ ĐƠN HÀNG (THEO USER TOKEN) ---

  Future<void> fetchMyOrders() async {
    try {
      isLoading.value = true;

      final UserController userController = Get.find<UserController>();
      String token = userController.token.value;

      if (token.isEmpty) {
        // Nếu chưa đăng nhập thì không gọi API
        return;
      }

      // Gọi vào endpoint mới /my-orders
      final response = await http.get(
        Uri.parse('$baseUrl/my-orders'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        // Map dữ liệu vào list myOrders
        myOrders.value = body.map((item) => OrderModel.fromJson(item)).toList();
      } else {
        // Có thể in log lỗi nếu cần debug
        print('Lỗi tải lịch sử: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi kết nối khi tải lịch sử');
    } finally {
      isLoading.value = false;
    }
  }
}
