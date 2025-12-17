import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationController extends GetxController {
  final notifications = <String>[].obs;
  final unreadCount = 0.obs;

  final dbRef = FirebaseDatabase.instance.ref('notifications');

  @override
  void onInit() {
    super.onInit();

    // Listen realtime
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        notifications.clear();
      } else {
        final list = List<String>.from(data as List);
        notifications.assignAll(list);
        // Cập nhật unread count bằng số notification mới nhất
        unreadCount.value = list.length;
      }
    });
  }

  // add
  Future<void> addNotification(String message) async {
    notifications.insert(0, message); // Insert vào đầu danh sách
    unreadCount.value = notifications.length;
    await dbRef.set(notifications); // update toàn bộ list lên firebase
  }

  // remove 1 cái
  Future<void> removeNotification(int index) async {
    notifications.removeAt(index);
    unreadCount.value = notifications.length;
    await dbRef.set(notifications);
  }

  // clear hết
  Future<void> clearAll() async {
    notifications.clear();
    unreadCount.value = 0;
    await dbRef.set([]);
  }

  // Mark all as read (xóa badge)
  void markAllAsRead() {
    unreadCount.value = 0;
  }

  int get count => unreadCount.value;
}
