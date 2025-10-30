import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Danh sách thông báo
  final RxList<String> notifications = <String>[].obs;

  // Thêm thông báo mới
  void addNotification(String message) {
    notifications.add(message);
  }

  // Xóa 1 thông báo
  void removeNotification(int index) {
    notifications.removeAt(index);
  }

  // Xóa toàn bộ thông báo
  void clearAll() {
    notifications.clear();
  }

  // Lấy tổng số thông báo chưa đọc
  int get count => notifications.length;
}
