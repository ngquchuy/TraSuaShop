// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:milktea_shop/controllers/user_controller.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }

//   Future<void> _fetchOrders() async {
//     try {
//       final userController = Get.find<UserController>();
//       //final userPhone = userController.userPhone.value;

//       // Check if user has phone number
//       // if (userPhone.isEmpty) {
//       //   setState(() {
//       //     isLoading = false;
//       //     errorMessage =
//       //         'Vui lòng cập nhật số điện thoại trong hồ sơ để xem lịch sử';
//       //   });
//       //   return;
//       // }

//       // Fetch all orders from backend
//       final response = await http
//           .get(
//             Uri.parse('http://10.0.2.2:5001/api/orders'),
//           )
//           .timeout(
//             const Duration(seconds: 10),
//             onTimeout: () => throw Exception('Hết thời gian kết nối'),
//           );

//       if (response.statusCode == 200) {
//         final allOrders = jsonDecode(response.body) as List<dynamic>;

//         // Filter orders by user phone number
//         // final userOrders = allOrders
//         //     .where((order) =>
//         //         order['phone'] == userPhone ||
//         //         order['customerPhone'] == userPhone)
//         //     .toList();

//         // Sort by date descending (newest first)
//         userOrders.sort((a, b) {
//           final dateA = DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
//               DateTime(2000);
//           final dateB = DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
//               DateTime(2000);
//           return dateB.compareTo(dateA);
//         });

//         setState(() {
//           orders = userOrders;
//           isLoading = false;
//           errorMessage = null;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage =
//               'Không thể tải lịch sử đơn hàng (Mã ${response.statusCode})';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Lỗi: $e';
//       });
//       print('Error fetching orders: $e');
//     }
//   }

//   String _formatPrice(double price) {
//     return '${price.toStringAsFixed(0)} đ';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lịch sử mua hàng'),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage != null
//               ? Center(
//                   child: RefreshIndicator(
//                     onRefresh: _fetchOrders,
//                     child: ListView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       children: [
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height - 100,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.error_outline,
//                                 size: 60,
//                                 color: Colors.grey,
//                               ),
//                               const SizedBox(height: 16),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 32),
//                                 child: Text(
//                                   errorMessage!,
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               ElevatedButton(
//                                 onPressed: _fetchOrders,
//                                 child: const Text('Thử lại'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : orders.isEmpty
//                   ? Center(
//                       child: RefreshIndicator(
//                         onRefresh: _fetchOrders,
//                         child: ListView(
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           children: [
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height - 100,
//                               child: const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.shopping_bag_outlined,
//                                     size: 60,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     'Chưa có đơn hàng nào',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : RefreshIndicator(
//                       onRefresh: _fetchOrders,
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: orders.length,
//                         itemBuilder: (context, index) {
//                           final order = orders[index];
//                           return _buildOrderCard(order);
//                         },
//                       ),
//                     ),
//     );
//   }

//   Widget _buildOrderCard(dynamic order) {
//     final orderId = order['_id'] ?? 'N/A';
//     final totalAmount = order['totalAmount'] ?? 0;
//     final status = order['status'] ?? 'Pending';
//     final createdAt = order['createdAt'] ?? '';
//     final items = order['items'] ?? [];

//     // Format date
//     String formattedDate = 'N/A';
//     if (createdAt.isNotEmpty) {
//       try {
//         final dateTime = DateTime.parse(createdAt);
//         formattedDate =
//             '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
//       } catch (e) {
//         formattedDate = createdAt;
//       }
//     }

//     // Status color
//     Color statusColor = Colors.grey;
//     if (status == 'Delivered') {
//       statusColor = Colors.green;
//     } else if (status == 'Processing') {
//       statusColor = Colors.blue;
//     } else if (status == 'Cancelled') {
//       statusColor = Colors.red;
//     }

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Đơn #${orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       formattedDate,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: statusColor),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 12),

//             // Items list
//             Text(
//               'Sản phẩm (${items.length})',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...List.generate(
//               items.length,
//               (idx) {
//                 final item = items[idx];
//                 final itemName = item['name'] ?? 'Sản phẩm';
//                 final quantity = item['quantity'] ?? 0;
//                 final selectedOptions = item['selectedOptions'] ?? [];
//                 final notes = item['notes'] ?? '';

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '• $itemName x$quantity',
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       // Show selected options if any
//                       if (selectedOptions.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 16, top: 4),
//                           child: Text(
//                             selectedOptions
//                                 .map((opt) => '${opt['group']}: ${opt['name']}')
//                                 .join(', '),
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ),
//                       // Show notes if any
//                       if (notes.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 16, top: 4),
//                           child: Text(
//                             'Ghi chú: $notes',
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.purple,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 12),

//             // Order summary
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Tổng cộng:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(
//                   _formatPrice(totalAmount.toDouble()),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Giao tới: ${order['address'] ?? 'N/A'}',
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
