import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderService {
  // LƯU Ý: Đổi IP này theo máy của bạn
  // - Máy ảo Android: 10.0.2.2
  // - Máy thật (chung wifi): 192.168.x.x
  // - iOS Simulator: localhost
  static const String baseUrl = 'http://10.0.2.2:5001/api';

  // 1. Lấy danh sách đơn hàng
  Future<List<OrderModel>> fetchOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      // Map JSON sang OrderModel dùng hàm fromJson vừa sửa
      return body.map((dynamic item) => OrderModel.fromJson(item)).toList();
    } else {
      throw Exception('Lỗi tải đơn hàng: ${response.statusCode}');
    }
  }

  // 2. Cập nhật trạng thái đơn (Admin bấm Nhận đơn / Giao hàng)
  Future<bool> updateOrderStatus(
      String orderId, String newStatus, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': newStatus}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Lỗi update: ${response.body}");
      return false;
    }
  }
}
