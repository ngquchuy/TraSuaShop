import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Kiểm tra kỹ lại Port: 5000 hay 5001? (Backend bạn chạy port nào thì điền port đó)
  static const String baseUrl = "http://10.0.2.2:5001/api"; 

  static Future<List<Product>> fetchProducts() async {
    print("\n================ BẮT ĐẦU GỌI API ================");
    // 1. Check đường dẫn
    final String url = '$baseUrl/products'; 
    print("1. Đang gọi tới URL: $url");

    try {
      final response = await http.get(Uri.parse(url));

      print("2. Server phản hồi Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        // 2. Check dữ liệu thô trả về
        print("3. Dữ liệu thô (Body):");
        print(response.body); // <-- QUAN TRỌNG NHẤT: Xem nó in ra cái gì?

        // 3. Thử decode
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> listData = [];

        // Xử lý trường hợp backend trả về { data: [...] } hoặc [...]
        if (decodedData is List) {
          listData = decodedData;
          print("-> Dữ liệu là dạng List trực tiếp.");
        } else if (decodedData is Map && decodedData['data'] != null) {
          listData = decodedData['data'];
          print("-> Dữ liệu nằm trong key 'data'.");
        } else if (decodedData is Map && decodedData['products'] != null) {
           listData = decodedData['products'];
           print("-> Dữ liệu nằm trong key 'products'.");
        } else {
          print("❌ CẤU TRÚC JSON KHÔNG KHỚP! Kiểm tra lại Backend.");
          return [];
        }

        print("-> Tìm thấy ${listData.length} sản phẩm.");

        // 4. Thử map sang Product (Dễ lỗi ở đây nếu tên trường sai)
        return listData.map((json) {
          try {
            return Product.fromJson(json);
          } catch (e) {
            print("❌ Lỗi khi convert 1 sản phẩm: $e");
            print("   Data lỗi: $json");
            throw e; // Ném lỗi để catch bên dưới bắt được
          }
        }).toList();

      } else {
        print("❌ Lỗi Server (Khác 200): ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ LỖI KẾT NỐI / PARSE DATA: $e");
      return [];
    } finally {
      print("================ KẾT THÚC GỌI API ================\n");
    }
  }
}