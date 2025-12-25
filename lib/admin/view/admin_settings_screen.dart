import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../../controllers/user_controller.dart'; // Import Controller
import '../../view/signin_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  // 1. SỬA LỖI TÊN CONSTRUCTOR (Phải trùng tên Class)
  const AdminSettingsScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Đóng dialog

              // 2. GỌI CONTROLLER ĐỂ XÓA DATA & HỦY FIREBASE
              final UserController userController = Get.find<UserController>();
              userController.clearData();

              // 3. Dùng Get.offAll để xóa sạch lịch sử và về trang Login
              Get.offAll(() => SigninScreen());
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4. LẤY DATA TỪ CONTROLLER
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt tài khoản"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- PHẦN HEADER: AVATAR & INFO ---
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    child: Text(
                      // Sửa user.fullName -> userController.userName.value
                      userController.userName.value.isNotEmpty
                          ? userController.userName.value[0].toUpperCase()
                          : "A",
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Hiển thị tên
                  Text(
                    userController.userName.value, // Lấy từ Controller
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  // Hiển thị Email
                  Text(
                    userController.userEmail.value, // Lấy từ Controller
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Text(
                      userController.role.value
                          .toUpperCase(), // Lấy từ Controller
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- DANH SÁCH CHỨC NĂNG ---
            _buildSectionHeader("Tài khoản"),
            _buildSettingItem(
                Icons.person_outline, "Chỉnh sửa thông tin", () {}),
            _buildSettingItem(Icons.lock_outline, "Đổi mật khẩu", () {}),

            const SizedBox(height: 10),
            _buildSectionHeader("Ứng dụng"),
            _buildSettingItem(
                Icons.notifications_outlined, "Cài đặt thông báo", () {}),
            _buildSettingItem(Icons.info_outline, "Về ứng dụng", () {}),

            const SizedBox(height: 20),
            // Nút Đăng xuất
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => _handleLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Đăng xuất"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
