import 'package:flutter/material.dart';
import 'package:milktea_shop/models/item_option.dart';
import 'package:milktea_shop/utils/number_formatter.dart';

class OptionGroups extends StatefulWidget {
  final OptionGroup optionGroups;
  const OptionGroups({super.key, required this.optionGroups});

  @override
  State<OptionGroups> createState() => _OptionGroupsState();
}

class _OptionGroupsState extends State<OptionGroups> {
  late List<OptionGroup> _optionGroups;
  @override
  void initState() {
    super.initState();
    _optionGroups = _initializeDummyOptions();
  }

  List<OptionGroup> _initializeDummyOptions() {
    return [
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
  }

  /// Toggles the selection for an option within a single-choice group (Radio behavior).
  void _handleSingleChoice(
      int groupIndex, int optionIndex, ItemOption selectedOption) {
    setState(() {
      // Deselect all other options in this group.
      for (var option in _optionGroups[groupIndex].options) {
        option.isSelected = false;
      }
      // Select the new option.
      selectedOption.isSelected = true;
    });
  }

  /// Toggles the selection for an option within a multi-choice group (Checkbox behavior).
  void _handleMultiChoice(int groupIndex, int optionIndex) {
    setState(() {
      final option = _optionGroups[groupIndex].options[optionIndex];
      option.isSelected = !option.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _optionGroups.length,
        itemBuilder: (contex, groupIndex) {
          final group = _optionGroups[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '${group.title}${group.isRequired ? ' *Bắt buộc' : ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
// Options List
              ...List.generate(group.options.length, (optionIndex) {
                final option = group.options[optionIndex];
                final priceText = option.price > 0
                    ? ' (+${NumberFormatter.formatCurrency(option.price)}đ)'
                    : '';

                if (group.isSingleChoice) {
                  // === Radio Button (Single Choice) ===
                  return RadioListTile<ItemOption>(
                    title: Text('${option.name}$priceText'),
                    value: option,
                    groupValue: group.options.firstWhere(
                      (opt) => opt.isSelected,
                      // The 'orElse' ensures a valid state even if no item is selected
                      orElse: () => group.options.first,
                    ),
                    onChanged: (ItemOption? value) {
                      if (value != null) {
                        _handleSingleChoice(groupIndex, optionIndex, value);
                      }
                    },
                  );
                } else {
                  // === Checkbox (Multiple Choice) ===
                  return CheckboxListTile(
                    title: Text('${option.name}$priceText'),
                    value: option.isSelected,
                    onChanged: (bool? value) {
                      _handleMultiChoice(groupIndex, optionIndex);
                    },
                  );
                }
              }),
              const Divider(height: 20, thickness: 1),
            ],
          );
        },
      ),
    );
  }
}
