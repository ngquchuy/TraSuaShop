// import 'package:get/get.dart';
// import 'package:milktea_shop/models/shopping_item_model.dart';
// import 'package:milktea_shop/models/order_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderController extends GetxController {
//   final isLoading = false.obs;

//   Future<bool> createOrder({
//     required String customerName,
//     required String customerPhone,
//     required String customerAddress,
//     required String notes,
//     required List<ShoppingItemModel> items,
//     required double totalPrice,
//   }) async {
//     try {
//       isLoading.value = true;

//       // Chuẩn bị dữ liệu gửi lên backend (khớp với Order model)
//       final orderData = {
//         'customerName': customerName,
//         'phone': customerPhone,
//         'address': customerAddress,
//         'items': items.map((item) {
//           // Tìm tất cả options đã chọn
//           final selectedOptionsList = [];
//           for (var group in item.selectedOptions) {
//             final selectedOpts = group.options
//                 .where((opt) => opt.isSelected)
//                 .map((opt) => {
//                       'group': group.title,
//                       'name': opt.name,
//                       'price': opt.price
//                     })
//                 .toList();
//             selectedOptionsList.addAll(selectedOpts);
//           }

//           return {
//             'product': item.product.id,
//             'name': item.product.name,
//             'quantity': item.quantity,
//             'price': item.product.price,
//             'selectedOptions': selectedOptionsList,
//             'notes': item.notes,
//           };
//         }).toList(),
//         'totalAmount': totalPrice,
//         'status': 'Pending',
//       };

//       // Gửi request tới API backend
//       print('DEBUG: Sending order data: ${jsonEncode(orderData)}');

//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:5001/api/orders'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       print('DEBUG: Response status: ${response.statusCode}');
//       print('DEBUG: Response body: ${response.body}');

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         print('DEBUG: Order created successfully!');
        
//         // Lưu đơn hàng vào Firestore
//         await _saveOrderToFirestore(
//           customerName: customerName,
//           customerPhone: customerPhone,
//           customerAddress: customerAddress,
//           items: items,
//           totalPrice: totalPrice,
//           notes: notes,
//         );
        
//         return true;
//       } else {
//         print(
//             'DEBUG: Order creation failed with status ${response.statusCode}');
//         Get.snackbar('Lỗi', 'Lỗi: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('DEBUG: Exception caught: $e');
//       Get.snackbar('Lỗi', 'Lỗi tạo đơn hàng: $e');
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ✅ Lưu đơn hàng vào Firestore
//   Future<void> _saveOrderToFirestore({
//     required String customerName,
//     required String customerPhone,
//     required String customerAddress,
//     required List<ShoppingItemModel> items,
//     required double totalPrice,
//     required String notes,
//   }) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       // Chuyển đổi items thành OrderItem
//       final orderItems = items.map((item) {
//         final List<SelectedOption> selectedOptionsList = [];
//         for (var group in item.selectedOptions) {
//           final selectedOpts = group.options
//               .where((opt) => opt.isSelected)
//               .map((opt) => SelectedOption(
//                     group: group.title,
//                     name: opt.name,
//                     price: opt.price,
//                   ))
//               .toList();
//           selectedOptionsList.addAll(selectedOpts);
//         }

//         return OrderItem(
//           productId: item.product.id,
//           productName: item.product.name,
//           quantity: item.quantity,
//           price: item.product.price,
//           selectedOptions: selectedOptionsList,
//           notes: item.notes,
//         );
//       }).toList();

//       // Tạo đơn hàng
//       final order = OrderModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         customerName: customerName,
//         customerPhone: customerPhone,
//         customerAddress: customerAddress,
//         items: orderItems,
//         totalAmount: totalPrice,
//         status: 'Pending',
//         createdAt: DateTime.now(),
//         notes: notes,
//       );

//       // Lưu vào Firestore trong collection "orders" của user
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('orders')
//           .doc(order.id)
//           .set(order.toJson());

//       print('DEBUG: Order saved to Firestore successfully!');
//     } catch (e) {
//       print('DEBUG: Error saving order to Firestore: $e');
//     }
//   }

//   // ✅ Lấy lịch sử đơn hàng từ Firestore
//   Future<List<OrderModel>> getOrderHistory() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return [];

//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('orders')
//           .orderBy('createdAt', descending: true)
//           .get();

//       return snapshot.docs
//           .map((doc) => OrderModel.fromJson(doc.data()))
//           .toList();
//     } catch (e) {
//       print('DEBUG: Error getting order history: $e');
//       return [];
//     }
//   }

//   // ✅ Lấy stream lịch sử đơn hàng (real-time)
//   Stream<List<OrderModel>> getOrderHistoryStream() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Stream.value([]);
//     }

//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('orders')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>))
//             .toList());
//   }
// }
