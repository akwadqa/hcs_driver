import 'package:flutter/material.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/drop_down_textfield.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String? selecteditem;
  final Function(String) onSelected;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.selecteditem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropDownField(
      enabled: true,
      value: selecteditem,
      items: items.map((item) => item).toList(),
      onChanged: (value) {
        final selected = items.firstWhere((item) => item == value);
        onSelected(selected);
      },
    );
  }
}
