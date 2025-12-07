import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// THÊM CÁC IMPORTS SAU:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final _storage = GetStorage();

  final RxBool _isFirstTime = true.obs;
  final RxBool _isLoggedIn = false.obs;

  bool get isFirstTime => _isFirstTime.value;

  // LƯU Ý: Bạn đang trả về _isFirstTime.value thay vì _isLoggedIn.value. Cần sửa lỗi này.
  // bool get isLoggedIn => _isFirstTime.value;
  bool get isLoggedIn => _isLoggedIn.value; // ĐÃ SỬA LỖI

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
  }

  void _loadInitialState() {
    _isFirstTime.value = _storage.read('isFirstTime') ?? true;
    _isLoggedIn.value = _storage.read('isLoggedIn') ?? false;
  }

  void setFirstTimeDone() {
    _isFirstTime.value = true;
    _storage.write('isFirstTime', true);
  }

  void login() {
    _isLoggedIn.value = true;
    _storage.write('isLoggedIn', true);
  }

  void logout() {
    _isLoggedIn.value = false;
    _storage.write('isLoggedIn', false);
  }

  // ===============================================
  // PHƯƠNG THỨC ĐĂNG NHẬP BẰNG GOOGLE (MỚI)
  // ===============================================

  Future<User?> signInWithGoogle() async {
    try {
      // 1. Khởi tạo Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 2. Bắt đầu quá trình đăng nhập Google
      // Cần await vì đây là một tác vụ bất đồng bộ
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Người dùng hủy hoặc đóng hộp thoại đăng nhập
        return null;
      }

      // 3. Lấy thông tin xác thực (Authentication details)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Tạo Credential để xác thực với Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        // Các thuộc tính này là String? và tương thích với hàm credential()
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Đăng nhập Firebase bằng Credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // 6. Cập nhật trạng thái ứng dụng
      if (userCredential.user != null) {
        // Lưu trạng thái đăng nhập thành công
        login();
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi Firebase
      Get.snackbar(
        'Lỗi Xác thực',
        e.message ?? 'Đã xảy ra lỗi Firebase không xác định.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      // Xử lý các lỗi khác (ví dụ: lỗi mạng, lỗi Google Sign-In)
      Get.snackbar(
        'Lỗi Đăng nhập',
        'Không thể hoàn tất đăng nhập Google: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
}
