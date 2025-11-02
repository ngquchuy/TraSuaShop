import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/features/shipping%20address/models/address.dart';
import 'package:milktea_shop/features/shipping%20address/repositories/address_repository.dart';
import 'package:milktea_shop/features/shipping%20address/widgets/address_card.dart';
import 'package:milktea_shop/utils/app_textstyles.dart';

class ShippingAdressScreen extends StatelessWidget {
  final AddressRepository _repository = AddressRepository();
  ShippingAdressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'Địa chỉ nhận hàng',
          style: AppTextstyles.withColor(
            AppTextstyles.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddAddressBottomSheet(context),
            icon: Icon(
              Icons.add_circle_outline,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _repository.getAddresses().length,
        itemBuilder: (context, index) => _buildAddressCard(context, index),
      ), // ListView.builder
    );
  }

  Widget _buildAddressCard(BuildContext context, int index) {
    final address = _repository.getAddresses()[index];
    return AddressCard(
      address: address,
      onEdit: () => _showEditAddressBottomSheet(context, address),
      onDelete: () => _showDeleteConfirmation(context),
    );
  }

  void _showEditAddressBottomSheet(BuildContext context, Address address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chỉnh sửa địa chỉ',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h3,
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildTextField(
              context,
              'Nhà hay văn phòng?',
              Icons.label_outline,
              initialValue: address.label,
            ),
            const SizedBox(
              height: 16,
            ),
            _buildTextField(
              context,
              'Địa chỉ',
              Icons.location_on_outlined,
              initialValue: address.fullAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            _buildTextField(
              context,
              'Thành phố',
              Icons.location_city_outlined,
              initialValue: address.city,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // handle update address
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ), // RoundedRectangleBorder
                ),
                child: Text(
                  'Cập nhật địa chỉ',
                  style: AppTextstyles.withColor(
                    AppTextstyles.buttonMedium,
                    Colors.white,
                  ),
                ), // Text
              ), // ElevatedButton
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Xóa địa chỉ',
                style: AppTextstyles.withColor(
                  AppTextstyles.h3,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bạn có chắc chắn muốn xóa địa chỉ này không?',
                textAlign: TextAlign.center,
                style: AppTextstyles.withColor(
                  AppTextstyles.bodyMedium,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Hủy',
                        style: AppTextstyles.withColor(
                          AppTextstyles.buttonMedium,
                          Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Xóa',
                        style: AppTextstyles.withColor(
                          AppTextstyles.buttonMedium,
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        barrierColor: Colors.black54);
  }

  Widget _buildTextField(BuildContext context, String label, IconData icon,
      {String? initialValue}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ))),
    );
  }

  void _showAddAddressBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thêm địa chỉ mới',
                  style: AppTextstyles.withColor(
                    AppTextstyles.h3,
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ), // Text
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildTextField(
              context,
              'Nhà hay văn phòng?',
              Icons.label_outline,
            ),
            const SizedBox(
              height: 16,
            ),
            _buildTextField(
              context,
              'Địa chỉ',
              Icons.location_on_outlined,
            ),
            const SizedBox(
              height: 16,
            ),
            _buildTextField(
              context,
              'Thành phố',
              Icons.location_city_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // handle save address
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Lưu địa chỉ',
                  style: AppTextstyles.withColor(
                    AppTextstyles.buttonMedium,
                    Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
