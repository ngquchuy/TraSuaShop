import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = "".obs;
  var userName = "Khách hàng".obs;
  var userEmail = "".obs;
  var fullName = "".obs;
  // Mặc định dùng ảnh trong assets, nếu có link từ server sẽ thay thế
  var avatarPath = "assets/images/avatar-with-black-hair-and-hoodie.png".obs;
  var token = "".obs; // Để gọi API
  var role = "customer".obs; // Để phân quyền Admin
  var userPhone = "".obs;

  // Trong lib/controllers/user_controller.dart

  void setUserData(Map<String, dynamic> data) {
    userId.value = data['_id'] ?? "";
    userName.value = data['FullName'] ?? data['username'] ?? "Người dùng";
    userEmail.value = data['email'] ?? "";

    // Xử lý Token
    token.value = data['token'] ?? "";

    // --- QUAN TRỌNG: XỬ LÝ ROLE ---
    String rawRole = data['role'] ?? "customer"; // Lấy role thô

    // Chuyển hết về chữ thường và xóa khoảng trắng thừa (nếu có)
    String cleanRole = rawRole.toString().toLowerCase().trim();

    role.value = cleanRole;

    // Xử lý Avatar...
    if (data['avatar'] != null && data['avatar'].toString().isNotEmpty) {
      avatarPath.value = data['avatar'];
    }
  }

  // Hàm xóa dữ liệu khi đăng xuất
  void clearData() {
    userId.value = "";
    userName.value = "Khách hàng";
    userEmail.value = "";
    avatarPath.value = "assets/images/avatar-with-black-hair-and-hoodie.png";
    token.value = "";
    role.value = "customer";
    userPhone.value = "";
  }
}
