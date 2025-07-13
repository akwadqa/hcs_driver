import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/drop_down_textfield.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/data/models/discount_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';

class DiscountDropdown extends StatelessWidget {
  final List<Discount> items;
  final Discount? selectedItem;
  final Function(Discount) onSelected;

  const DiscountDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.discountType),
          style: Theme.of(context).textTheme.displayMedium!,
        ),
        8.verticalSpace,
        DropDownField(
          enabled: true,
          value: selectedItem?.title,
          items: items.map((disc) => disc.title).toList(),
          onChanged: (value) {
            final selected = items.firstWhere((disc) => disc.title == value);
            onSelected(selected);
          },
        ),
      ],
    );
  }
}
