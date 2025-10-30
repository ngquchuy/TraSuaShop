import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final storage = GetStorage();

  // Các trường dữ liệu của người dùng
  var userName = ''.obs;
  var userEmail = ''.obs;
  var avatarPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Đọc dữ liệu đã lưu (nếu có)
    userName.value = storage.read('userName') ?? 'Nguyễn Văn Khoa';
    userEmail.value = storage.read('userEmail') ?? 'khoa.bui@example.com';
    avatarPath.value =
        storage.read('avatarPath') ?? 'assets/images/avatar-with-black-hair-and-hoodie.png';
  }

  // ✅ Lưu lại thông tin mới
  void updateUser(String name, String email, String avatar) {
    userName.value = name;
    userEmail.value = email;
    avatarPath.value = avatar;

    storage.write('userName', name);
    storage.write('userEmail', email);
    storage.write('avatarPath', avatar);
  }
}
