import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_controller.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

/// A single employee chip with enabled/disabled styling.
class EmployeeBarChip extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onTap;
  bool enabled;
  EmployeeBarChip({
    super.key,
    required this.employee,
    this.onTap,
    required this.enabled,
  });

  @override
  State<EmployeeBarChip> createState() => _EmployeeBarChipState();
}

class _EmployeeBarChipState extends State<EmployeeBarChip> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.read(employeesControllerProvider.notifier);
        return GestureDetector(
          onTap: () {
            if (!widget.enabled) {
              controller.selectEmployee(widget.employee);
            } else {
              controller.unSelectEmployee(widget.employee);
            }
            setState(() {
              widget.enabled = !widget.enabled;
            });
          },

          child: Container(
            width: 345.w,
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: widget.enabled ? Colors.white : AppColors.unSelectedGrey,
              border: Border.all(
                style: widget.enabled ? BorderStyle.solid : BorderStyle.none,
                color: AppColors.primary,
              ),
            ),
            child: Text(
              widget.employee.employeeName,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: widget.enabled
                    ? AppColors.blackText
                    : AppColors.unSelectedText,
              ),
            ),
          ),
        );
      },
    );
  }
}
