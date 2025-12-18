import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_order_screen.dart';
import 'admin_menu_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  final User user;

  const AdminMainScreen({super.key, required this.user});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Khai báo danh sách màn hình ngay trong build để truy cập được widget.user
    final List<Widget> screens = [
      AdminDashboardScreen(user: widget.user), // Tab 0

      AdminOrderScreen(user: widget.user),

      AdminMenuScreen(user: widget.user), // Tab 2
      AdminSettingsScreen(user: widget.user), // Tab 3
    ];

    return Scaffold(
      body: screens[_currentIndex], // Hiển thị màn hình tương ứng
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
