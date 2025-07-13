import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

/// ShiftTypeChips now reads initial selectedState from Riverpod
/// and updates purely via provider state, no internal index needed.
class ShiftTypeChips extends ConsumerWidget {
  const ShiftTypeChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Options labels
    final options = [
      ShiftType.morning,
      ShiftType.evening,
      ShiftType.fullDay,
    ].map(shiftTypeToString).toList();

    // Current selected from state
    final selectedShift = ref.watch(
      availabilityControllerProvider.select((s) => s.selectedShiftType),
    );
    final notifier = ref.read(availabilityControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.tr(AppStrings.shiftType),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        8.verticalSpace,
        Wrap(
          spacing: 19.w,
          runSpacing: 16.h,
          children: List.generate(options.length, (i) {
            final label = options[i];
            final isSelected = label == selectedShift;
            return GestureDetector(
              onTap: () => notifier.selectShift(label),
              child: Container(
                alignment: Alignment.center,
                width: 162.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white
                      : AppColors.unSelectedGrey,
                  border: isSelected
                      ? Border.all(color: AppColors.blueText, width: 0.5)
                      : null,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isSelected
                        ? AppColors.blueText
                        : AppColors.unSelectedText,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
