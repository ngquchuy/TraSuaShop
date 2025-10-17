// Model cho một lựa chọn cụ thể (Item)
class ItemOption {
  final String name;
  final double price;
  bool isSelected;

  ItemOption({required this.name, this.price = 0.0, this.isSelected = false});
}

// Model cho một nhóm tùy chọn (Group)
class OptionGroup {
  final String title;
  final bool isRequired; // Bắt buộc chọn
  final bool isSingleChoice; // True: Radio, False: Checkbox (chọn 1 hay nhiều)
  final List<ItemOption> options;

  OptionGroup({
    required this.title,
    this.isRequired = true,
    this.isSingleChoice = true,
    required this.options,
  });

  copyFrom(OptionGroup group) {}
}

final List<OptionGroup> options = [
  OptionGroup(
    title: 'Kích Cỡ',
    isRequired: true,
    isSingleChoice: true,
    options: [
      ItemOption(name: 'Size M', price: 0.0, isSelected: true),
      ItemOption(name: 'Size L', price: 10000),
      ItemOption(name: 'Size XL', price: 15000),
    ],
  ),
  OptionGroup(
    title: 'Mức Đường',
    isRequired: true,
    isSingleChoice: true,
    options: [
      ItemOption(name: '100% Đường'),
      ItemOption(name: '70% Đường', isSelected: true),
      ItemOption(name: '50% Đường'),
      ItemOption(name: '30% Đường'),
      ItemOption(name: 'Không Đường'),
    ],
  ),
  OptionGroup(
    title: 'Thêm Topping',
    isRequired: false,
    isSingleChoice: false,
    options: [
      ItemOption(name: 'Trân châu đen', price: 5000),
      ItemOption(name: 'Thạch phô mai', price: 8000),
      ItemOption(name: 'Kem Cheese', price: 12000),
      ItemOption(name: 'Bánh Plan', price: 10000),
    ],
  ),
  OptionGroup(
    title: 'Đá',
    isRequired: false,
    isSingleChoice: true,
    options: [
      ItemOption(name: 'Nhiều đá'),
      ItemOption(name: 'Ít đá', isSelected: true),
      ItemOption(name: 'Không đá'),
    ],
  ),
];
