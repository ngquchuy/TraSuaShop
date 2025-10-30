import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milktea_shop/controllers/theme_controller.dart';
import 'package:milktea_shop/view/all_product_screen.dart';
import 'package:milktea_shop/view/widgets/category_chips.dart';
import 'package:milktea_shop/view/widgets/custom_searchbar.dart';
import 'package:milktea_shop/view/widgets/product_grid.dart';
import 'package:milktea_shop/view/widgets/sale_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          //header section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      'assets/images/avatar-with-black-hair-and-hoodie.png'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Good day',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // notifi icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
                //cart button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                //theme button
                GetBuilder<ThemeController>(
                    builder: (controller) => IconButton(
                        onPressed: () => controller.toggleTheme(),
                        icon: Icon(controller.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode)))
              ],
            ),
          ),

          //search bar
          const CustomSearchbar(),

          //categories chips
          const CategoryChips(),

          //Sale banner
          const SaleBanner(),

          //popular product

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sản phẩm phổ biến',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const AllProductScreen()),
                  child: Text(
                    'Hiển thị tất cả',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          //product grid
          const Expanded(child: ProductGrid())
        ],
      )),
    );
  }
}
