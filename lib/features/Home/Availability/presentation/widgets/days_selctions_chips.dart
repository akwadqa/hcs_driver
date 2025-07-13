import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

final List<String> weekDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

class DaysSelectionChips extends ConsumerWidget {
  const DaysSelectionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(
      availabilityControllerProvider.select((value) => value.selectedDays),
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
      ),
      shrinkWrap: true,
      itemCount: weekDays.length,
      itemBuilder: (context, index) {
        final day = weekDays[index];
        final isSelected = selectedDays.contains(day.toLowerCase());

        return GestureDetector(
          onTap: () {
            ref
                .read(availabilityControllerProvider.notifier)
                .toggleDaySelection(day.toLowerCase());
          },
          child: Container(
            width: 162.w,
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : AppColors.unSelectedGrey,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? BoxBorder.all(color: AppColors.blueTitle, width: 1.5)
                  : null,
            ),
            child: Text(
              day,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: isSelected
                    ? AppColors.blackText
                    : AppColors.unSelectedText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
