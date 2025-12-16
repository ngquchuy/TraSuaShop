import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  final storage = GetStorage();

  // Biến Rx để theo dõi đối tượng người dùng Firebase
  final Rx<User?> _firebaseUser = Rx<User?>(null);

  // Các trường dữ liệu UI (tự động cập nhật từ Firebase)
  var userName = ''.obs;
  var userEmail = ''.obs;
  var avatarPath = ''.obs;
  var userPhone = ''.obs;
  var userAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 1. Khởi tạo và lắng nghe trạng thái Firebase Auth
    _bindFirebaseUser();

    // 2. Dữ liệu tĩnh sẽ được tải từ Firestore khi đăng nhập
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

      // Tải dữ liệu từ GetStorage nếu có
      final savedPhone = storage.read('userPhone');
      final savedAddress = storage.read('userAddress');
      if (savedPhone != null) userPhone.value = savedPhone;
      if (savedAddress != null) userAddress.value = savedAddress;
    } else {
      // Đã đăng xuất: Đặt lại giá trị mặc định
      userName.value = storage.read('userName') ?? 'Khách';
      userEmail.value = storage.read('userEmail') ?? 'Chưa đăng nhập';
      // Giữ avatarPath theo giá trị trong storage cho đến khi đăng nhập lại
    }
  }

  // ✅ Cập nhật thông tin hồ sơ (Lưu vào Firestore + GetStorage)
  Future<bool> updateProfileInfo(String name, String email, String avatar,
      String phone, String address) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('DEBUG: No user logged in');
        return false;
      }

      // Validate số điện thoại
      if (phone.isEmpty || phone.length < 10) {
        print('DEBUG: Invalid phone number');
        return false;
      }

      print('DEBUG: Starting profile update...');

      // Cập nhật tên hiển thị trên Firebase Auth (với timeout)
      try {
        await user.updateDisplayName(name).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Timeout updating display name');
          },
        );
        print('DEBUG: Updated display name');
      } catch (e) {
        print('DEBUG: Error updating display name: $e');
        return false;
      }

      // Cập nhật avatar URL trên Firebase Auth (với timeout)
      try {
        await user.updatePhotoURL(avatar).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Timeout updating photo URL');
          },
        );
        print('DEBUG: Updated photo URL');
      } catch (e) {
        print('DEBUG: Error updating photo URL: $e');
        return false;
      }

      // Lưu dữ liệu vào Firestore (với timeout)
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'avatar': avatar,
          'updatedAt': DateTime.now(),
        }, SetOptions(merge: true)).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException('Timeout saving to Firestore');
          },
        );
        print('DEBUG: Saved to Firestore');
      } catch (e) {
        print('DEBUG: Firestore error: $e');
        // Nếu Firestore fail, vẫn lưu vào local storage
        print('DEBUG: Using local storage as fallback');
      }

      // Lưu vào GetStorage làm backup
      storage.write('userName', name);
      storage.write('userEmail', email);
      storage.write('avatarPath', avatar);
      storage.write('userPhone', phone);
      storage.write('userAddress', address);
      print('DEBUG: Saved to GetStorage');

      // Cập nhật ngay lập tức trong bộ nhớ
      userName.value = name;
      userEmail.value = email;
      avatarPath.value = avatar;
      userPhone.value = phone;
      userAddress.value = address;
      print('DEBUG: Updated in-memory values');

      return true;
    } catch (e) {
      print('DEBUG: Error updating profile: $e');
      return false;
    }
  }
}
