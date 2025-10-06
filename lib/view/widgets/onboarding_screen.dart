import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _item = [
    OnboardingItem(
        description:
            'Bỏ qua việc xếp hàng. Lướt menu, chọn món yêu thích và nhận hàng nhanh chóng.',
        title: 'Chỉ cần 3 bước, Có ngay trà ngon!',
        image: 'assets/images/swipe.png'),
    OnboardingItem(
        description:
            'Tận hưởng các mã giảm giá, chương trình thành viên và quà tặng chỉ có trên ứng dụng.',
        title: 'Ưu Đãi Độc Quyền, Giảm Giá Sốc',
        image: 'assets/images/percent_discount.png'),
    OnboardingItem(
        description:
            'Thêm trân châu, bớt đá, điều chỉnh lượng đường. Trà sữa của bạn, do bạn quyết định!',
        title: 'Tùy Chỉnh Theo Cách Riêng Bạn',
        image: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding screen'),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
