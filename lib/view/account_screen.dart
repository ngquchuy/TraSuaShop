import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import 'package:milktea_shop/features/help%20center/views/screen/help_center_screen.dart';
import 'package:milktea_shop/features/shipping%20address/shipping_address_screen.dart';
import 'package:milktea_shop/view/cart_screen.dart';
import 'package:milktea_shop/view/edit_profile_screen.dart';
import 'package:milktea_shop/view/wish_list_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản của tôi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Obx(() => Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/avatar-with-black-hair-and-hoodie.png'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userController.userName.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userController.userEmail.value,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
            const SizedBox(height: 20),

            // 🧾 Danh sách chức năng tài khoản
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Column(
                children: [
                  _buildAccountItem(
                    context,
                    icon: Icons.shopping_cart_outlined,
                    title: 'Đơn hàng của tôi',
                    subtitle: 'Xem trạng thái đơn hàng và chi tiết',
                    onTap: () => Get.to(() => CartScreen()),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Danh sách yêu thích',
                    subtitle: 'Các sản phẩm bạn đã yêu thích',
                    onTap: () => Get.to(() => const WishListScreen()),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.history,
                    title: 'Lịch sử mua hàng',
                    subtitle: 'Xem lại các đơn hàng đã hoàn tất',
                    onTap: () {
                      Get.snackbar('Lịch sử', 'Tính năng đang phát triển');
                    },
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.location_on,
                    title: 'Địa chỉ',
                    subtitle: 'Địa chỉ nhận hàng của bạn',
                    onTap: () => Get.to(() => ShippingAdressScreen()),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.settings,
                    title: 'Chỉnh sửa hồ sơ',
                    subtitle: 'Chỉnh sửa thông tin cá nhân',
                    onTap: () => Get.to(() => const EditProfileScreen()),
                  ),
                  const Divider(
                    thickness: 10,
                  ),
                  // 🌗 Dark / Light mode toggle
                  GetBuilder<ThemeController>(
                    builder: (_) => SwitchListTile(
                      value: themeController.isDarkMode,
                      title: const Text('Chế độ tối'),
                      secondary: const Icon(Icons.dark_mode),
                      onChanged: (val) => themeController.toggleTheme(),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.support_agent_outlined,
                    title: 'Hỗ trợ',
                    subtitle: 'Liên hệ với chúng tôi',
                    onTap: () => Get.to(() => const HelpCenterScreen()),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.article_outlined,
                    title: 'Điều khoản & Chính sách',
                    subtitle: 'Liên hệ với chúng tôi',
                    onTap: () => Get.to(() => const EditProfileScreen()),
                  ),
                  const Divider(height: 1),
                  _buildAccountItem(
                    context,
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    subtitle: 'Thoát khỏi tài khoản hiện tại',
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Xác nhận đăng xuất',
                        middleText: 'Bạn có chắc muốn đăng xuất không?',
                        textConfirm: 'Đăng xuất',
                        textCancel: 'Hủy',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.back();
                          Get.snackbar(
                              'Đăng xuất', 'Bạn đã đăng xuất thành công');
                          // Thực hiện logic đăng xuất tại đây (xóa token, quay về login...)
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
