import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/data/models/packages_model.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/drop_down_textfield.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';

class PackagesDropdown extends StatelessWidget {
  final List<PackagesData> items;
  final PackagesData? selectedPackage;
  final Function(PackagesData) onSelected;

  const PackagesDropdown({
    super.key,
    required this.items,
    required this.selectedPackage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.packages),
          style: Theme.of(context).textTheme.displayMedium!,
        ),
        8.verticalSpace,
        DropDownField(
          enabled: true,
          value: selectedPackage?.id,
          items: items.map((pkg) => pkg.id).toList(),
          onChanged: (value) {
            final selected = items.firstWhere((pkg) => pkg.id == value);
            onSelected(selected);
          },
        ),
      ],
    );
  }
}
