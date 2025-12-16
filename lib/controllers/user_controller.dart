import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = "".obs;
  var userName = "Khách hàng".obs;
  var userEmail = "".obs;
  var fullName = "".obs;
  // Mặc định dùng ảnh trong assets, nếu có link từ server sẽ thay thế
  var avatarPath = "assets/images/avatar-with-black-hair-and-hoodie.png".obs;

  void setUserData(Map<String, dynamic> data) {
    userId.value = data['_id'] ?? "";
    // Backend của bạn trả về cả 'username' và 'FullName', bạn chọn cái nào muốn hiển thị chính
    userName.value = data['FullName'] ?? data['username'] ?? "Người dùng";
    userEmail.value = data['email'] ?? "";
    fullName.value = data['FullName'] ?? "";

    // Xử lý Avatar: Nếu server trả về link ảnh thì dùng, không thì giữ nguyên mặc định
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
  }
}
