import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/controllers/notification_controller.dart';
import 'package:milktea_shop/services/auth_service.dart';
import 'package:milktea_shop/view/signin_screen.dart';
import 'package:milktea_shop/features/shipping%20address/shipping_address_screen.dart';
import 'package:milktea_shop/view/shopping_screen.dart';
import 'package:milktea_shop/view/wish_list_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gọi các controller
    final themeController = Get.find<ThemeController>();
    final userController = Get.find<UserController>();
    final notificationController = Get.put(NotificationController());
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản của tôi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              // Lấy đường dẫn avatar từ Controller
              final avatarPath = userController.avatarPath.value;

              ImageProvider imageProvider;
              if (avatarPath.contains('http')) {
                imageProvider = NetworkImage(avatarPath);
              } else {
                imageProvider = AssetImage(avatarPath);
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: imageProvider,
                      onBackgroundImageError: (_, __) {
                        // Xử lý lỗi nếu ảnh mạng bị hỏng thì không làm gì (nó sẽ hiện màu nền)
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userController.userName.value, // Tên lấy từ MongoDB
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        userController.userEmail.value,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // --- DANH SÁCH CHỨC NĂNG ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    _buildAccountItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'Đơn hàng của tôi',
                      subtitle: 'Theo dõi trạng thái đơn hàng',
                      onTap: () => Get.to(() => ShoppingScreen()),
                    ),
                    _buildDivider(),
                    _buildAccountItem(
                      context,
                      icon: Icons.favorite_border,
                      title: 'Yêu thích',
                      subtitle: 'Sản phẩm đã lưu',
                      onTap: () => Get.to(() => const WishListScreen()),
                    ),
                    _buildDivider(),
                    _buildAccountItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Sổ địa chỉ',
                      subtitle: 'Quản lý địa chỉ giao hàng',
                      onTap: () => Get.to(() => ShippingAdressScreen()),
                    ),
                    _buildDivider(),

                    // Toggle Dark Mode
                    GetBuilder<ThemeController>(
                      builder: (_) => SwitchListTile(
                        activeColor: Theme.of(context).primaryColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        value: themeController.isDarkMode,
                        title: const Text('Giao diện tối',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        secondary: Icon(
                          themeController.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (val) => themeController.toggleTheme(),
                      ),
                    ),

                    _buildDivider(),
                    _buildAccountItem(
                      context,
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      subtitle: 'Thoát tài khoản',
                      textColor: Colors.red, // Làm nổi bật nút đăng xuất
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Đăng xuất',
                          middleText: 'Bạn có chắc chắn muốn đăng xuất?',
                          textConfirm: 'Đồng ý',
                          textCancel: 'Hủy',
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () async {
                            // 1. Xóa token trong bộ nhớ máy
                            await _authService.logout();

                            // 2. Reset dữ liệu trong UserController về mặc định
                            userController.clearData();

                            // 3. Thêm thông báo đăng xuất thành công
                            notificationController
                                .addNotification('Đã đăng xuất thành công!');

                            // 4. Quay về màn hình đăng nhập & xóa lịch sử
                            Get.offAll(() => SigninScreen());

                            Get.snackbar('Thành công', 'Đã đăng xuất an toàn.');
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ Divider đẹp hơn
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey,
    );
  }

  // Widget item tái sử dụng
  Widget _buildAccountItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: textColor ?? Theme.of(context).primaryColor),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: textColor ?? Colors.black87)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
