# Hướng Dẫn Hệ Thống Phân Quyền Người Dùng

## Tổng Quan

Ứng dụng Tra Sua Shop hiện đã có hệ thống phân quyền cho khách hàng. Hệ thống này quản lý ba loại quyền chính:

1. **Guest (Khách)** - Người dùng chưa đăng nhập
2. **Customer (Khách hàng)** - Người dùng đã đăng nhập
3. **Admin (Quản trị viên)** - Người quản lý hệ thống

---

## Cấu Trúc Hệ Thống

### 1. Model Quyền (`lib/models/user_role.dart`)

```dart
enum UserRole {
  guest,      // Khách (chưa đăng nhập)
  customer,   // Khách hàng (đã đăng nhập)
  admin,      // Quản trị viên
}
```

### 2. UserController (`lib/controllers/user_controller.dart`)

Quản lý quyền người dùng với các phương thức:

- `setUserRole(UserRole role)` - Đặt quyền người dùng
- `getUserRole()` - Lấy quyền người dùng từ storage
- `isCustomer()` - Kiểm tra xem người dùng có phải khách hàng không
- `isAdmin()` - Kiểm tra xem người dùng có phải admin không
- `isGuest()` - Kiểm tra xem người dùng có phải khách không
- `loadUserRoleFromFirestore()` - Tải quyền từ Firestore

### 3. AuthController (`lib/controllers/auth_controller.dart`)

Quản lý xác thực và gán quyền:

- `assignCustomerRole()` - Gán quyền khách hàng khi đăng nhập
- `logout()` - Đặt quyền về guest khi đăng xuất

---

## Cách Sử Dụng

### Kiểm Tra Quyền Người Dùng

```dart
final userController = Get.find<UserController>();

// Kiểm tra xem người dùng có phải khách hàng không
if (userController.isCustomer()) {
  // Cho phép truy cập các tính năng dành cho khách hàng
}

// Kiểm tra xem người dùng có phải admin không
if (userController.isAdmin()) {
  // Cho phép truy cập các tính năng dành cho admin
}

// Kiểm tra xem người dùng có phải khách không
if (userController.isGuest()) {
  // Hạn chế truy cập một số tính năng
}
```

### Lấy Quyền Hiện Tại

```dart
final userController = Get.find<UserController>();
final role = userController.userRole.value;
print('Quyền: ${role.displayName}'); // In ra: "Khách hàng", "Khách", hoặc "Quản trị viên"
```

### Gán Quyền Khi Đăng Nhập

Quyền được tự động gán khi người dùng đăng nhập:

```dart
// Đăng nhập bằng Email/Password
authController.login();
await authController.assignCustomerRole();

// Đăng nhập bằng Google
final user = await authController.signInWithGoogle();
if (user != null) {
  await authController.assignCustomerRole();
}
```

### Đặt Lại Quyền Khi Đăng Xuất

```dart
authController.logout(); // Tự động đặt quyền về guest
```

---

## Lưu Trữ Dữ Liệu

### Local Storage (GetStorage)

Quyền được lưu trữ cục bộ trong `GetStorage`:

```dart
storage.write('userRole', role.value); // Lưu quyền
final roleString = storage.read('userRole'); // Đọc quyền
```

### Firestore

Quyền cũng được lưu trữ trong Firestore dưới collection `users`:

```json
{
  "uid": "user_id",
  "name": "Tên người dùng",
  "email": "email@example.com",
  "role": "customer"
}
```

---

## Hiển Thị Quyền Trên Giao Diện

Quyền được hiển thị trên `AccountScreen` với màu sắc khác nhau:

- **Khách (Guest)** - Màu xám
- **Khách hàng (Customer)** - Màu xanh lá
- **Quản trị viên (Admin)** - Màu đỏ

```dart
Obx(() => Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: _getRoleColor(userController.userRole.value),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Quyền: ${userController.userRole.value.displayName}',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
))
```

---

## Ví Dụ Thực Tế

### Ví Dụ 1: Hạn Chế Truy Cập Tính Năng Cho Khách

```dart
void _handleCheckout() {
  final userController = Get.find<UserController>();
  
  if (userController.isGuest()) {
    Get.snackbar(
      'Thông báo',
      'Vui lòng đăng nhập để tiếp tục thanh toán',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.to(() => SigninScreen());
  } else {
    // Cho phép thanh toán
    Get.to(() => CheckoutScreen());
  }
}
```

### Ví Dụ 2: Hiển Thị Menu Khác Nhau Theo Quyền

```dart
Widget _buildMenu() {
  final userController = Get.find<UserController>();
  
  return Column(
    children: [
      // Menu chung cho tất cả
      _buildMenuItem('Trang chủ', Icons.home),
      
      // Menu chỉ cho khách hàng
      if (userController.isCustomer()) ...[
        _buildMenuItem('Đơn hàng của tôi', Icons.shopping_bag),
        _buildMenuItem('Địa chỉ', Icons.location_on),
      ],
      
      // Menu chỉ cho admin
      if (userController.isAdmin()) ...[
        _buildMenuItem('Quản lý sản phẩm', Icons.manage_accounts),
        _buildMenuItem('Quản lý đơn hàng', Icons.assignment),
      ],
    ],
  );
}
```

### Ví Dụ 3: Gán Quyền Admin (Từ Backend)

```dart
// Trong Firestore, cập nhật quyền người dùng thành admin
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .update({'role': 'admin'});

// Khi người dùng đăng nhập lại, quyền sẽ được tải từ Firestore
await userController.loadUserRoleFromFirestore();
```

---

## Quy Trình Đăng Nhập/Đăng Xuất

### Quy Trình Đăng Nhập

1. Người dùng nhập email/password hoặc đăng nhập bằng Google
2. Firebase xác thực thành công
3. `AuthController.login()` được gọi
4. `AuthController.assignCustomerRole()` được gọi
5. Quyền được đặt thành `customer`
6. Quyền được lưu vào `GetStorage` và `Firestore`
7. Người dùng được chuyển hướng đến `MainScreen`

### Quy Trình Đăng Xuất

1. Người dùng nhấn nút "Đăng xuất"
2. `FirebaseAuth.instance.signOut()` được gọi
3. `AuthController.logout()` được gọi
4. Quyền được đặt lại thành `guest`
5. Quyền được lưu vào `GetStorage`
6. Người dùng được chuyển hướng đến `SigninScreen`

---

## Mở Rộng Hệ Th��ng

### Thêm Quyền Mới

1. Thêm quyền mới vào `enum UserRole` trong `lib/models/user_role.dart`:

```dart
enum UserRole {
  guest,
  customer,
  admin,
  moderator,  // Quyền mới
}
```

2. Cập nhật `displayName` và `value` trong extension:

```dart
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      // ...
      case UserRole.moderator:
        return 'Người kiểm duyệt';
    }
  }

  String get value {
    switch (this) {
      // ...
      case UserRole.moderator:
        return 'moderator';
    }
  }
}
```

3. Cập nhật `fromString()` method:

```dart
static UserRole fromString(String value) {
  switch (value) {
    // ...
    case 'moderator':
      return UserRole.moderator;
    default:
      return UserRole.guest;
  }
}
```

4. Thêm phương thức kiểm tra trong `UserController`:

```dart
bool isModerator() {
  return userRole.value == UserRole.moderator;
}
```

---

## Lưu Ý Quan Trọng

1. **Quyền được lưu trữ ở hai nơi**: `GetStorage` (cục bộ) và `Firestore` (trên server)
2. **Quyền được tải từ Firestore khi đăng nhập**: Đảm bảo quyền luôn được cập nhật từ server
3. **Quyền được đặt lại khi đăng xuất**: Đảm bảo bảo mật
4. **Kiểm tra quyền trước khi cho phép truy cập**: Luôn kiểm tra quyền trước khi cho phép người dùng truy cập tính năng nhạy cảm

---

## Hỗ Trợ

Nếu bạn gặp vấn đề với hệ thống phân quyền, vui lòng kiểm tra:

1. Quyền được lưu trữ đúng trong `GetStorage`
2. Quyền được lưu trữ đúng trong `Firestore`
3. Quyền được tải đúng khi đăng nhập
4. Quyền được đặt lại đúng khi đăng xuất
