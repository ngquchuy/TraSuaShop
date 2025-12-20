import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milktea_shop/controllers/user_controller.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../services/order_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OrderService _orderService = OrderService();
  final UserController userController = Get.find<UserController>();
  bool _isLoading = true;

  // Các biến thống kê
  double _revenueToday = 0;
  int _ordersToday = 0;
  int _pendingCount = 0;

  // Format tiền tệ
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final token = userController.token.value;
      if (token.isEmpty) throw Exception("Token không tồn tại");
      final orders = await _orderService.fetchOrders(token);

      // Tính toán số liệu
      double revenue = 0;
      int countToday = 0;
      int pending = 0;

      final now = DateTime.now();

      for (var order in orders) {
        // Kiểm tra xem đơn có phải hôm nay không
        bool isToday = order.createdAt.year == now.year &&
            order.createdAt.month == now.month &&
            order.createdAt.day == now.day;

        // Tính doanh thu hôm nay (Chỉ tính đơn không bị hủy)
        if (isToday && order.status != 'Cancelled') {
          revenue += order.totalAmount;
          countToday++;
        }

        // Đếm đơn chờ xử lý (tính toàn bộ thời gian)
        if (order.status == 'Pending') {
          pending++;
        }
      }

      setState(() {
        _revenueToday = revenue;
        _ordersToday = countToday;
        _pendingCount = pending;
        _isLoading = false;
      });
    } catch (e) {
      print("Lỗi thống kê: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tổng quan"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadStats, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hôm nay",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- CARD DOANH THU ---
                  _buildStatCard(
                    title: "Doanh thu",
                    value: currencyFormat.format(_revenueToday),
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 15),

                  // --- ROW 2 CARD NHỎ ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: "Đơn hôm nay",
                          value: "$_ordersToday",
                          icon: Icons.shopping_bag,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          title: "Chờ xác nhận",
                          value: "$_pendingCount",
                          icon: Icons.notifications_active,
                          color: Colors.orange,
                          isAlert:
                              _pendingCount > 0, // Nếu có đơn chờ thì đỏ lên
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Hoạt động nhanh",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Các nút tắt (Shortcut)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.add, color: Colors.red),
                    ),
                    title: const Text("Tạo đơn tại quầy"),
                    subtitle:
                        const Text("Dành cho khách mua trực tiếp (Sắp ra mắt)"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
    );
  }

  // Widget con để vẽ các ô thống kê đẹp mắt
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAlert ? Colors.orange[50] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isAlert ? Border.all(color: Colors.orange) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 30),
              if (isAlert)
                const Icon(Icons.priority_high, color: Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isAlert ? Colors.red : Colors.black87)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
