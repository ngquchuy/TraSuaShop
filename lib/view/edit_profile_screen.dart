import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: userController.userName.value);
    emailController =
        TextEditingController(text: userController.userEmail.value);
    avatarPath = userController.avatarPath.value;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      userController.updateUser(
        nameController.text.trim(),
        emailController.text.trim(),
        avatarPath!,
      );
      Get.back();
      Get.snackbar('Thành công', 'Cập nhật thông tin tài khoản thành công 🎉',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: avatarPath != null
                      ? (avatarPath!.startsWith('assets/')
                          ? AssetImage(avatarPath!) as ImageProvider
                          : FileImage(File(avatarPath!)))
                      : const AssetImage(
                          'assets/images/avatar-with-black-hair-and-hoodie.png'),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Họ tên
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập họ tên'
                    : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Email không hợp lệ'
                    : null,
              ),
              const SizedBox(height: 24),

              // Nút lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu thay đổi'),
                  onPressed: _saveProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
