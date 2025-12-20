import 'package:get/get.dart';

class UserController extends GetxController {
  var userId = "".obs;
  var userName = "Khách hàng".obs;
  var userEmail = "".obs;
  var fullName = "".obs;
  var token = ''.obs;
  var userPhone = "".obs;
  var role = "customer".obs;
  var avatarPath = "assets/images/avatar-with-black-hair-and-hoodie.png".obs;

  void setUserData(Map<String, dynamic> data) {
    userId.value = data['_id'] ?? "";
    userName.value = data['FullName'] ?? data['username'] ?? "Người dùng";
    userEmail.value = data['email'] ?? "";
    fullName.value = data['FullName'] ?? "";
    token.value = data['token'] ?? "";
    userPhone.value = data['phone'] ?? "";
    role.value = data['role'] ?? "customer";
    if (data['avatar'] != null && data['avatar'].toString().isNotEmpty) {
      avatarPath.value = data['avatar'];
    }
  }

  // Hàm xóa dữ liệu khi đăng xuất
  void clearData() {
    userId.value = "";
    userName.value = "Khách hàng";
    userEmail.value = "";
    token.value = '';
    userPhone.value = "";
    role.value = "customer";
    avatarPath.value = "assets/images/avatar-with-black-hair-and-hoodie.png";
  }
}
