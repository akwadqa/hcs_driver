import 'package:flutter/material.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class DropDownField extends StatelessWidget {
  final bool enabled;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const DropDownField({
    super.key,
    this.enabled = true,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isDense: true,
      iconEnabledColor: AppColors.blackText,
      borderRadius: BorderRadius.circular(8),
      elevation: 8,
      items: [
        for (var v in items)
          DropdownMenuItem(
            value: v,
            child: Text(
              v,
              style: Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
                color: AppColors.blackText,
              ),
            ),
          ),
      ],
      decoration: InputDecoration(
        hintText: 'Select',
        isDense: true,
        enabled: enabled,
        fillColor: enabled ? Colors.white : AppColors.unSelectedGrey,
      ),
      style: Theme.of(
        context,
      ).inputDecorationTheme.hintStyle!.copyWith(color: AppColors.blackText),
      onChanged: enabled ? onChanged : null,
    );
  }
}
