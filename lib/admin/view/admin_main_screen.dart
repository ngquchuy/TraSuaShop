import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase
import 'package:milktea_shop/admin/view/admin_dashboard_screen.dart';
import 'package:milktea_shop/admin/view/admin_menu_screen.dart';
import 'package:milktea_shop/admin/view/admin_order_screen.dart';
import 'package:milktea_shop/admin/view/admin_settings_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminOrderScreen(),
    const AdminMenuScreen(),
    const AdminSettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _setupPushNotification();
  }

  // --- HÀM CẤU HÌNH THÔNG BÁO ---
  void _setupPushNotification() async {
    // 1. Xin quyền thông báo (cho iOS/Android 13+)
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔔 Admin đã cấp quyền thông báo');

      // 2. QUAN TRỌNG NHẤT: Đăng ký vào Topic "admin_notifications"
      // Phải trùng khớp 100% với chữ bên Backend Node.js
      await messaging.subscribeToTopic('admin_notifications');
      print('✅ Đã đăng ký nhận tin từ topic: admin_notifications');
    } else {
      print('🚫 Admin từ chối quyền thông báo');
    }

    // 3. Xử lý khi đang mở App mà có thông báo (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Nhận tin nhắn mới: ${message.notification?.title}');

      // Hiện Snackbar báo ngay lập tức
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'Đơn hàng mới',
          message.notification!.body ?? 'Kiểm tra ngay',
          icon: const Icon(Icons.notifications_active, color: Colors.white),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 6),
          isDismissible: true,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          onTap: (_) {
            // Khi bấm vào thông báo -> Chuyển sang tab Đơn hàng (Index 1)
            setState(() {
              _currentIndex = 1;
            });
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
