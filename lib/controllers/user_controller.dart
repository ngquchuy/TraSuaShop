import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // THÊM IMPORT NÀY

class UserController extends GetxController {
  final storage = GetStorage();

  // Biến Rx để theo dõi đối tượng người dùng Firebase
  final Rx<User?> _firebaseUser = Rx<User?>(null);

  // Các trường dữ liệu UI (tự động cập nhật từ Firebase)
  var userName = ''.obs;
  var userEmail = ''.obs;
  var avatarPath = ''.obs; // Dữ liệu này vẫn lấy từ GetStorage

  @override
  void onInit() {
    super.onInit();

    // 1. Khởi tạo và lắng nghe trạng thái Firebase Auth
    _bindFirebaseUser();

    // 2. Đọc dữ liệu tĩnh (Avatar)
    avatarPath.value = storage.read('avatarPath') ??
        'assets/images/avatar-with-black-hair-and-hoodie.png';
  }

  // Phương thức lắng nghe trạng thái đăng nhập Firebase
  void _bindFirebaseUser() {
    // Gán Stream authStateChanges vào biến _firebaseUser
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Mỗi khi _firebaseUser thay đổi (đăng nhập, đăng xuất, đăng ký), hàm này sẽ chạy
    ever(_firebaseUser, _updateUserInfo);
  }

  // Phương thức cập nhật thông tin UI từ đối tượng User
  void _updateUserInfo(User? user) {
    if (user != null) {
      // Đã đăng nhập: Lấy dữ liệu từ đối tượng User của Firebase
      // Lưu ý: displayName có thể là null, đặc biệt sau khi đăng ký bằng email/pass
      userName.value =
          user.displayName ?? user.email?.split('@')[0] ?? 'Người dùng';
      userEmail.value = user.email ?? 'Không có Email';

      // Nếu đăng nhập bằng Google/Facebook, user.photoURL sẽ có, ta có thể cập nhật avatar
      if (user.photoURL != null) {
        avatarPath.value = user.photoURL!;
        storage.write('avatarPath', user.photoURL!);
      }
    } else {
      // Đã đăng xuất: Đặt lại giá trị mặc định
      userName.value = storage.read('userName') ?? 'Khách';
      userEmail.value = storage.read('userEmail') ?? 'Chưa đăng nhập';
      // Giữ avatarPath theo giá trị trong storage cho đến khi đăng nhập lại
    }
  }

  // ✅ Cập nhật thông tin cục bộ (Thường dùng sau khi Edit Profile)
  // Phương thức này cũng cần cập nhật thông tin lên Firebase
  Future<void> updateProfileInfo(
      String name, String email, String avatar) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Cập nhật tên hiển thị trên Firebase
      await user.updateDisplayName(name);
      // Cập nhật avatar URL trên Firebase
      await user.updatePhotoURL(avatar);

      // Lưu avatar mới vào GetStorage
      storage.write('avatarPath', avatar);

      // Vì chúng ta đã lắng nghe authStateChanges, việc gọi _updateUserInfo
      // sẽ diễn ra tự động sau khi updateDisplayName/updatePhotoURL hoàn tất.
      // Tuy nhiên, để cập nhật GetStorage cho các biến không phải từ Firebase:
      storage.write('userName', name);
      storage.write('userEmail', email);

      // Cập nhật ngay lập tức nếu cần thiết (optional, vì Firebase sẽ tự bắn event)
      userName.value = name;
      userEmail.value = email;
      avatarPath.value = avatar;
    }
  }
}
