import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final notifications = <String>[].obs;
  final box = GetStorage(); // Khởi tạo instance của GetStorage

  @override
  void onInit() {
    super.onInit();

    // 1. LOAD: Đọc dữ liệu đã lưu khi khởi tạo controller
    List? storedData = box.read<List>('notifications');
    if (storedData != null) {
      // Ép kiểu về List<String> và gán vào biến obs
      notifications.assignAll(storedData.cast<String>());
    }

    // 2. AUTO-SAVE: Lắng nghe mọi thay đổi của list 'notifications'
    // Bất cứ khi nào add, remove, hay clear, hàm này sẽ chạy để lưu lại.
    ever(notifications, (_) {
      box.write('notifications', notifications.toList());
    });
  }

  // Thêm thông báo (ever sẽ tự động lưu sau khi add)
  void addNotification(String message) {
    notifications.add(message);
  }

  // Xóa 1 thông báo (ever sẽ tự động lưu sau khi remove)
  void removeNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
    }
  }

  // Xóa hết (ever sẽ tự động lưu sau khi clear)
  void clearAll() {
    notifications.clear();
  }

  int get count => notifications.length;
}
