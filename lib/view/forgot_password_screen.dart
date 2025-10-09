import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';
import 'package:milktea_shop/view/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back button
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            //Reset password text
            Text(
              'Cài lại mật khẩu',
              style: AppTextstyles.withColor(
                AppTextstyles.h1,
                Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nhập email của bạn để cài lại mật khẩu',
              style: AppTextstyles.withColor(
                AppTextstyles.bodyLarge,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),

            const SizedBox(height: 40),
            //Email textfield
            CustomTextfield(
              label: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email của bạn';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Email của bạn không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            //send reset link button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    showSuccessDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Gửi',
                    style: AppTextstyles.withColor(
                        AppTextstyles.buttonMedium, Colors.white),
                  )),
            ),
          ],
        ),
      )),
    );
  }

  //Show success dialog
  void showSuccessDialog(BuildContext context) {
    Get.dialog(AlertDialog(
      title: Text(
        'Kiểm tra email của bạn',
        style: AppTextstyles.h3,
      ),
      content: Text(
        'Chúng tôi đã gửi hướng dẫn khôi phục mật khẩu đến email của bạn',
        style: AppTextstyles.bodyMedium,
      ),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: AppTextstyles.withColor(
                  AppTextstyles.buttonMedium, Theme.of(context).primaryColor),
            )),
      ],
    ));
  }
}
