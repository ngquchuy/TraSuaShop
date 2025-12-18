import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../services/order_service.dart';

class AdminOrderScreen extends StatefulWidget {
  final User user;
  const AdminOrderScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  // Format tiền tệ Việt Nam
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _orderService.fetchOrders(widget.user.token ?? '');
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      print("Lỗi tải đơn: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String orderId, String newStatus) async {
    bool success = await _orderService.updateOrderStatus(
        orderId, newStatus, widget.user.token ?? '');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã chuyển trạng thái: $newStatus")));
      _loadOrders(); // Tải lại để cập nhật giao diện
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi cập nhật trạng thái!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quản lý Đơn hàng"),
          bottom: const TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.redAccent,
            tabs: [
              Tab(text: "Mới (Pending)"),
              Tab(text: "Đang làm/Giao"),
              Tab(text: "Lịch sử"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Đơn mới chờ duyệt
            _buildOrderList(["Pending"]),

            // Tab 2: Đơn đang pha chế hoặc đang giao
            // Lưu ý: Tên status phải khớp CHÍNH XÁC với Enum trong Backend (order.js)
            _buildOrderList(["Processing"]),

            // Tab 3: Đơn đã hủy (hoặc Completed nếu bạn có thêm status này)
            _buildOrderList(["Cancelled", "Delivered"]),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<String> statusFilters) {
    // Lọc đơn hàng theo status
    final filteredOrders =
        _orders.where((order) => statusFilters.contains(order.status)).toList();

    if (filteredOrders.isEmpty) {
      return Center(
          child: Text("Không có đơn hàng nào",
              style: TextStyle(color: Colors.grey[400])));
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header: Thời gian & Tổng tiền ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM HH:mm').format(order.createdAt),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        currencyFormat.format(
                            order.totalAmount), // Dùng biến mới totalAmount
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(),

                  // --- Thông tin khách hàng ---
                  Text("👤 ${order.customerName} - ${order.customerPhone}",
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text("📍 ${order.customerAddress}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  if (order.notes.isNotEmpty)
                    Text("📝 Note: ${order.notes}",
                        style: const TextStyle(
                            color: Colors.orange, fontStyle: FontStyle.italic)),

                  const SizedBox(height: 10),
                  const Text("Đồ uống:",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  // --- Danh sách món (Hiển thị cả Topping/Size) ---
                  ...order.items.map((item) {
                    // Tạo chuỗi option (Ví dụ: Size L, 50% Đường)
                    String optionsStr =
                        item.selectedOptions.map((opt) => opt.name).join(", ");
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ${item.productName} x${item.quantity}",
                              style: const TextStyle(fontSize: 16)),
                          if (optionsStr.isNotEmpty)
                            Text("   + $optionsStr",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 15),

                  // --- Nút bấm hành động (Tùy theo Status) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Nếu đơn đang Pending -> Hiện nút Nhận & Hủy
                      if (order.status == 'Pending') ...[
                        OutlinedButton(
                          onPressed: () => _updateStatus(order.id, "Cancelled"),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red),
                          child: const Text("Từ chối"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () =>
                              _updateStatus(order.id, "Processing"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text("Nhận đơn",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],

                      // Nếu đơn đang Processing (Đang làm) -> Hiện nút Giao hàng
                      if (order.status == 'Processing')
                        ElevatedButton.icon(
                          onPressed: () => _updateStatus(order.id, "Delivered"),
                          icon: const Icon(Icons.delivery_dining),
                          label: const Text("Bắt đầu giao"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        ),

                      // Nếu đơn đã Delivered (Đang giao/Hoàn thành) -> Chỉ hiện trạng thái
                      if (order.status == 'Delivered')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text("Đã giao hàng",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
