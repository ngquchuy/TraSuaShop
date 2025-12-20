import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milktea_shop/controllers/order_controller.dart';
import 'package:milktea_shop/models/order_model.dart';
// Import formatter nếu bạn muốn dùng chung utility cũ, hoặc dùng intl như bên dưới
// import 'package:milktea_shop/utils/number_formatter.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Lấy Controller đã được khởi tạo từ trước
  final OrderController _orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách đơn hàng ngay khi mở màn hình
    // Lưu ý: Hàm này giờ không cần tham số vì đã lấy Token từ UserController
    _orderController.fetchMyOrders();
  }

  // Helper format tiền tệ
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  // Helper màu sắc trạng thái đơn hàng
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper dịch trạng thái sang tiếng Việt
  String _getStatusText(String status) {
    switch (status) {
      case 'Pending':
        return 'Chờ xác nhận';
      case 'Processing':
        return 'Đang thực hiện';
      case 'Delivered':
        return 'Đã giao hàng';
      case 'Cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _orderController.fetchMyOrders(),
          )
        ],
      ),
      body: Obx(() {
        // 1. Trạng thái đang tải
        if (_orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Trạng thái danh sách rỗng
        if (_orderController.myOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  "Bạn chưa có đơn hàng nào",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                // const SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () => _orderController.fetchMyOrders(),
                //   child: const Text("Tải lại"),
                // )
              ],
            ),
          );
        }

        // 3. Hiển thị danh sách đơn hàng
        return RefreshIndicator(
          onRefresh: () async {
            await _orderController.fetchMyOrders();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _orderController.myOrders.length,
            itemBuilder: (context, index) {
              final order = _orderController.myOrders[index];
              return _buildOrderItem(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng 1: Mã đơn (hoặc Ngày tháng) và Trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    // Nếu muốn hiện ID: Text("#${order.id.substring(order.id.length - 6)}", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _getStatusColor(order.status).withOpacity(0.5)),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Dòng 2: Danh sách món ăn
            ...order.items.map((item) {
              // Xử lý hiển thị topping/options nếu có
              String optionsText = "";
              // Nếu bạn có model option chi tiết thì map ra đây, tạm thời hiển thị tên món
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.quantity}x",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(fontSize: 15),
                          ),
                          // Nếu muốn hiện topping/note nhỏ bên dưới:
                          Text(item.notes,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      currencyFormat.format(item.price * item.quantity),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(height: 20),

            // Dòng 3: Tổng tiền
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng cộng:",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  currencyFormat.format(order.totalAmount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
