import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationController extends GetxController {
  final notifications = <String>[].obs;

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
      }
    });
  }

  // add
  Future<void> addNotification(String message) async {
    notifications.add(message);
    await dbRef.set(notifications); // update toàn bộ list lên firebase
  }

  // remove 1 cái
  Future<void> removeNotification(int index) async {
    notifications.removeAt(index);
    await dbRef.set(notifications);
  }

  // clear hết
  Future<void> clearAll() async {
    notifications.clear();
    await dbRef.set([]);
  }

  int get count => notifications.length;
}
