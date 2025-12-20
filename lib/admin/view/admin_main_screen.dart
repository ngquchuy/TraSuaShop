// File: lib/admin/view/admin_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../../controllers/user_controller.dart'; // Import UserController
import 'admin_order_screen.dart';
import 'admin_menu_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  // Không cần nhận user từ constructor nữa
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  // Lấy UserController để dùng nếu cần (hoặc các màn con tự lấy)
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    // Các màn hình con giờ cũng không cần truyền tham số user
    final List<Widget> screens = [
      const AdminDashboardScreen(), // Tab 0
      const AdminOrderScreen(), // Tab 1
      const AdminMenuScreen(), // Tab 2
      const AdminSettingsScreen(), // Tab 3
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Thống kê'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Đơn hàng'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
