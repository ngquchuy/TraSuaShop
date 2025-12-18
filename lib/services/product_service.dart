import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Thay IP theo máy của bạn (10.0.2.2 hoặc IP LAN)
  static const String baseUrl = 'http://10.0.2.2:5001/api';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Lỗi tải sản phẩm');
    }
  }

  // Chức năng Thêm món
  Future<bool> addProduct(Product product, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()), // Giờ đã có hàm toJson để dùng
    );
    return response.statusCode == 201;
  }

  // Chức năng Sửa món
  Future<bool> updateProduct(String id, Product product, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );
    return response.statusCode == 200;
  }

  // Chức năng Xóa món
  Future<bool> deleteProduct(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}
